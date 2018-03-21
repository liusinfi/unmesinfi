package com.jy.webchat.dao;


import com.jy.webchat.pojo.ChatRooms;
import com.jy.webchat.pojo.ChatRoomsWithBLOBs;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import java.util.List;

@Service(value = "chatRoomsDao")
public interface ChatRoomsMapper {
    List<ChatRoomsWithBLOBs> selectAll(@Param("offset") int offset, @Param("limit") int limit);
    int deleteByPrimaryKey(Integer id);

    int insert(ChatRoomsWithBLOBs record);

    int insertSelective(ChatRoomsWithBLOBs record);

    ChatRoomsWithBLOBs selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ChatRoomsWithBLOBs record);

    int updateByPrimaryKeyWithBLOBs(ChatRoomsWithBLOBs record);

    int updateByPrimaryKey(ChatRooms record);

    public List<ChatRoomsWithBLOBs> selectUserVisited(String userid);
}