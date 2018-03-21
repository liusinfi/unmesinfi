package com.jy.webchat.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jy.webchat.dao.RedisParentDao;
import com.jy.webchat.pojo.*;
import com.jy.webchat.service.*;
import com.jy.webchat.utils.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@SessionAttributes("userid")
public class UserController {

    @Resource private User user;
    @Resource private IUserService userService;
    @Resource(name="chatRoomsService") private IChatRoomsService chatRoomsService;
    @Resource(name="roomMemberService")public IRoomMemberService roomMemberService;
    @Resource(name="sysConfigService")public ISysConfigService sysConfigService;
    @Resource(name="redisParentDao") private RedisParentDao redisParentDao;

    /**
     * 显示个人信息编辑页面
     * @param sessionid
     * @return
     */
    @RequestMapping(value = "/config")
    public ModelAndView setting( @ModelAttribute("userid") String sessionid,String terminalType,HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        String usertype = (String)request.getSession().getAttribute("usertype");
        ModelAndView view = new ModelAndView("info-setting-user");
        if(Integer.valueOf(usertype)<=0){
            view = new ModelAndView("info-setting");
        }
        if("phone".equals(terminalType)){
            view = new ModelAndView("phone/info-config");
        }
        user = userService.selectUserByUserid(userid);
        user.setPassword("");
        view.addObject("user", user);
        return view;
    }


