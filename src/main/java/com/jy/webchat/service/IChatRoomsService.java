package com.jy.webchat.service;


import com.jy.webchat.pojo.ChatRoomsWithBLOBs;

import java.util.List;

public interface IChatRoomsService {
    List<ChatRoomsWithBLOBs> selectAll(int page, int pageSize);
    ChatRoomsWithBLOBs selectByPrimaryKey(Integer id);
    int insert(ChatRoomsWithBLOBs record);
    int updateByPrimaryKeySelective(ChatRoomsWithBLOBs record);
    int operByRU(Integer id,String userid,Integer blacktype);
    List<ChatRoomsWithBLOBs> selectUserVisited(String userid);
}
