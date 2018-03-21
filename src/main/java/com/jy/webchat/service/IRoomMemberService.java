package com.jy.webchat.service;

import com.jy.webchat.pojo.RoomMember;

import java.util.List;

public interface IRoomMemberService {
    int insert(RoomMember record);
    RoomMember selectByPrimaryKey(String userid,String roomid);
    List<RoomMember> selectPage(RoomMember roomMember);
    int selectCountMember(Integer roomid);
}
