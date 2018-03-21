package com.jy.webchat.controller;

import com.jy.webchat.dao.RedisParentDao;
import com.jy.webchat.pojo.*;
import com.jy.webchat.service.IChatRoomsService;
import com.jy.webchat.service.IRoomMemberService;
import com.jy.webchat.service.ISysConfigService;
import com.jy.webchat.service.IUserService;
import com.jy.webchat.utils.BeanUtil;
import com.jy.webchat.websocket.ChatServer;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@SessionAttributes("userid")
@RequestMapping(value = "unchk")
public class UnCheckController {
    @Resource
    private IUserService userService;
    @Resource(name="chatRoomsService")
    private IChatRoomsService chatRoomsService;
    @Resource(name="roomMemberService")
    public IRoomMemberService roomMemberService;
    @Resource(name="sysConfigService")
    public ISysConfigService sysConfigService;
    @Resource(name="redisParentDao")
    private RedisParentDao redisParentDao;

    @RequestMapping(value = "/groupvisited")
    public ModelAndView groupvisited(HttpServletRequest request) {
        ModelAndView view = new ModelAndView("phone/group-visithis");
        String userid = (String)request.getSession().getAttribute("userid");
        List visitedList = qryVisitedRoom(userid);
        view.addObject("visitgroups", visitedList);
        return view;
    }

    @RequestMapping(value = "/first")
    public String first(HttpServletRequest request,HttpSession session,String show,Model model){
        return "index_v";
    }

    @RequestMapping(value = "/index")
    public String getIndex(HttpServletRequest request,HttpSession session,String show,String m,Model model){
        //查询聊天室列表，存在redis
        List chatrooms  = qryRooms();
        String userid = (String)request.getSession().getAttribute("userid");
        if(StringUtils.isNotEmpty(userid) && userid.indexOf("YKMODE")==0){
            return "redirect:/user/logout";
        }
        //已经登录了
        if(isLogin(request)){
            //登录了需要获取
        	List<ChatRoomsWithBLOBs> visitedList = chatRoomsService.selectUserVisited(userid);
            //long visitGrpSize = redisParentDao.getListSize(CVALUE.USER_VISITED+userid);
        	long visitGrpSize = (visitedList!=null&&visitedList.size()>0)?visitedList.size():0l;
            model.addAttribute("visitGrpSize", visitGrpSize);
            User user = userService.selectUserByUserid(userid);user.setPassword("");
            model.addAttribute("user", user);
            //加载管理员列表到redis
            User user1 = new User();user1.setUsertype("0");
            List<User> adminusers = userService.selectUserPage(user1);
            for(User user2 : adminusers){
                redisParentDao.cacheSet("adminuser",user2.getUserid());
            }
        }
        model.addAttribute("ChatRooms", chatrooms);
        model.addAttribute("show", show);
        model.addAttribute("countMap", allNumCount(chatrooms));
        SysConfig sysConfig = sysConfigService.selectByPrimaryKey(1);
        request.getSession().setAttribute("syscontent",sysConfig.getSyscontent());
        request.getSession().setAttribute("syslocate",sysConfig.getSyslocate());
        request.getSession().setAttribute("onlineconsult",sysConfig.getOnlineconsult());
        request.getSession().setAttribute("syshost",sysConfig.getSyshost());
        if("p".equals(m)){
            return "phone/index_v2";
        }
        return "index_v1";
    }

    //去过的群组
    @RequestMapping(value = "/jumptopass")
    public String access(HttpServletRequest request, String roomid,String screenHeight, Model model,RedirectAttributes attributes) {
        model.addAttribute("roomid", roomid);
        return "phone/accessRoom";
    }


    @RequestMapping(value = "/jumpchat",produces="text/html; charset=UTF-8")
    public ModelAndView jumpchat(@ModelAttribute("roomid") String roomid, @ModelAttribute("password")String password,
                                 @ModelAttribute("scrnhei")String scrnhei,
                                 RedirectAttributes attributes, HttpServletRequest request){
        return chatRoute(roomid,password,"iphone",scrnhei,attributes,request);
    }

