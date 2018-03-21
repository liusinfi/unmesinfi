package com.jy.webchat.controller;

import com.alibaba.fastjson.JSONObject;
import com.jy.webchat.dao.RedisParentDao;
import com.jy.webchat.pojo.*;
import com.jy.webchat.service.IChatRoomsService;
import com.jy.webchat.service.IRoomMemberService;
import com.jy.webchat.service.ISysConfigService;
import com.jy.webchat.service.IUserService;
import com.jy.webchat.utils.EncryptUtil;
import com.jy.webchat.websocket.ChatServer;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@SessionAttributes("userid")
public class AdminController {

    @Resource
    private IUserService userService;
    @Resource(name="chatRoomsService") private IChatRoomsService chatRoomsService;
    @Resource(name="roomMemberService")public IRoomMemberService roomMemberService;
    @Resource(name="sysConfigService")public ISysConfigService sysConfigService;
    @Resource(name="redisParentDao") private RedisParentDao redisParentDao;

    private boolean isAdminUser(HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        String usertype = (String)request.getSession().getAttribute("usertype");
        User user = userService.selectUserByUserid(userid);
        if(!user.getUsertype().equals(usertype) || Integer.valueOf(usertype)>0){
            return false;
        }
        return true;
    }

    @RequestMapping(value = "/modifyChatRoom",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  modifyChatRoom( String roomid,String password,String roomTitle,String roomContent,Integer roomType,String roomNotice,String delFlag, HttpServletRequest request){
        try {
            if(!isAdminUser(request)){
                return "error|不是管理员";
            }
            //删除聊天室
            if("1".equals(delFlag)){
                ChatRoomsWithBLOBs blo =chatRoomsService.selectByPrimaryKey(Integer.valueOf(roomid));
                if(blo == null){
                    return "error|不存在该聊天室";
                }
                chatRoomsService.operByRU(Integer.valueOf(roomid),null,null);
                List chatrooms = chatRoomsService.selectAll(0,100);
                redisParentDao.removeList(CVALUE.ROOM_LIST);
                redisParentDao.cacheListObj(CVALUE.ROOM_LIST,chatrooms,-1);
                return "success";
            }
            ChatRoomsWithBLOBs blo =  null;
            if (StringUtils.isNotEmpty(roomid) && !"0".equals(roomid)){
                blo =chatRoomsService.selectByPrimaryKey(Integer.valueOf(roomid));
                blo.setPassword(password);
                blo.setRoomcontent(roomContent);
                blo.setRoomtitle(roomTitle);
                blo.setRoomtype(roomType);
                roomNotice = roomNotice.replaceAll("\n","</br>");
                blo.setRoomnotice(roomNotice);
                chatRoomsService.updateByPrimaryKeySelective(blo);
                JSONObject member = new JSONObject();
                member.put("message", roomNotice);//消息
                member.put("type", "roommsg");//消息类型
                ChatServer.broadcastOut(member.toString(),roomid);
            }else{
                blo = new ChatRoomsWithBLOBs();
                blo.setPassword(password);
                blo.setRoomcontent(roomContent);
                blo.setRoomtitle(roomTitle);
                blo.setRoomtype(roomType);
                roomNotice = roomNotice.replaceAll("\n","</br>");
                blo.setRoomnotice(roomNotice);
                chatRoomsService.insert(blo);
            }
            //重新加载redis缓存
            List chatrooms = chatRoomsService.selectAll(0,100);
            redisParentDao.removeList(CVALUE.ROOM_LIST);
            redisParentDao.cacheListObj(CVALUE.ROOM_LIST,chatrooms,-1);
        } catch (Throwable e) {
            return "error|"+e;
        }
        return "success";
    }

    @RequestMapping(value = "/operRoom",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  operRoom(String beOperedId, String roomid,String operType, HttpServletRequest request){
        try {
            if(!isAdminUser(request)){
                return "error|不是管理员";
            }
            ChatRoomsWithBLOBs blo =chatRoomsService.selectByPrimaryKey(Integer.valueOf(roomid));
            if(blo == null){
                return "error|不存在该聊天室";
            }
            if("1".equals(operType)){// 踢出
                chatRoomsService.operByRU(Integer.valueOf(roomid),beOperedId,Integer.valueOf(operType));
                JSONObject member = new JSONObject();
                member.put("message", beOperedId);//消息
                member.put("type", "TR");//消息类型
                ChatServer.broadcastOut(member.toString(),roomid);
                ChatServer.removeRoutetab(beOperedId);//马上把用户提出session
            }else if("2".equals(operType)){//禁言
                chatRoomsService.operByRU(Integer.valueOf(roomid),beOperedId,Integer.valueOf(operType));
                ChatServer.cansendchange.put(roomid+beOperedId,"2");
            }else{
                chatRoomsService.operByRU(Integer.valueOf(roomid),beOperedId,0);
                ChatServer.cansendchange.put(roomid+beOperedId,"2");
            }
        } catch (Throwable e) {
            return "error|"+e;
        }
        return "success";
    }
    @RequestMapping(value = "/roommember",produces="text/html; charset=UTF-8",method = RequestMethod.GET)
    public ModelAndView selectPage(@RequestParam(required=true,defaultValue="1") Integer pageNum,
                                   @RequestParam(required=false,defaultValue="10") Integer pageSize, Integer roomid, String searchuserid, HttpServletRequest request) throws Exception {
        if(!isAdminUser(request)){
            throw new Exception("不是管理员");
        }
        ModelAndView view = new ModelAndView("chatmember");
        PageHelper.startPage(pageNum, pageSize);
        RoomMember roomMember = new RoomMember();
        if(roomid != null && -1 != roomid){
            roomMember.setRoomid(roomid);
        }
        if(StringUtils.isNotEmpty(searchuserid)){
            searchuserid = java.net.URLDecoder.decode(searchuserid, "UTF-8");
            roomMember.setUserid(searchuserid);
        }
        List<RoomMember> list = roomMemberService.selectPage(roomMember);
        PageInfo page = new PageInfo(list);
        long count = page.getTotal();
        view.addObject("count", count);
        view.addObject("page", page);
        view.addObject("pageNum", pageNum);
        view.addObject("searchuserid", searchuserid);
        view.addObject("ChatRooms", chatRoomsService.selectAll(0,100));
        return view;
    }
    @RequestMapping(value = "/operUser",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  operUser(String beOperedId, String operType,String password, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        try {
            if(!isAdminUser(request)){
                return "error|不是管理员";
            }
            if("1".equals(operType) || "2".equals(operType) ||"0".equals(operType)){
                User user1 = new User();
                user1.setUserid(beOperedId);
                user1.setUsertype(operType);
                userService.update(user1);
                ChatServer.cansendchange.put(beOperedId,operType);
                if("0".equals(operType)){
                    redisParentDao.cacheSet("adminuser",beOperedId);
                    /*redisParentDao.removeList()*/
                }else{
                    redisParentDao.removeSetMember("adminuser",beOperedId);
                }
            }else if("99".equals(operType)){
                if(StringUtils.isEmpty(password)){
                    return "error|密码为空";
                }
                User user1 = new User();
                user1.setUserid(beOperedId);
                user1.setPassword(EncryptUtil.encryptMd5(password));
                userService.update(user1);
            }

        } catch (Throwable e) {
            return "error|"+e;
        }
        return "success";
    }

    @RequestMapping(value = "/sysupdate",produces="text/html; charset=UTF-8", method = RequestMethod.GET)
    public ModelAndView  sysupdate(HttpServletRequest request) throws Exception {
        if(!isAdminUser(request)){
            throw new Exception("不是管理员");
        }
        ModelAndView view = new ModelAndView("system-setting");
        SysConfig sysConfig = sysConfigService.selectByPrimaryKey(1);
        view.addObject("sysconfig",sysConfig);
        return view;
    }


    @RequestMapping(value = "/sysupdate",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    public ModelAndView  sysupdate( String syslocate, String syscontent,String syshost,String onlineconsult,
                                    HttpServletRequest request) throws Exception {
        if(!isAdminUser(request)){
            throw new Exception("不是管理员");
        }
        ModelAndView view = new ModelAndView("system-setting");

        if(StringUtils.isNotEmpty(syslocate)){
            SysConfig sysConfig = new SysConfig();
            sysConfig.setId(1);
            syscontent = syscontent.replaceAll("\r\n","</br>");
            sysConfig.setSyscontent(syscontent);
            sysConfig.setSyslocate(syslocate);
            sysConfig.setSyshost(syshost);
            sysConfig.setOnlineconsult(onlineconsult);
            sysConfig.setLasttime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            int flag = sysConfigService.updateByPrimaryKeySelective(sysConfig);
        }
        SysConfig sysConfig = sysConfigService.selectByPrimaryKey(1);
        view.addObject("sysconfig",sysConfig);
        return view;
    }

    @RequestMapping(value = "/operKname",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  operKname(String beOperedId,String Kname, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        try {
            if(!isAdminUser(request)){
                return "error|不是管理员";
            }
            if(StringUtils.isEmpty(beOperedId)){
                return "error|没有找到用户名!";
            }
            if(StringUtils.isEmpty(Kname)){
                return "error|没有输入备注名!";
            }
            User user1 = new User();
            user1.setUserid(beOperedId);
            user1.setKname(Kname);
            userService.update(user1);
        } catch (Throwable e) {
            return "error|"+e;
        }
        return "success";
    }

    @RequestMapping(value = "/snoopChatStatus",produces="text/html; charset=UTF-8", method = RequestMethod.POST)
    @ResponseBody
    public String  snoopChatStatus(String roomid,String beOperedId, HttpServletRequest request){
        String userid = (String)request.getSession().getAttribute("userid");
        try {
            if(!isAdminUser(request)){
                return "error|不是管理员";
            }
            Map<String,String> map = redisParentDao.getMap("roomstatus");
            if(map!=null && map.containsKey("roomid"+roomid)){
                if("0".equals(map.get("roomid"+roomid))){//0是禁言状态
                    map.put("roomid"+roomid,"1");//切换为1
                    redisParentDao.setCacheMap("roomstatus",map,-1);
                }else{
                    map.put("roomid"+roomid,"0");
                    redisParentDao.setCacheMap("roomstatus",map,-1);
                }
            }else{
                //第一次进来
                Map<String,String> map1 = new HashMap<>();
                map1.put("roomid"+roomid,"0");
                redisParentDao.setCacheMap("roomstatus",map1,-1);
            }
        } catch (Throwable e) {
            return "error|"+e;
        }
        return "success";
    }

    @RequestMapping(value = "/QAlogin", method = RequestMethod.GET)
    public String login(Model model, String show) {
        model.addAttribute("show",show);
        return "login";
    }

    @RequestMapping(value = "QAoper")
    public ModelAndView getIndex(HttpServletRequest request){
        ModelAndView view = new ModelAndView("index");
        view.addObject("errorinfo", "no");
        List<ChatRoomsWithBLOBs> chatRoomsWithBLOBs = chatRoomsService.selectAll(0,100);
        if(isAdminUser(request)){
            Map<String,String> map = redisParentDao.getMap("roomstatus");
            if(map!=null &&!map.isEmpty()){
                for (ChatRoomsWithBLOBs chatRoom : chatRoomsWithBLOBs){
                    chatRoom.setRoomstatus(map.get("roomid"+chatRoom.getId()));
                }
            }
        }
        view.addObject("ChatRooms", chatRoomsWithBLOBs);
        SysConfig sysConfig = sysConfigService.selectByPrimaryKey(1);
        request.getSession().setAttribute("syscontent",sysConfig.getSyscontent());
        request.getSession().setAttribute("syslocate",sysConfig.getSyslocate());
        return view;
    }
}
