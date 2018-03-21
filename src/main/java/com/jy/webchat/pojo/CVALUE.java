package com.jy.webchat.pojo;

public class CVALUE {
    public static String USER_VISITED = "user-vt-";
    public static String ROOM_ONLINE_USER = "onuser-";
    public static String ERRORINFO = "errorinfo";
    public static String ROOM_LIST = "roomlist";

    public static String SUCCESS = "0";
    public static String YK_JUMP_LOGIN = "1";//游客进入有密码房间跳转到登录
    public static String BLACK_USER = "2";//黑名单
    public static String JUMP_TO_PASSWORD = "3";//密码错误
    public static String WRONG_PASS = "4";//密码错误

    public static String BLACK_USER_NOTICE = "您已被踢出聊天室!";
    public static String WRONG_PASS_NOTICE = "密码错误";//密码错误

    public static String transCode(String code){
        if("2".equals(code)){
            return BLACK_USER_NOTICE;
        }else if("4".equals(code)){
            return WRONG_PASS_NOTICE;
        }
        return "";
    }
    public static String UPLOAD_SUCC = "0";
    public static String UPLOAD_NULL = "1";
    public static String UPLOAD_TYPE_ERR = "2";
    public static String UPLOAD_NULL_MSG = "上传图片为空!";
    public static String UPLOAD_TYPE_ERR_MSG = "请上传图片!";//密码错误

    public static String transCodeUpload(String code){
        if("1".equals(code)){
            return UPLOAD_NULL_MSG;
        }else if("2".equals(code)){
            return UPLOAD_TYPE_ERR_MSG;
        }
        return code;
    }

}
