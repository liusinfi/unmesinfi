package com.jy.webchat.controller;

import com.jy.webchat.pojo.ChatRoomsWithBLOBs;
import com.jy.webchat.service.IChatRoomsService;
import com.jy.webchat.service.IRoomMemberService;
import com.jy.webchat.service.IUserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping(value = "")
public class RouteController {
    @Resource
    private IUserService userService;
    @Resource(name="roomMemberService")public IRoomMemberService roomMemberService;
    @Resource(name="chatRoomsService") private IChatRoomsService chatRoomsService;
    @RequestMapping(value = "")
    public String index() {
        return "redirect:/unchk/first";
    }

    @RequestMapping(value = "/about")
    public String about() {
        return "about";
    }

    @RequestMapping(value = "/help")
    public String help() {
        return "help";
    }

    @RequestMapping(value = "/system")
    public String system() {
        return "system-setting";
    }




}
