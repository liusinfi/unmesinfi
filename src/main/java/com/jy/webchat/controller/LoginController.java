package com.jy.webchat.controller;

import com.jy.webchat.dao.RedisParentDao;
import com.jy.webchat.pojo.User;
import com.jy.webchat.service.IChatRoomsService;
import com.jy.webchat.service.ILogService;
import com.jy.webchat.service.ISysConfigService;
import com.jy.webchat.service.IUserService;
import com.jy.webchat.utils.*;
import com.jy.webchat.websocket.ChatServer;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@RequestMapping(value = "/user")
public class LoginController {
    @Resource private IUserService userService;
    @Resource private ILogService logService;
    @Resource(name="chatRoomsService") private IChatRoomsService chatRoomsService;
    @Resource(name="sysConfigService")public ISysConfigService sysConfigService;
    @Resource(name="redisParentDao") private RedisParentDao redisParentDao;

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(Model model,String show) {
        model.addAttribute("show",show);
        return "login1";
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String register() {
        return "register";
    }

    @RequestMapping(value = "/registerValidate",method = RequestMethod.GET,produces="text/html; charset=UTF-8" )
    @ResponseBody
    public String register(String userid, String password,String nickname, HttpSession session) {
        String regEx = "[ _`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(userid);
        if(m.find()){
            return "error|请不要用特殊字符";
        }
        User user = userService.selectUserByUserid(userid);
        if(user != null){
            return "error|已存在用户名";
        }
        return "success";
    }


    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerPost(String userid, String password,String nickname,Integer sex,RedirectAttributes attributes,HttpSession session,WordDefined defined, HttpServletRequest request) throws Exception {
        String regEx = "[ _`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(userid);
        if(m.find()){
            throw new Exception("包含特殊字符");
        }
        User user = userService.selectUserByUserid(userid);
        if(user != null){
            throw new Exception("已存在用户名");
        }
        user = new User();
        user.setUserid(userid);
        user.setPassword(EncryptUtil.encryptMd5(password));
        user.setProfile("");
        user.setProfilehead("upload/resizeApi.png");
        //user.setSex(sex);
        user.setNickname(nickname);
        user.setAge(0);
        user.setUserfont("");
        userService.insert(user);
        session.setAttribute("userid", userid);
        session.setAttribute("usertype", "2");
        session.setAttribute("login_status", true);
        attributes.addFlashAttribute("message", defined.LOGIN_SUCCESS);
        return "redirect:/unchk/first";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(@ModelAttribute("userid") String userid, @ModelAttribute("password") String password,Integer randomNum, HttpSession session, RedirectAttributes attributes
            ,String _q,WordDefined defined, CommonDate date, LogUtil logUtil, NetUtil netUtil, HttpServletRequest request) {
        String page = "redirect:/unchk/first";
        if("QA".equals(_q)){
            page = "redirect:/QAoper";
        }
        if(randomNum != null && redisParentDao.containsMaptKey(randomNum.toString())){
            Map<String,String> map = redisParentDao.getMap(randomNum.toString());
            String openid = map.get("phoneIme");
            User user = userService.selectUserByOpenid(openid);
            String picture = "";
            if(user.getProfilehead().indexOf("http")==0){
                String path = request.getServletContext().getRealPath("/") + "upload" + "/head";
                String fileName = EncryptUtil.encryptMd5(userid) + ".png";
                try {
                    download(user.getProfilehead(),fileName,path);
                    picture = path+File.separator+fileName;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if(StringUtils.isNotEmpty(picture)){
                user.setProfilehead(picture);
            }
            session.setAttribute("userid", user.getUserid());
            session.setAttribute("usertype", user.getUsertype());
            session.setAttribute("login_status", true);
            user.setLasttime(date.getTime24());
            userService.update(user);
            attributes.addFlashAttribute("message", defined.LOGIN_SUCCESS);
            return page;
        }
        User user = userService.selectUserByUserid(userid);
        if (user == null) {
            attributes.addFlashAttribute("error", defined.LOGIN_USERID_ERROR);
            return "redirect:/user/login";
        } else {
            if(ChatServer.checkExistSession(userid)){
                attributes.addFlashAttribute("errorinfo","您已登录!");
                return "redirect:/user/login";
            }
            if (!user.getPassword().equals(EncryptUtil.encryptMd5(password))) {
                attributes.addFlashAttribute("error", defined.LOGIN_PASSWORD_ERROR);
                return "redirect:/user/login";
            } else {
                if (user.getStatus() != 1) {
                    attributes.addFlashAttribute("error", defined.LOGIN_USERID_DISABLED);
                    return "redirect:/user/login";
                } else {
                    String picture = "";
                    if(user.getProfilehead().indexOf("http")==0){
                        String path = request.getServletContext().getRealPath("/") + "upload" + "/head";
                        String fileName = EncryptUtil.encryptMd5(userid) + ".png";
                        try {
                            download(user.getProfilehead(),fileName,path);
                            picture = "upload/head/"+fileName;
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    if(StringUtils.isNotEmpty(picture)){
                        user.setProfilehead(picture);
                    }
                    //logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_LOGIN, defined.LOG_DETAIL_USER_LOGIN, netUtil.getIpAddress(request)));
                    session.setAttribute("userid", userid);
                    session.setAttribute("usertype", user.getUsertype());
                    session.setAttribute("login_status", true);

                    user.setLasttime(date.getTime24());
                    userService.update(user);
                    attributes.addFlashAttribute("message", defined.LOGIN_SUCCESS);
                    return page;
                }
            }
        }
    }

    public static void download(String urlString, String filename,String savePath) throws Exception {
        // 构造URL
        URL url = new URL(urlString);
        // 打开连接
        URLConnection con = url.openConnection();
        //设置请求超时为5s
        con.setConnectTimeout(5*1000);
        // 输入流
        InputStream is = con.getInputStream();

        // 1K的数据缓冲
        byte[] bs = new byte[1024];
        // 读取到的数据长度
        int len;
        // 输出的文件流
        File sf=new File(savePath);
        if(!sf.exists()){
            sf.mkdirs();
        }
        OutputStream os = new FileOutputStream(sf.getPath()+File.separator+filename);
        // 开始读取
        while ((len = is.read(bs)) != -1) {
            os.write(bs, 0, len);
        }
        // 完毕，关闭所有链接
        os.close();
        is.close();
    }



    @RequestMapping(value = "/logout")
    public String logout(String m,HttpSession session, RedirectAttributes attributes, WordDefined defined) {
        session.removeAttribute("userid");
        session.removeAttribute("login_status");
        if("QA".equals(m)){
            return "redirect:/QAlogin";
        }
        //attributes.addFlashAttribute("message", defined.LOGOUT_SUCCESS);
        return "redirect:/user/login";
    }

    @RequestMapping(value = "/wxauth", method = RequestMethod.GET)
    public String wxauth(HttpSession session,String code,RedirectAttributes attributes, WordDefined defined) {

        Map<String, String> result = WxAuthUtil.getUserInfoAccessToken(code);//通过这个code获取access_token
        String openId = result.get("openid");
        String wxuserid = "";
        int password = (int)((Math.random()*9+1)*100000);
        if (StringUtils.isNotEmpty(openId)) {
            Map<String, String> userInfo = WxAuthUtil.getUserInfo(result.get("access_token"), openId);//使用access_token获取用户信息
            if(userInfo.containsKey("openid")){
                wxuserid = userInfo.get("nickname");
                User user = userService.selectUserByUserid(wxuserid);
                if(user==null ){
                    user = new User();
                    user.setUserid(wxuserid);
                    user.setPassword("wxuser");
                    user.setProfilehead(userInfo.get("headimgurl"));
                    user.setAge(0);
                    user.setStatus(1);
                    user.setOpenid(openId);
                    userService.insert(user);
                }else if(!StringUtils.equals(userInfo.get("openid"),user.getOpenid())){
                    user = new User();
                    int x = new Random().nextInt(9) +1;
                    wxuserid = wxuserid + x;
                    user.setUserid(wxuserid);
                    user.setPassword(EncryptUtil.encryptMd5(openId));
                    user.setProfilehead(userInfo.get("headimgurl"));
                    user.setAge(0);
                    user.setStatus(1);
                    user.setOpenid(openId);
                    userService.insert(user);
                }
            }else{
                attributes.addFlashAttribute("errorinfo","扫描登录出错");
                return "redirect:/user/login";
            }
        }else{
            attributes.addFlashAttribute("errorinfo","扫描登录出错");
            return "redirect:/user/login";
        }
        attributes.addFlashAttribute("userid", wxuserid);
        attributes.addFlashAttribute("password", openId);
        return "redirect:/user/login";
    }

    /**
     * 微信消息接收和token验证
     * @param model
     * @param request
     * @param response
     * @throws IOException
     */
    @RequestMapping("/wxmsg")
    public void auth(Model model, HttpServletRequest request,
                     HttpServletResponse response) throws IOException {
        boolean isGet = request.getMethod().toLowerCase().equals("get");
        PrintWriter print;
        if (isGet) {
            // 微信加密签名
            String signature = request.getParameter("signature");
            // 时间戳
            String timestamp = request.getParameter("timestamp");
            // 随机数
            String nonce = request.getParameter("nonce");
            // 随机字符串
            String echostr = request.getParameter("echostr");
            // 通过检验signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败
            if (signature != null
                    && WxAuthUtil.checkSignature(signature, timestamp, nonce)) {
                try {
                    print = response.getWriter();
                    print.write(echostr);
                    print.flush();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @RequestMapping(value = "/wxmsg", method = RequestMethod.POST)
    public void message(Model model, HttpServletRequest request,HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // xml格式的消息数据
        String respXml = null;
        // 默认返回的文本消息内容
        String respContent = "未知的消息类型！";
        try {
            // 调用parseXml方法解析请求消息
            Map<String,String> requestMap = MessageUtil.parseXml(request);
            // 发送方帐号
            String fromUserName = requestMap.get("FromUserName").toString();
            // 开发者微信号
            String toUserName = requestMap.get("ToUserName").toString();
            // 消息类型
            String msgType = requestMap.get("MsgType").toString();

            // 回复文本消息
            /*TextMessage textMessage = new TextMessage();
            textMessage.setToUserName(fromUserName);
            textMessage.setFromUserName(toUserName);
            textMessage.setCreateTime(new Date().getTime());
            textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);*/

            /*System.out.println("==================msgType" + msgType);
            System.out.println("==================Event" + requestMap.get("Event"));
            System.out.println("==================eventKey" + requestMap.get("EventKey"));
            System.out.println("==================Ticket" + requestMap.get("Ticket"));
            System.out.println("==================ToUserName" + requestMap.get("ToUserName"));
            System.out.println("==================FromUserName" + requestMap.get("FromUserName"));
            System.out.println("==================CreateTime" + requestMap.get("CreateTime"));*/
            // 事件推送
            if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
                // 事件类型
                String eventType = requestMap.get("Event");
                String eventKey = requestMap.get("EventKey");
                // 关注
                if (eventType.equals(MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
                    //获取用户信息
                    String requestUrl = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=ACCESS_TOKEN&openid=OPENID";
                    requestUrl = requestUrl.replace("ACCESS_TOKEN", WxAuthUtil.getAccessToken()).replace("OPENID", fromUserName);
                    String result = HttpRequestUtil.get(requestUrl);
                    Gson ticket_gson = new Gson();
                    JsonObject info = ticket_gson.fromJson(result, JsonObject.class);
                    String nickname = info.get("nickname").toString().replaceAll("\"", "");
                    String address = info.get("country")+"-"+info.get("province")+"-"+info.get("city");
                    String headimgurl = info.get("headimgurl").toString().replaceAll("\"", "");

                    HashMap params = new HashMap();
                    params.put("phoneIme", fromUserName);
                    params.put("state", 1);
                    params.put("location", address);
                    params.put("realName", nickname);
                    params.put("nickname", nickname);
                    params.put("headimgurl", headimgurl);

                    //入库
                    String nicknamebak = wxregister(fromUserName,params);
                    params.put("nickname", nicknamebak);
                    //sapp.put(eventKey.replace("qrscene_", ""),params);
                    redisParentDao.setCacheMap(eventKey.replace("qrscene_", ""),params,300);
                }
                // 取消关注
                else if (eventType.equals(MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
                    // TODO 取消订阅后用户不会再收到公众账号发送的消息，因此不需要回复
                }
                // 扫描带参数二维码
                else if (eventType.equals(MessageUtil.EVENT_TYPE_SCAN)) {
                    if(StringUtils.isNotBlank(eventKey)){
                        //获取用户信息
                        String requestUrl = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=ACCESS_TOKEN&openid=OPENID";
                        requestUrl = requestUrl.replace("ACCESS_TOKEN", WxAuthUtil.getAccessToken()).replace("OPENID", fromUserName);
                        String result = HttpRequestUtil.get(requestUrl);
                        Gson ticket_gson = new Gson();
                        JsonObject info = ticket_gson.fromJson(result, JsonObject.class);
                        String nickname = info.get("nickname").toString().replaceAll("\"", "");
                        String address = info.get("country")+"-"+info.get("province")+"-"+info.get("city");
                        String headimgurl = info.get("headimgurl").toString().replaceAll("\"", "");

                        HashMap params = new HashMap();
                        params.put("phoneIme", fromUserName);
                        params.put("state", 1);
                        params.put("location", address);
                        params.put("realName", nickname);
                        params.put("nickname", nickname);
                        params.put("headimgurl", headimgurl);
                        params.put("equipmentType", eventKey);
                        //入库
                        String nicknamebak = wxregister(fromUserName,params);
                        params.put("nickname", nicknamebak);
                        //sapp.put(eventKey.replace("qrscene_", ""),params);
                        redisParentDao.setCacheMap(eventKey.replace("qrscene_", ""),params,300);
                    }
                }
                // 上报地理位置
                else if (eventType.equals(MessageUtil.EVENT_TYPE_LOCATION)) {
                    // TODO 处理上报地理位置事件
                }
                // 自定义菜单
                else if (eventType.equals(MessageUtil.EVENT_TYPE_CLICK)) {
                    // TODO 处理菜单点击事件
                }
            }
            // 设置文本消息的内容
            //textMessage.setContent(respContent);
            // 将文本消息对象转换成xml
            //respXml = MessageUtil.messageToXml(textMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 响应消息
        //PrintWriter out = response.getWriter();
        //out.print(respXml);
        //out.close();
    }

    private String wxregister(String openId,HashMap userInfo){
        String wxuserid = "";
        if(StringUtils.isNotEmpty(openId)){

            User user1 = userService.selectUserByOpenid(openId);
            if(user1 !=null){
                return user1.getUserid();
            }
            wxuserid = userInfo.get("nickname").toString();
            User user = userService.selectUserByUserid(wxuserid);
            if(user==null ){
                //如果不存在，给他注册一个
                user = new User();
                user.setUserid(wxuserid);
                user.setPassword(EncryptUtil.encryptMd5(openId));
                user.setProfilehead(userInfo.get("headimgurl").toString());
                user.setAge(0);
                user.setStatus(1);
                user.setOpenid(openId);
                userService.insert(user);
            }else if(user!=null && !StringUtils.equals(openId,user.getOpenid())){
                //如果存在，但是openid不一致，说明不同用户昵称一样。给昵称加一个随机数。
                user = new User();
                int x = new Random().nextInt(9) +1;
                wxuserid = wxuserid + x;
                user.setUserid(wxuserid);
                user.setPassword(EncryptUtil.encryptMd5(openId));
                user.setProfilehead(userInfo.get("headimgurl").toString());
                user.setAge(0);
                user.setStatus(1);
                user.setOpenid(openId);
                userService.insert(user);

            }else{
                //存在了，不用注册。
            }
        }
        return wxuserid;
    }


    @RequestMapping("/wxqrcode")
    @ResponseBody
    public String wxqrcode(Model model, HttpServletRequest request,Integer senid,
                     HttpServletResponse response) throws IOException {
        return WxAuthUtil.createTempTicket(WxAuthUtil.getAccessToken(),"6400",senid);
    }

    @RequestMapping("/existslx")
    @ResponseBody
    public String existslx(Model model, HttpServletRequest request,Integer randomNum,RedirectAttributes attributes,HttpSession session,
                           WordDefined defined,HttpServletResponse response) throws IOException {
        if(redisParentDao.containsMaptKey(randomNum.toString())){
            return "success";
        }
        return "error";
    }

}