    @RequestMapping(value = "/cwat",produces="text/html; charset=UTF-8")
    public ModelAndView cwat(String roomid, String password, String scrnhei,  RedirectAttributes attributes, HttpServletRequest request){
        return chatRoute(roomid,password,"web",scrnhei,attributes,request);
    }
    @RequestMapping(value = "/caat",produces="text/html; charset=UTF-8")
    public ModelAndView caat(String roomid,String password,String scrnhei,RedirectAttributes attributes,HttpServletRequest request){
        return chatRoute(roomid,password,"android",scrnhei,attributes,request);
    }
    @RequestMapping(value = "/ciat",produces="text/html; charset=UTF-8")
    public ModelAndView ciat(String roomid,String password,String scrnhei,RedirectAttributes attributes,HttpServletRequest request){
        return chatRoute(roomid,password,"iphone",scrnhei,attributes,request);
    }

    public ModelAndView chatRoute(String roomid,String password,String webtype,String scrnhei,RedirectAttributes attributes,HttpServletRequest request){
        ModelAndView view =  null;
        view = new ModelAndView("webchat");
        if(webtype.equals("iphone")){
            view = new ModelAndView("phone/phonechat");
        }
        String code = canVisited(roomid,password,request);
        if(!"0".equals(code)){
            view = new ModelAndView("index");
            view.addObject(CVALUE.ERRORINFO, CVALUE.transCode(code));
            view.addObject("ChatRooms", qryRooms());
            return view;
        }

        String userid = (String)request.getSession().getAttribute("userid");
        if(StringUtils.isEmpty(userid)){
            userid = "YKMODE"+System.currentTimeMillis();
            request.getSession().setAttribute("userid",userid);
        }
        if(ChatServer.checkExistSession(userid)){
            view = new ModelAndView("index");
            view.addObject(CVALUE.ERRORINFO, "您已经进入聊天室。退出其它客户端或退出浏览器重新登录！");
            view.addObject("ChatRooms", qryRooms());
            return view;
        }
        if(isLogin(request)){
            User user = userService.selectUserByUserid(userid);
            view.addObject("user", user);
        }
        view.addObject("roomid",roomid);
        ChatRoomsWithBLOBs chatRoomsWithBLOBs = chatRoomsService.selectByPrimaryKey(Integer.valueOf(roomid));
        view.addObject("roomTitle",chatRoomsWithBLOBs.getRoomtitle());
        view.addObject("roomNotice",chatRoomsWithBLOBs.getRoomnotice());
        List<User> luser = userService.selectAllMember(roomid);
        /*String jsonString = JSONArray.toJSONString(luser);
        view.addObject("roommembers",jsonString);*/
        view.addObject("roomlists",luser);
        DecimalFormat df1 = new DecimalFormat("000");
        view.addObject("chathei1",df1.format(Double.valueOf(scrnhei)*0.9));//web iframe的高度
        view.addObject("chathei2",df1.format(Double.valueOf(scrnhei)*0.9-164));//web聊天显示区的高度
        view.addObject("chathei3",df1.format(Double.valueOf(scrnhei)*0.9-64));//web群成员的高度
        view.addObject("chathei4",df1.format(Double.valueOf(scrnhei)-112));//iOS聊天显示区的高度
        view.addObject("chathei5",df1.format(Double.valueOf(scrnhei)-70));//iOS侧边栏的高度
        view.addObject("chathei6",df1.format(Double.valueOf(scrnhei)-170-150));//iOS侧边栏群成员的高度 150公告的高度
        return view;
    }

    private boolean isLogin(HttpServletRequest request){
        HttpSession session = request.getSession();
        if(session != null && session.getAttribute("login_status") != null){
            return true;
        }else{
            return false;
        }
    }

