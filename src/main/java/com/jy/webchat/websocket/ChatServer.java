package com.jy.webchat.websocket;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jy.webchat.dao.RedisParentDao;
import com.jy.webchat.pojo.CVALUE;
import com.jy.webchat.pojo.RoomMember;
import com.jy.webchat.service.IChatRoomsService;
import com.jy.webchat.service.IRoomMemberService;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.ContextLoader;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.locks.ReentrantLock;

@ServerEndpoint(value = "/chatServer/{roomid}", configurator = HttpSessionConfigurator.class)
public class ChatServer {
    private Session session;    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private String userid;      //用户名
    private HttpSession httpSession;    //request的session
    private String roomId;
    private static Map<String,CopyOnWriteArraySet<ChatServer>> roomsetMap = new ConcurrentHashMap<>();
    private static Map<String,Set> onlineMap = new ConcurrentHashMap<>();
    private static Map routetab = new ConcurrentHashMap<>();  //用户名和websocket的session绑定的路由表
    public static Map cansendchange = new ConcurrentHashMap<>();  //禁言列表变动
    /*private static Map<String,String> temChatMap = new ConcurrentHashMap<>();*/
    public IRoomMemberService roomMemberService;
    public RedisParentDao redisParentDao;
    public IChatRoomsService chatRoomsService;
    private boolean isYK=false;
    /**
     * 连接建立成功调用的方法
     * @param session  可选的参数。session为与某个客户端的连接会话，需要通过它来给客户端发送数据
     */
    @OnOpen
    public void onOpen(@PathParam("roomid") String roomid, Session session, EndpointConfig config) throws Exception {
        this.roomId = roomid;
        this.session = session;
        this.httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
        if(this.httpSession == null){
            return;
        }
        roomMemberService = (IRoomMemberService)ContextLoader.getCurrentWebApplicationContext().getBean("roomMemberService");
        redisParentDao = (RedisParentDao)ContextLoader.getCurrentWebApplicationContext().getBean("redisParentDao");
        chatRoomsService =  (IChatRoomsService)ContextLoader.getCurrentWebApplicationContext().getBean("chatRoomsService");
        this.userid=(String) httpSession.getAttribute("userid");    //获取当前用户
        if(StringUtils.isEmpty(userid)){
        	return;
        }
        if(userid.indexOf("YKMODE")==0){
            isYK = true;
        }
        if(routetab.get(userid)!=null){
            //return;
        }

        RoomMember roomMember = roomMemberService.selectByPrimaryKey(userid,roomId);
        if(roomMember !=null && 1==roomMember.getBlacktype()){
            //throw new Exception("已被踢出聊天室");
        	return;
        }
        ReentrantLock lock = new ReentrantLock();
        lock.lock();
        try {
            if(roomsetMap.get(roomId) ==null){
                CopyOnWriteArraySet<ChatServer> webset = new CopyOnWriteArraySet<ChatServer>();
                webset.add(this);
                roomsetMap.put(roomId,webset);
            }else{
                roomsetMap.get(roomId).add(this);
            }
            routetab.put(userid, session);   //将用户名和session绑定到路由表
            if(!isYK){//不是游客
                if(onlineMap.get(roomId) ==null){
                    Set set = new Set<String>();
                    set.add(userid);
                    onlineMap.put(roomId,list);
                }else{
                    onlineMap.get(roomId).add(userid);
                }
                //redisParentDao.cacheSet("onuser"+roomId,userid);
                cansendchange.put(roomId+userid,"1");//初始化加载一份，发第一条消息时候，去查询是否被禁言，之后有管理员禁言操作设置。
                if(roomMember==null){
                    roomMember = new RoomMember();
                    roomMember.setUserid(userid);
                    roomMember.setRoomid(Integer.valueOf(roomId));
                    roomMember.setBlacktype(0);
                    roomMemberService.insert(roomMember);
                    /*redisParentDao.removeList(CVALUE.USER_VISITED+userid);
                    redisParentDao.cacheListObj(CVALUE.USER_VISITED+userid,chatRoomsService.selectUserVisited(userid),-1);*/
                    int count = roomMemberService.selectCountMember(Integer.valueOf(roomId));
                    //redisParentDao.cacheValue("allnum"+roomid,String.valueOf(count),-1);
                }
                String message = getMessage("", "", onlineMap.get(roomId), userid,null);
                broadcast(message);     //广播
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }



    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(){
        ReentrantLock lock = new ReentrantLock();
        lock.lock();
        try {
            roomsetMap.get(roomId).remove(this);
            //清除通话临时关系
            /*for (String in : temChatMap.keySet()) {
                if(in.indexOf(userid+"|")>=0 || in.indexOf("|" + userid)>=0){
                    temChatMap.remove(in);
                }
            }*/
            if(!isYK){
                onlineMap.get(roomId).remove(userid);
                //redisParentDao.removeSetMember("onuser"+roomId,userid);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }

        if(routetab.get(userid)!=null){
            routetab.remove(userid);
        }

        String message = getMessage("", "", onlineMap.get(roomId), null,userid);
        broadcast(message);         //广播
    }

    @OnMessage
    public void onMessage(String _message) throws Exception {

        if(routetab.get(userid) ==null){
            throw new Exception("连接关闭");
        }
        //判断一下黑名单类型是否要更新一下，进来后第一次发言要先加载一次,再onOpen里面加载了。
        if(cansendchange.get(roomId+userid) !=null){
            //查询一下
            RoomMember rm = roomMemberService.selectByPrimaryKey(userid,roomId);
            httpSession.setAttribute("blacktype",rm.getBlacktype());
            cansendchange.remove(roomId+userid);
        }
        _message = _message.replaceAll("\\\\n","</br>");
        _message = _message.replaceAll("</p><p>","</br>");
        _message = _message.replaceAll("<p>","");
        _message = _message.replaceAll("</p>","");
        _message = _message.replaceAll("<div>","</br>");
        _message = _message.replaceAll("</div>","");
        JSONObject chat = JSON.parseObject(_message);
        String type = chat.get("type").toString();
        if("heartbeat".equals(type)){
            singleSend(_message, (Session) routetab.get(userid));
            return;
        }
        JSONObject message = JSON.parseObject(chat.get("message").toString());
        Map<String,String> map = redisParentDao.getMap("roomstatus");
        if(map!=null && !map.isEmpty() && "0".equals(map.get("roomid"+roomId))){
            //聊天室禁言
            String insteadMsg = getMessage(userid+"聊天室禁言中!","notice",onlineMap.get(roomId),null,null);
            singleSend(insteadMsg, (Session) routetab.get(userid));
            return;
        }
        if(userid.equals(message.get("from")) && "2".equals(String.valueOf(httpSession.getAttribute("blacktype")))){
            //被禁言的user不能发送信息，发送一条通知给他自己
            String insteadMsg = getMessage(userid+"您已被禁言!","notice",onlineMap.get(roomId),null,null);
            singleSend(insteadMsg, (Session) routetab.get(userid));
        }else{
            if(message.get("to") == null || message.get("to").equals("")){      //如果to为空,则广播;如果不为空,则对指定的用户发送消息
                broadcast(_message);
                if(redisParentDao.getListSize("room"+roomId)/100 > 3){
                    redisParentDao.trimList("room"+roomId,200,-1);
                }
                redisParentDao.cacheList("room"+roomId,_message);//聊天记录放在redis个小时有效
            }else{
                if(cansendchange.get(userid) !=null){
                    //更新session里面的usertype
                    httpSession.setAttribute("usertype",cansendchange.get(userid).toString());
                    cansendchange.remove(userid);
                }
                String usertype=(String) httpSession.getAttribute("usertype");    //获取当前用户
                if(Integer.valueOf(usertype) > 1){
                    //判断是否有临时通话关系
                    String [] userlist = message.get("to").toString().split(",");
                    if(userlist.length>1){
                        return;
                    }
                    Set admins = redisParentDao.getSet("adminuser");
                    if(!admins.contains(userlist[0])){
                        String insteadMsg = getMessage(userid+"您没有私聊权限!","notice",onlineMap.get(roomId),null,message.get("to").toString());
                        singleSend(insteadMsg, (Session) routetab.get(message.get("from")));
                    }else{
                        singleSend(_message, (Session) routetab.get(message.get("from")));      //发送给自己,这个别忘了
                        singleSend(_message, (Session) routetab.get(userlist[0]));     //分别发送给每个指定用户
                    }
                    /*if(temChatMap.containsKey(message.get("from")+"|"+userlist[0]) || temChatMap.containsKey(userlist[0]+"|"+message.get("from"))){
                        singleSend(_message, (Session) routetab.get(message.get("from")));      //发送给自己,这个别忘了
                        singleSend(_message, (Session) routetab.get(userlist[0]));     //分别发送给每个指定用户
                    }else{
                        String insteadMsg = getMessage(userid+"您没有私聊权限!","notice",onlineMap.get(roomId),null,message.get("to").toString());
                        singleSend(insteadMsg, (Session) routetab.get(message.get("from")));
                    }*/
                }else{
                    String [] userlist = message.get("to").toString().split(",");
                    singleSend(_message, (Session) routetab.get(message.get("from")));      //发送给自己,这个别忘了
                    for(String user : userlist){
                        if(!user.equals(message.get("from"))){
                            /*temChatMap.put(message.get("from")+"|"+user,"1");//建立两者的临时通话关系*/
                            if(!routetab.containsKey(user)){
                                String insteadMsg = getMessage(user+"该用户已下线!","notice",onlineMap.get(roomId),null,user);
                                singleSend(insteadMsg, (Session) routetab.get(message.get("from")));
                            }else{
                                singleSend(_message, (Session) routetab.get(user));     //分别发送给每个指定用户
                            }
                        }
                    }
                }

            }
        }

    }

    /**
     * 发生错误时调用
     * @param error
     */
    @OnError
    public void onError(Throwable error){
        error.printStackTrace();
    }

    /**
     * 广播消息
     * @param message
     */
    public void broadcast(String message){
        for(ChatServer chat: roomsetMap.get(roomId)){
            try {
                //solve problem
                //java.lang.IllegalStateException: The remote endpoint was in state [TEXT_PARTIAL_WRITING] which is an invalid state for called method
                synchronized (chat.session){
                    if(chat.session.isOpen())
                        chat.session.getAsyncRemote().sendText(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }
        }
    }

    public static void broadcastOut(String message,String roomId){
        if(roomsetMap.containsKey(roomId)){
            for(ChatServer chat: roomsetMap.get(roomId)){
                try {
                    synchronized (chat.session){
                        if(chat.session.isOpen())
                            chat.session.getAsyncRemote().sendText(message);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    continue;
                }
            }
        }
    }

    /**
     * 对特定用户发送消息
     * @param message
     * @param session
     */
    public void singleSend(String message, Session session){
        try {
            session.getAsyncRemote().sendText(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 组装返回给前台的消息
     * @param message   交互信息
     * @param type      信息类型
     * @return
     */
    public String getMessage(String message, String type,List onlinelist,String onuser ,String offuser){
        JSONObject member = new JSONObject();
        member.put("message", message);//消息
        member.put("type", type);//消息类型
        member.put("list", onlinelist);//在线类表
        member.put("onlinenum", onlinelist==null?0:onlinelist.size());
        member.put("onuser", onuser);//上线用户
        member.put("offuser", offuser);//下线用户
        return member.toString();
    }

    /*public  int getOnlineCount() {
        return roomCountUser.get(roomId).intValue();
    }

    public  void addOnlineCount() {
        if(roomCountUser.get(roomId) ==null){
            AtomicInteger roomInteger = new AtomicInteger(0);
            roomInteger.incrementAndGet();
            roomCountUser.put(roomId,roomInteger);
        }else{
            roomCountUser.get(roomId).incrementAndGet();
        }
    }

    public  void subOnlineCount() {
        if(roomCountUser.get(roomId) ==null){
            AtomicInteger roomInteger = new AtomicInteger(0);
            roomInteger.decrementAndGet();
            roomCountUser.put(roomId,roomInteger);
        }else{
            roomCountUser.get(roomId).decrementAndGet();
        }
    }*/

    public static void removeRoutetab(String userid){
        routetab.remove(userid);
    }
    public static boolean checkExistSession(String userid){
        return routetab.get(userid)!=null ? true:false;
    }
}
