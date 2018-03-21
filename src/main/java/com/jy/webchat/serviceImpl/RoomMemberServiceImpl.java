package com.jy.webchat.serviceImpl;

import com.jy.webchat.dao.RoomMemberMapper;
import com.jy.webchat.pojo.RoomMember;
import com.jy.webchat.pojo.RoomMemberKey;
import com.jy.webchat.service.IRoomMemberService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service(value = "roomMemberService")
public class RoomMemberServiceImpl implements IRoomMemberService {
    @Resource(name="roomMemberMapper")
    private RoomMemberMapper roomMemberMapper;
    @Override
    public int insert(RoomMember record) {
        record.setCreatedate(new Date());
        return roomMemberMapper.insert(record);
    }

    @Override
    public RoomMember selectByPrimaryKey(String userid,String roomid) {
        RoomMemberKey key =  new RoomMemberKey();
        key.setRoomid(Integer.valueOf(roomid));
        key.setUserid(userid);
        return roomMemberMapper.selectByPrimaryKey(key);
    }

    @Override
    public List<RoomMember> selectPage(RoomMember roomMember) {
        return roomMemberMapper.selectPage(roomMember);
    }

    @Override
    public int selectCountMember(Integer roomid) {
        return roomMemberMapper.selectCountMember(roomid);
    }


}
