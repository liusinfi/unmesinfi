package com.jy.webchat.service;

import com.jy.webchat.pojo.SysConfig;

public interface ISysConfigService {
    SysConfig selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(SysConfig record);
}
