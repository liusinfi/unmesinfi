package com.jy.webchat;

import com.jy.webchat.pojo.ChatRoomsWithBLOBs;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.redis.core.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class Test {

    public static void main(String[] args) {
        ClassPathXmlApplicationContext appCtx = new ClassPathXmlApplicationContext("spring/spring-redis.xml");
        final RedisTemplate<String, Object> redisTemplate = appCtx.getBean("redisTemplate",RedisTemplate.class);
        //添加一个 key

        ListOperations<String, Object> list = redisTemplate.opsForList();
        System.out.println(list.range("ct:list:onuser1", 0, -1));
        //ValueOperations<String, Object> value = redisTemplate.opsForValue();
        //value.set("lp", "hello word");
        //获取 这个 key 的值
        /*System.out.println(value.get("lp"));*/

        /*SetOperations<String, Object> setOps = redisTemplate.opsForSet();
        System.out.println(setOps.members("ct:set:onuser1"));

        ListOperations<String, Object> list = redisTemplate.opsForList();
        System.out.println(list.range("ct:list:room1",0,-1));

        HashMap params = new HashMap();
        params.put("phoneIme", "mytest");
        params.put("state", 1);
        params.put("location", "xiamen");
        params.put("realName", "me");
        params.put("nickname", "yuan");
        params.put("headimgurl", "fewfw");
        HashOperations hashOperations = redisTemplate.opsForHash();*/
        /*if(null != params){
            for (Object entry : params.entrySet()) {
                Map.Entry entryl = (Map.Entry)entry;
                hashOperations.put("msgsl",entryl.getKey(),entryl.getValue());
            }
        }*/
        /*System.out.println(hashOperations.entries("phoneIme"));*/
        /*List<ChatRoomsWithBLOBs> chatRoomsWithBLOBs = new ArrayList<>();
        ChatRoomsWithBLOBs chatRoomsWithBLOBs1 = new ChatRoomsWithBLOBs();
        chatRoomsWithBLOBs1.setId(1);
        chatRoomsWithBLOBs1.setRoomstatus("1");
        chatRoomsWithBLOBs1.setRoomnotice("风刀霜剑福建省");
        chatRoomsWithBLOBs1.setPassword("fdsfds");
        ChatRoomsWithBLOBs chatRoomsWithBLOBs2 = new ChatRoomsWithBLOBs();
        chatRoomsWithBLOBs2.setId(2);
        chatRoomsWithBLOBs2.setRoomstatus("2");
        chatRoomsWithBLOBs2.setRoomnotice("风刀霜剑福建省2");
        chatRoomsWithBLOBs2.setPassword("fdsfds2");
        chatRoomsWithBLOBs.add(chatRoomsWithBLOBs1);
        chatRoomsWithBLOBs.add(chatRoomsWithBLOBs2);
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            long l = listOps.rightPushAll("cachelist1", chatRoomsWithBLOBs);
            redisTemplate.expire("cachelist", 5000, TimeUnit.SECONDS);
        } catch (Throwable t) {
            t.printStackTrace();
        }*/

    }
}
