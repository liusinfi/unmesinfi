package com.jy.webchat.pojo;

import java.util.Date;

public class RoomMember extends RoomMemberKey {
    private Integer blacktype;

    private Date createdate;

    private String roomTitle;

    public String getRoomTitle() {
        return roomTitle;
    }

    public void setRoomTitle(String roomTitle) {
        this.roomTitle = roomTitle;
    }

    public Integer getBlacktype() {
        return blacktype;
    }

    public void setBlacktype(Integer blacktype) {
        this.blacktype = blacktype;
    }

    public Date getCreatedate() {
        return createdate;
    }

    public void setCreatedate(Date createdate) {
        this.createdate = createdate;
    }
}