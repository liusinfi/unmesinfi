package com.jy.webchat.controller;

import com.jy.webchat.pojo.Log;
import com.jy.webchat.service.ILogService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping(value = "")
public class LogController {

    @Resource
    private ILogService logService;

    @RequestMapping(value = "{userid}/log")
    public ModelAndView selectAll(@PathVariable("userid") String userid, @RequestParam(defaultValue = "1") int page) {
        int pageSize = 5;
        ModelAndView view = new ModelAndView("log");
        List<Log> list = logService.selectLogByUserid(userid, page, pageSize);
        int count = logService.selectCountByUserid(userid, pageSize);
        view.addObject("list", list);
        view.addObject("count", count);
        return view;
    }

}