    /**
     * 更新用户信息
     * @param sessionid
     * @param user
     * @return
     */
    @RequestMapping(value = "/update",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    public String  update( @ModelAttribute("userid") String sessionid, User user, RedirectAttributes attributes,
                          NetUtil netUtil, LogUtil logUtil, CommonDate date, WordDefined defined, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        user.setUserid(userid);
        boolean flag = userService.update(user);
        if(flag){
//            logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_UPDATE, defined.LOG_DETAIL_UPDATE_PROFILE, netUtil.getIpAddress(request)));
            attributes.addFlashAttribute("message", "["+userid+"]资料更新成功!");
        }else{
            attributes.addFlashAttribute("error", "["+userid+"]资料更新失败!");
        }
        return "redirect:/config";
    }
    @RequestMapping(value = "/update1",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  update1(@ModelAttribute("userid") String sessionid, User user,
                          NetUtil netUtil, LogUtil logUtil, CommonDate date, WordDefined defined, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        user.setUserid(userid);
        boolean flag = userService.update(user);
        if(flag){
            //logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_UPDATE, defined.LOG_DETAIL_UPDATE_PROFILE, netUtil.getIpAddress(request)));
        }else{
            return "资料更新失败";
        }
        return "资料更新成功";
    }

    /**
     * 修改密码
     * @param oldpass
     * @param newpass
     * @return
     */
    @RequestMapping(value = "/pass",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    public String changePassword( String oldpass, String newpass,String newpasscf, RedirectAttributes attributes,
                                 NetUtil netUtil, LogUtil logUtil, CommonDate date, WordDefined defined, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        user = userService.selectUserByUserid(userid);
        if(StringUtils.isEmpty(oldpass)){
            attributes.addFlashAttribute("error", "请输入旧密码");
            return "redirect:/config";
        }
        if(StringUtils.isEmpty(newpass) || StringUtils.isEmpty(newpasscf) ){
            attributes.addFlashAttribute("error", "请输入新密码");
            return "redirect:/config";
        }
        if(!newpass.equals(newpasscf)){
            attributes.addFlashAttribute("error", "确认密码不一致");
            return "redirect:/config";
        }
        if(StringUtils.isNotEmpty(user.getOpenid())){
            user.setPassword(EncryptUtil.encryptMd5(newpass));
            boolean flag = userService.update(user);
            return "redirect:/config";
        }
        if(EncryptUtil.encryptMd5(oldpass).equals(user.getPassword())){
            user.setPassword(EncryptUtil.encryptMd5(newpass));
            boolean flag = userService.update(user);
            if(flag){
//                logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_UPDATE, defined.LOG_DETAIL_UPDATE_PASSWORD, netUtil.getIpAddress(request)));
                attributes.addFlashAttribute("message", "["+userid+"]密码更新成功!");
            }else{
                attributes.addFlashAttribute("error", "["+userid+"]密码更新失败!");
            }
        }else{
            attributes.addFlashAttribute("error", "密码错误!");
        }
        return "redirect:/config";
    }

    @RequestMapping(value = "/pass1",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String changePassword1( String oldpass, String newpass,String newpasscf, RedirectAttributes attributes,
                                 NetUtil netUtil, LogUtil logUtil, CommonDate date, WordDefined defined, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        if(StringUtils.isEmpty(oldpass)){
            return "请输入旧密码";
        }
        if(StringUtils.isEmpty(newpass) || StringUtils.isEmpty(newpasscf) ){
            return "请输入新密码";
        }
        if(!newpass.equals(newpasscf)){
            return "确认密码不一致";
        }
        user = userService.selectUserByUserid(userid);
        if(EncryptUtil.encryptMd5(oldpass).equals(user.getPassword())){
            user.setPassword(EncryptUtil.encryptMd5(newpass));
            boolean flag = userService.update(user);
            if(flag){
//                logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_UPDATE, defined.LOG_DETAIL_UPDATE_PASSWORD, netUtil.getIpAddress(request)));
                return "密码更新成功。";
            }else{
                return "密码更新失败!";
            }
        }else{
            return "原密码错误！";
        }
    }

    @RequestMapping(value = "/isNeedPass",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  isNeedPass( Integer roomid, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        String usertype = (String)request.getSession().getAttribute("usertype");
        User user = userService.selectUserByUserid(userid);
        if(user.getUsertype().equals(usertype) && Integer.valueOf(usertype)<=0){
            return "no";
        }
        RoomMember roomMember = new RoomMember();
        roomMember = roomMemberService.selectByPrimaryKey(userid,String.valueOf(roomid));
        if(roomMember!=null){
            if(roomMember.getBlacktype() ==0){
                return "no";
            }else if(roomMember.getBlacktype() ==1){
                return "error|你已被踢出聊天室!";
            }else{
                return "no";
            }
        }
        return "yes";
    }

    @RequestMapping(value = "/checkRoomPass",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  update( Integer roomid,String password, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        String usetype = (String)request.getSession().getAttribute("usertype");
        User user = userService.selectUserByUserid(userid);
        if(user.getUsertype().equals(usetype) && Integer.valueOf(usetype)<=0){
            return "success";
        }
        ChatRoomsWithBLOBs blo =  chatRoomsService.selectByPrimaryKey(roomid);
        if(blo == null){
            return "error|不存在该聊天室!";
        }
        if(!blo.getPassword().equals(password)){
            return "error|密码错误!";
        }
        return "success";
    }
    /**
     * 头像上传
     * @param file
     * @param request
     * @return
     */
    @RequestMapping(value = "/upload")
    public String upload( MultipartFile file, HttpServletRequest request, UploadUtil uploadUtil,
                         RedirectAttributes attributes, NetUtil netUtil, LogUtil logUtil, CommonDate date, WordDefined defined){
        String userid = (String)request.getSession().getAttribute("userid");
        try{
            String fileurl = uploadUtil.upload(request, "upload", userid);
            user = userService.selectUserByUserid(userid);
            user.setProfilehead(fileurl);
            boolean flag = userService.update(user);
            if(flag){
                //logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_UPDATE, defined.LOG_DETAIL_UPDATE_PROFILEHEAD, netUtil.getIpAddress(request)));
                attributes.addFlashAttribute("message", "["+userid+"]头像更新成功!");
            }else{
                attributes.addFlashAttribute("error", "["+userid+"]头像更新失败!");
            }
        } catch (Exception e){
            attributes.addFlashAttribute("error", "["+userid+"]头像更新失败!");
        }
        return "redirect:/config";
    }


    @RequestMapping(value = "/uploadajax", produces="text/html; charset=UTF-8",method = RequestMethod.POST)
    @ResponseBody
    public String uploadajax(String isHead, MultipartFile file, HttpServletRequest request, UploadUtil uploadUtil){
        try{
            if(file!=null){
                String orfilename = file.getOriginalFilename();
                String reg = ".+(.JPEG|.jpeg|.JPG|.jpg|.GIF|.gif|.BMP|.bmp|.PNG|.png)$";
                Pattern pattern = Pattern.compile(reg);
                Matcher matcher = pattern.matcher(orfilename.toLowerCase());
                if(!matcher.find()){
                    return "error|请上传图片";
                }
            }
            String userid = (String)request.getSession().getAttribute("userid");
            if(StringUtils.isEmpty(isHead)){
                isHead = "false";
            }
            request.setAttribute("isHeadImg",isHead);
            String fileurl = uploadUtil.upload(request, "upload", userid);
            if(fileurl !=null && fileurl.indexOf("error|")>=0){
                return fileurl;
            }
            if("true".equals(isHead)){
                user = userService.selectUserByUserid(userid);
                user.setProfilehead(fileurl);
                userService.update(user);
            }
            return "success|" + fileurl + "|" + "上传成功";

        } catch (Exception e){
            return "error|上传失败";
        }
    }

    /**
     * 获取用户头像
     */
    @RequestMapping(value = "{userid}/head")
    public void head(@PathVariable("userid") String userid, HttpServletRequest request, HttpServletResponse response){
        try {
            userid = java.net.URLDecoder.decode(userid, "UTF-8");
            user = userService.selectUserByUserid(userid);
            String path = user.getProfilehead();
            if(path!=null && path.indexOf("http")==0){
                readInputStream(path,response);
            }else{
                String rootPath = request.getSession().getServletContext().getRealPath("/");
                String picturePath = rootPath + path;
                response.setContentType("image/jpeg; charset=UTF-8");
                ServletOutputStream outputStream = response.getOutputStream();
                FileInputStream inputStream = new FileInputStream(picturePath);
                byte[] buffer = new byte[1024];
                int i = -1;
                while ((i = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, i);
                }
                outputStream.flush();
                outputStream.close();
                inputStream.close();
                outputStream = null;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void readInputStream(String path,HttpServletResponse response){

        InputStream inStream = null;
        ServletOutputStream outStream = null;
        try {
            URL url = new URL(path);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5 * 1000);
            inStream = conn.getInputStream();//通过输入流获取图片数据
            response.setContentType("image/jpeg; charset=UTF-8");
            outStream = response.getOutputStream();
            byte[] buffer = new byte[1024];
            int len = 0;
            while( (len=inStream.read(buffer)) != -1 ){
                outStream.write(buffer, 0, len);
            }
            inStream.close();
            outStream.flush();
            outStream.close();
        } catch (Exception e){
            e.printStackTrace();
        }finally {
            if (inStream!=null)
                try {
                    inStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            if(outStream!=null){
                try {
                    outStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }



    @RequestMapping(value = "/userlist",produces="text/html; charset=UTF-8",method = RequestMethod.GET)
    public ModelAndView selectUserPage( @RequestParam(required=true,defaultValue="1") Integer pageNum,
                                   @RequestParam(required=false,defaultValue="10") Integer pageSize,Integer roomid,String searchuserid,HttpServletRequest request) throws Exception {
        String usertype = (String)request.getSession().getAttribute("usertype");
        if(Integer.valueOf(usertype)>0){
            throw new Exception("不是管理员");
        }
        ModelAndView view = new ModelAndView("usermanage");
        PageHelper.startPage(pageNum, pageSize);
        User user = new User();
        if(StringUtils.isNotEmpty(searchuserid)){
            searchuserid = java.net.URLDecoder.decode(searchuserid, "UTF-8");
            user.setUserid(searchuserid);
        }
        List<User> list = userService.selectUserPage(user);
        PageInfo page = new PageInfo(list);
        long count = page.getTotal();
        view.addObject("count", count);
        view.addObject("page", page);
        view.addObject("pageNum", pageNum);
        view.addObject("searchuserid", searchuserid);
        return view;
    }





    @RequestMapping(value = "/secretchatk", produces="text/html; charset=UTF-8",method = RequestMethod.POST)
    @ResponseBody
    public String secretchat(HttpServletRequest request){
        try{
            String userid1 = (String)request.getSession().getAttribute("userid");
            /*if(!userid1.equals(userid)){
                return "error";
            }*/
            User user = userService.selectUserByUserid(userid1);
            if(user !=null && Integer.valueOf(user.getUsertype()) <2){
                return "success";
            }else{
                return "error";
            }
        } catch (Exception e){
            return e.getMessage();
        }
    }
    @RequestMapping(value = "/scontent", produces="text/html; charset=UTF-8",method = RequestMethod.GET)
    @ResponseBody
    public String scontent(HttpServletRequest request,String roomId){
        try{
            if(StringUtils.isNotEmpty(roomId)){
                ChatRoomsWithBLOBs ch= chatRoomsService.selectByPrimaryKey(Integer.valueOf(roomId));
                return ch.getRoomnotice();
            }else{
                SysConfig sysConfig = sysConfigService.selectByPrimaryKey(1);
                return sysConfig.getSyscontent();
            }
        } catch (Exception e){
            return "";
        }
    }


    @RequestMapping(value = "/chatHistory",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String chatHistory(String beOperedId,String roomId, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        try {
            List chatList = redisParentDao.getList("room"+roomId,0,-1);
            String jsonString = JSONArray.toJSONString(chatList);
            return jsonString;
        } catch (Throwable e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "/chatHistoryPage",produces="text/html; charset=UTF-8", method = RequestMethod.GET)
    @ResponseBody
    public String chatHistoryPage(@RequestParam(required=true,defaultValue="1") Integer pageNum,
                                  @RequestParam(required=false,defaultValue="10") Integer pageSize,String roomId, HttpServletRequest request){
        try {
            Map rtn = new HashMap();
            long total = redisParentDao.getListSize("room"+roomId);
            long totalPages =  total/10 + (total%10==0?0:1);
            int start = (pageNum-1)*pageSize;
            int end = pageNum * pageSize -1;
            List chatList = redisParentDao.getList("room"+roomId,start,end);
            rtn.put("totalPages",String.valueOf(totalPages));
            rtn.put("pageNum",String.valueOf(pageNum));
            rtn.put("chatList",chatList);
            rtn.put("total",total);
            //String jsonString = JSONArray.toJSONString(chatList);
            return JSONObject.toJSONString(rtn);
            //return jsonString;
        } catch (Throwable e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "/DoUploadImg", produces="text/html; charset=UTF-8",method = RequestMethod.POST)
    @ResponseBody
    public String DoUploadImg(String isHead,String imgData, HttpServletRequest request){
        String[] splists = imgData.split(",");
        String imgSuffix = splists[0];
        String userid = (String)request.getSession().getAttribute("userid");
        boolean isHeadImg = true;
        if(StringUtils.isEmpty(isHead)){
            isHeadImg = false;
        }
        String flag = UploadUtil.GenerateImage(splists[2],imgSuffix,request,isHeadImg,userid);
        if(flag !=null && flag.indexOf("error|")>=0){
            return flag;
        }
        if(isHeadImg){
            user = userService.selectUserByUserid(userid);
            user.setProfilehead(flag);
            userService.update(user);
        }
        return "success|" + flag + "|" + "上传成功";
    }
}
