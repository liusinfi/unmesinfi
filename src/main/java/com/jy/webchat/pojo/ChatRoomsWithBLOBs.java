package com.jy.webchat.pojo;

import java.io.Serializable;

public class ChatRoomsWithBLOBs extends ChatRooms implements Serializable{
    private static final long serialVersionUID = -333545145159666123L;
    private String roomcontent;

    private String roomtitle;

    private String roomnotice;

    private String roomstatus;

    public String getRoomstatus() {
        return roomstatus;
    }

    public void setRoomstatus(String roomstatus) {
        this.roomstatus = roomstatus;
    }

    public String getRoomnotice() {
        return roomnotice;
    }

    public void setRoomnotice(String roomnotice) {
        this.roomnotice = roomnotice;
    }

    public String getRoomcontent() {
        return roomcontent;
    }

    public void setRoomcontent(String roomcontent) {
        this.roomcontent = roomcontent == null ? null : roomcontent.trim();
    }

    public String getRoomtitle() {
        return roomtitle;
    }

    public void setRoomtitle(String roomtitle) {
        this.roomtitle = roomtitle == null ? null : roomtitle.trim();
    }
}