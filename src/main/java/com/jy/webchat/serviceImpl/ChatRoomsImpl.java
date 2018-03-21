package com.jy.webchat.serviceImpl;

import com.jy.webchat.dao.ChatRoomsMapper;
import com.jy.webchat.dao.RoomMemberMapper;
import com.jy.webchat.pojo.ChatRoomsWithBLOBs;
import com.jy.webchat.pojo.RoomMember;
import com.jy.webchat.pojo.RoomMemberKey;
import com.jy.webchat.service.IChatRoomsService;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
@Service(value = "chatRoomsService")
@Transactional
public class ChatRoomsImpl implements IChatRoomsService{
    @Resource(name="chatRoomsDao")
    private ChatRoomsMapper chatRoomsDao;
    @Resource(name="roomMemberMapper")
    private RoomMemberMapper roomMemberMapper;
    @Override
    public List<ChatRoomsWithBLOBs> selectAll(int page, int pageSize) {
        return chatRoomsDao.selectAll(page,pageSize);
    }

    public ChatRoomsWithBLOBs selectByPrimaryKey(Integer id){
        return chatRoomsDao.selectByPrimaryKey(id);
    }

    public int insert(ChatRoomsWithBLOBs record){
        record.setCreatedate(new Date());
        record.setLasttime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        record.setRoommember(0);
        return chatRoomsDao.insert(record);
    }

    public int updateByPrimaryKeySelective(ChatRoomsWithBLOBs record){
        return chatRoomsDao.updateByPrimaryKeySelective(record);
    }

    @Override
    public int operByRU(Integer id, String userid,Integer blacktype) {
        if(StringUtils.isEmpty(userid)){//删除聊天室操作
            chatRoomsDao.deleteByPrimaryKey(id);
            RoomMemberKey roomMemberKey = new RoomMemberKey();
            roomMemberKey.setRoomid(id);
            roomMemberMapper.deleteByRU(roomMemberKey);
        }else{//禁言，踢人,恢复正常
            RoomMember roomMember = new RoomMember();
            roomMember.setUserid(userid);
            roomMember.setRoomid(id);
            roomMember.setBlacktype(blacktype);
            roomMemberMapper.updateByPrimaryKeySelective(roomMember);
        }
        return 0;
    }

    @Override
    public List<ChatRoomsWithBLOBs> selectUserVisited(String userid) {
        return chatRoomsDao.selectUserVisited(userid);
    }
}
