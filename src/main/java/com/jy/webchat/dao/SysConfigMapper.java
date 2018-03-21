package com.jy.webchat.dao;


import com.jy.webchat.pojo.SysConfig;
import org.springframework.stereotype.Service;

@Service(value = "sysConfigMapper")
public interface SysConfigMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(SysConfig record);

    int insertSelective(SysConfig record);

    SysConfig selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(SysConfig record);

    int updateByPrimaryKeyWithBLOBs(SysConfig record);

    int updateByPrimaryKey(SysConfig record);
}