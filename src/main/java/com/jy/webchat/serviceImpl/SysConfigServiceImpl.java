package com.jy.webchat.serviceImpl;

import com.jy.webchat.dao.SysConfigMapper;
import com.jy.webchat.pojo.SysConfig;
import com.jy.webchat.service.ISysConfigService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service(value = "sysConfigService")
public class SysConfigServiceImpl implements ISysConfigService {
    @Resource(name="sysConfigMapper")
    private SysConfigMapper sysConfigMapper;
    @Override
    public SysConfig selectByPrimaryKey(Integer id) {
        return sysConfigMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(SysConfig record) {
        return sysConfigMapper.updateByPrimaryKeySelective(record);
    }
}