    //聊天室列表
    private List qryRooms(){
        /*List chatrooms  = redisParentDao.getList(CVALUE.ROOM_LIST,0,100);
        if(!(chatrooms!=null && chatrooms.size() > 0)){//如果redis里面没有，从数据库里面查
            chatrooms = chatRoomsService.selectAll(0,100);
            redisParentDao.cacheListObj(CVALUE.ROOM_LIST,chatrooms,-1);
        }*/
    	List chatrooms = chatRoomsService.selectAll(0,100);
        return chatrooms;
    }
    //用户去过的群组
    private List qryVisitedRoom(String userid){
        /*List visitedList = redisParentDao.getList(CVALUE.USER_VISITED+userid,0,100);
        if(!(visitedList!=null && visitedList.size()>0)){
            visitedList = chatRoomsService.selectUserVisited(userid);
            if(visitedList!=null && visitedList.size()>0)
                redisParentDao.cacheListObj(CVALUE.USER_VISITED+userid,visitedList,-1);
            visitedList = redisParentDao.getList(CVALUE.USER_VISITED+userid,0,100);
        }*/
    	List visitedList = chatRoomsService.selectUserVisited(userid);
        return visitedList;
    }
    //用户是否去过某聊天室
    private boolean isVisiedRoom(String userid,String roomid){
        List visitedList = qryVisitedRoom(userid);
        if(visitedList!=null && visitedList.size()>0){
            for(int i=0;i<visitedList.size();i++){
                ChatRoomsWithBLOBs ck = null;
                if(visitedList.get(i) instanceof LinkedHashMap){
                    ck = (ChatRoomsWithBLOBs)BeanUtil.mapToBean(ChatRoomsWithBLOBs.class,(LinkedHashMap)visitedList.get(i));
                }else{
                    ck = (ChatRoomsWithBLOBs)visitedList.get(i);
                }
                if(ck.getId() == Integer.valueOf(roomid)){
                    return true;
                }
            }
        }
        return false;
    }
    //房间是否存在password
    private boolean existsRoomPass(String roomid){
        List rooms = qryRooms();
        for(int i=0;i<rooms.size();i++){
            ChatRoomsWithBLOBs ck = null;
            if(rooms.get(i) instanceof LinkedHashMap){
                ck = (ChatRoomsWithBLOBs)BeanUtil.mapToBean(ChatRoomsWithBLOBs.class,(LinkedHashMap)rooms.get(i));
            }else{
                ck = (ChatRoomsWithBLOBs)rooms.get(i);
            }
            if(ck.getId() == Integer.valueOf(roomid) && StringUtils.isEmpty(ck.getPassword())){
                return false;
            }
        }
        return true;
    }
    /*private Map<String,String> onlineNumCount(List rooms){
        Map<String,String> countMap = new HashMap();
        for(int i=0;i<rooms.size();i++){
            ChatRoomsWithBLOBs ck = null;
            if(rooms.get(i) instanceof LinkedHashMap){
                ck = (ChatRoomsWithBLOBs)BeanUtil.mapToBean(ChatRoomsWithBLOBs.class,(LinkedHashMap)rooms.get(i));
            }else{
                ck = (ChatRoomsWithBLOBs)rooms.get(i);
            }
            countMap.put(String.valueOf(ck.getId()),String.valueOf(redisParentDao.getSetSize("onuser"+ck.getId())));
        }
        return countMap;
    }*/
    private Map<String,String> allNumCount(List roomss){
        Map<String,String> allcountMap = new HashMap();
        for(int i=0;i<roomss.size();i++){
            /*ChatRoomsWithBLOBs ckd = null;
            if(roomss.get(i) instanceof LinkedHashMap){
                ckd = (ChatRoomsWithBLOBs)BeanUtil.mapToBean(ChatRoomsWithBLOBs.class,(LinkedHashMap)roomss.get(i));
            }else{
                ckd = (ChatRoomsWithBLOBs)roomss.get(i);
            }*/
        	ChatRoomsWithBLOBs ckd = (ChatRoomsWithBLOBs)roomss.get(i);
            //String count  = String.valueOf(redisParentDao.getValue("allnum"+ckd.getId()));
            /*if(StringUtils.isEmpty(count)){
                count = String.valueOf(roomMemberService.selectCountMember(ckd.getId()));
                redisParentDao.cacheValue("allnum"+ckd.getId(),String.valueOf(count));
            }*/
        	String count = String.valueOf(roomMemberService.selectCountMember(ckd.getId()));
            allcountMap.put(String.valueOf(ckd.getId()),count);
        }
        return allcountMap;
    }
    //判断输入的密码是否正确
    private boolean judgePass(String roomid,String userid,String password){
        List rooms = qryRooms();
        for(int i=0;i<rooms.size();i++){
            ChatRoomsWithBLOBs ck = null;
            if(rooms.get(i) instanceof LinkedHashMap){
                ck = (ChatRoomsWithBLOBs)BeanUtil.mapToBean(ChatRoomsWithBLOBs.class,(LinkedHashMap)rooms.get(i));
            }else{
                ck = (ChatRoomsWithBLOBs)rooms.get(i);
            }
            if(ck.getId() == Integer.valueOf(roomid) && ck.getPassword().equals(password)){
                return true;
            }
        }
        return false;
    }
    //判断输入的密码是否正确
    private boolean isBlackUser(String roomid,String userid){
        //是否黑名单
        RoomMember roomMember = roomMemberService.selectByPrimaryKey(userid,String.valueOf(roomid));
        if(roomMember!=null){
            if(roomMember.getBlacktype() ==1){
                return true;
            }
        }
        return false;
    }
    //判断是否需要密码才能进入房间
    private String canVisited(String roomid,String password,HttpServletRequest request){
        if(isLogin(request)){
            String usertype = (String)request.getSession().getAttribute("usertype");
            String userid = (String)request.getSession().getAttribute("userid");
            User user = userService.selectUserByUserid(userid);
            request.getSession().setAttribute("usertype",user.getUsertype());
            if(Integer.valueOf(usertype)<=0){//管理员不要密码
                return CVALUE.SUCCESS;
            }
            if(isBlackUser(roomid,userid)){
                return CVALUE.BLACK_USER;
            }
            if(isVisiedRoom(userid,roomid)){
                return CVALUE.SUCCESS;
            }
            if(!existsRoomPass(roomid)){
                return CVALUE.SUCCESS;
            }
            if(StringUtils.isEmpty(password)){
                return CVALUE.JUMP_TO_PASSWORD;
            }
            if(judgePass(roomid,userid,password)){
                return CVALUE.SUCCESS;
            }else{
                return  CVALUE.WRONG_PASS;
            }
            //是否黑名单
        }else{
            //游客：判断聊天室有没有密码
            if(!existsRoomPass(roomid)){
                return CVALUE.SUCCESS;
            }else{
                return CVALUE.YK_JUMP_LOGIN;
            }
        }
    }

    @RequestMapping(value = "/canVisitRoom", produces="text/html; charset=UTF-8",method = RequestMethod.POST)
    @ResponseBody
    public String secretchat(String roomid,String userid,HttpServletRequest request){
        try{
            return canVisited(roomid,null,request);
        } catch (Exception e){
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/accessWithPass",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    public String accessin(HttpServletRequest request,String roomid,String password,String screenHeight, Model model,RedirectAttributes attributes) {
        String code = canVisited(roomid,password,request);
        if(!"0".equals(code)){
            model.addAttribute(CVALUE.ERRORINFO, CVALUE.transCode(code));
            model.addAttribute("roomid",roomid);
            return "phone/accessRoom";
        }
        attributes.addFlashAttribute("roomid", roomid);
        attributes.addFlashAttribute("password",password);
        attributes.addFlashAttribute("scrnhei",screenHeight);
        return "redirect:/unchk/jumpchat";
    }

}
