package com.jy.webchat.dao;


import com.jy.webchat.pojo.RoomMember;
import com.jy.webchat.pojo.RoomMemberKey;
import org.springframework.stereotype.Service;

import java.util.List;

@Service(value = "roomMemberMapper")
public interface RoomMemberMapper {
    int deleteByPrimaryKey(RoomMemberKey key);

    int insert(RoomMember record);

    int insertSelective(RoomMember record);

    RoomMember selectByPrimaryKey(RoomMemberKey key);

    int updateByPrimaryKeySelective(RoomMember record);

    int updateByPrimaryKey(RoomMember record);

    List<RoomMember> selectPage(RoomMember roomMember);

    int selectCountMember(Integer roomid);

    int deleteByRU(RoomMemberKey key);
}