package com.jy.webchat.pojo;

public class SysConfig {
    private Integer id;

    private String syslocate;

    private String lasttime;

    private String syscontent;

    private String syshost;

    private String onlineconsult;

    public String getOnlineconsult() {
        return onlineconsult;
    }

    public void setOnlineconsult(String onlineconsult) {
        this.onlineconsult = onlineconsult;
    }

    public String getSyshost() {
        return syshost;
    }

    public void setSyshost(String syshost) {
        this.syshost = syshost;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSyslocate() {
        return syslocate;
    }

    public void setSyslocate(String syslocate) {
        this.syslocate = syslocate == null ? null : syslocate.trim();
    }

    public String getLasttime() {
        return lasttime;
    }

    public void setLasttime(String lasttime) {
        this.lasttime = lasttime == null ? null : lasttime.trim();
    }

    public String getSyscontent() {
        return syscontent;
    }

    public void setSyscontent(String syscontent) {
        this.syscontent = syscontent == null ? null : syscontent.trim();
    }
}