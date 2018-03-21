package com.jy.webchat.utils;


public class EncryptUtil {

    public static String encryptMd5(String s){
        return encryptStrWith32MD5(s);
    }

    private static String encryptStrWith32MD5(String s){
        MD5 m = new MD5();
        return m.toDigest(s);
    }
    
    public static String enPass(String tpass){
    	String tmp1 = tpass.substring(0,10);
        String tmp2 = tpass.substring(10,25);
        String tmp3 = tpass.substring(25);
        String s = String.valueOf(Math.random() * 1000000);
        tpass = tmp1 + s.substring(1,2) + tmp2 + s.substring(4,5) + tmp3;
        return tpass;
    }
    
    public static void main(String[] args) {
		System.out.println(EncryptUtil.encryptMd5("东方安全"));
	}

}