package com.jy.webchat.dao;

import com.jy.webchat.pojo.User;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Service;

import java.util.List;

@Service(value = "userDao")
public interface IUserDao {
    List<User> selectAll(@Param("offset") int offset, @Param("limit") int limit);

    User selectUserByUserid(String userid);

    User selectUserByOpenid(String openid);

    User selectCount();

    boolean insert(User user);

    boolean update(User user);

    boolean delete(String userid);

    List<User> selectUserPage(User user);

    List<User> selectAllMember(String roomid);
}
