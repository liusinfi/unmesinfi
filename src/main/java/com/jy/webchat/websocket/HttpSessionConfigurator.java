package com.jy.webchat.websocket;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator  {
    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response){
        try {
            HttpSession httpSession = (HttpSession)request.getHttpSession();
            config.getUserProperties().put(HttpSession.class.getName(),httpSession);
        } catch (Exception e) {
            //e.printStackTrace();
        }
    }
}
