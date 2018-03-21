package com.jy.webchat.serviceImpl;

import com.jy.webchat.dao.IUserDao;
import com.jy.webchat.pojo.User;
import com.jy.webchat.service.IUserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service(value = "userService")
public class UserServiceImpl implements IUserService {

    @Resource private IUserDao userDao;

    @Override
    public List<User> selectAll(int page, int pageSize) {
        return userDao.selectAll(page, pageSize);
    }

    @Override
    public User selectUserByUserid(String userid) {
        return userDao.selectUserByUserid(userid);
    }

    public User selectUserByOpenid(String openId){
        return userDao.selectUserByOpenid(openId);
    }


    @Override
    public int selectCount(int pageSize) {
        int pageCount = Integer.parseInt(userDao.selectCount().getUserid());
        return pageCount % pageSize == 0 ? pageCount/pageSize : pageCount/pageSize + 1;
    }

    @Override
    public boolean insert(User user) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        user.setLasttime(sdf.format(new Date()));
        user.setFirsttime(sdf.format(new Date()));
        user.setStatus(1);
        return userDao.insert(user);
    }

    @Override
    public boolean update(User user) {
        return userDao.update(user);
    }

    @Override
    public boolean delete(String userid) {
        return userDao.delete(userid);
    }

    @Override
    public List<User> selectUserPage(User user) {
        return userDao.selectUserPage(user);
    }

    public  List<User> selectAllMember(String roomid){
        return userDao.selectAllMember(roomid);
    }
}
