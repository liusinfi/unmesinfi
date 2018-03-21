package com.jy.webchat.service;

import com.jy.webchat.pojo.User;

import java.util.List;

public interface IUserService {
    List<User> selectAll(int page, int pageSize);
    User selectUserByUserid(String userid);
    int selectCount(int pageSize);
    boolean insert(User user);
    boolean update(User user);
    boolean delete(String userid);
    List<User> selectUserPage(User user);
    List<User> selectAllMember(String roomid);
    User selectUserByOpenid(String openId);
}
