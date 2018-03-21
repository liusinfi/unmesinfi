package com.jy.webchat.pojo;

import java.io.Serializable;
import java.util.Date;

public class ChatRooms implements Serializable{
    private static final long serialVersionUID = -8501943384243463962L;
    private Integer id;

    private Integer roomtype;

    private Date createdate;

    private Integer roommember;

    private String lasttime;

    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getRoomtype() {
        return roomtype;
    }

    public void setRoomtype(Integer roomtype) {
        this.roomtype = roomtype;
    }

    public Date getCreatedate() {
        return createdate;
    }

    public void setCreatedate(Date createdate) {
        this.createdate = createdate;
    }

    public Integer getRoommember() {
        return roommember;
    }

    public void setRoommember(Integer roommember) {
        this.roommember = roommember;
    }

    public String getLasttime() {
        return lasttime;
    }

    public void setLasttime(String lasttime) {
        this.lasttime = lasttime == null ? null : lasttime.trim();
    }
}