package com.jy.webchat.utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import com.google.gson.JsonSyntaxException;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Value;

import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.Map.Entry;

public class WxAuthUtil {
    /*@Value("${WXMP.APPID}")*/
    private static String APPID = "";
    /*@Value("${WXMP.APPSECRET}")*/
    private static String APPSECRET = "";
    // 与接口配置信息中的Token要一致
    /*@Value("${WXMP.TOKEN}")*/
    private static String token = "";
    // 临时二维码 
    private final static String QR_SCENE = "QR_SCENE";  
    // 永久二维码  
    private final static String QR_LIMIT_SCENE = "QR_LIMIT_SCENE";  
    // 永久二维码(字符串)  
    private final static String QR_LIMIT_STR_SCENE = "QR_LIMIT_STR_SCENE";   
    // 创建二维码  
    private static String create_ticket_path = "https://api.weixin.qq.com/cgi-bin/qrcode/create";  
    // 通过ticket换取二维码  
    private static String showqrcode_path = "https://mp.weixin.qq.com/cgi-bin/showqrcode";

    static {
        Properties prop = new Properties();
        InputStream in = null;
        try{
            in = Class.forName(WxAuthUtil.class.getName()).getResourceAsStream("/config/wxmp.properties");
            prop.load(in);     ///加载属性列表
            Iterator<String> it=prop.stringPropertyNames().iterator();
            while(it.hasNext()){
                String key=it.next();
                if("WXMP.APPID".equals(key)){
                    APPID = prop.getProperty(key);
                }
                if("WXMP.APPSECRET".equals(key)){
                    APPSECRET = prop.getProperty(key);
                }
                if("WXMP.TOKEN".equals(key)){
                    token = prop.getProperty(key);
                }
            }
        }
        catch(Exception e){
        }finally {
            if(in!=null)
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
    }

    public static Map<String,String> getUserInfoAccessToken(String code){
        JsonObject object = null;
        Map<String,String> data = new HashMap();
        if(StringUtils.isEmpty(code)){
            return null;
        }
        String url = String.format("https://api.weixin.qq.com/sns/oauth2/access_token?" +
                        "appid=%s&secret=%s&code=%s&grant_type=authorization_code",
                APPID,APPSECRET,code);
        String tokens = "";
        Gson token_gson = new Gson();
        object = token_gson.fromJson(tokens, JsonObject.class);
        data.put("openid", object.get("openid").toString().replaceAll("\"", ""));
        data.put("access_token", object.get("access_token").toString().replaceAll("\"", ""));
        return null;
    }

    public static Map<String, String> getUserInfo(String accessToken, String openId) {
        Map<String, String> data = new HashMap();
        String url = "https://api.weixin.qq.com/sns/userinfo?access_token=" + accessToken + "&openid=" + openId + "&lang=zh_CN";
        JsonObject userInfo = null;
        try {
            DefaultHttpClient httpClient = new DefaultHttpClient();
            HttpGet httpGet = new HttpGet(url);
            HttpResponse httpResponse = httpClient.execute(httpGet);
            HttpEntity httpEntity = httpResponse.getEntity();
            String response = EntityUtils.toString(httpEntity, "utf-8");
            Gson token_gson = new Gson();
            userInfo = token_gson.fromJson(response, JsonObject.class);
            data.put("openid", userInfo.get("openid").toString().replaceAll("\"", ""));
            data.put("nickname", userInfo.get("nickname").toString().replaceAll("\"", ""));
            data.put("city", userInfo.get("city").toString().replaceAll("\"", ""));
            data.put("province", userInfo.get("province").toString().replaceAll("\"", ""));
            data.put("country", userInfo.get("country").toString().replaceAll("\"", ""));
            data.put("headimgurl", userInfo.get("headimgurl").toString().replaceAll("\"", ""));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return data;
    }
    
    public static String getAccessToken(){
    	String accessToken = "";
    	JsonObject userInfo;
    	try {
			String url = String.format("https://api.weixin.qq.com/cgi-bin/token?"
							+ "grant_type=client_credential&appid=%s&secret=%s",
							APPID, APPSECRET);
			String response = HttpRequestUtil.get(url);
			userInfo = null;
			Gson token_gson = new Gson();
			userInfo = token_gson.fromJson(response, JsonObject.class);
			accessToken = userInfo.get("access_token").toString();
			accessToken = accessToken.replaceAll("\"", "");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return accessToken;
    }
    
    public static String createTempTicket(String accessToken, String expireSeconds, int sceneId) throws IOException {
        try {
            Map<String,Integer> intMap = new HashMap<String,Integer>();
            intMap.put("scene_id",sceneId);
            Map<String,Map<String,Integer>> mapMap = new HashMap<String,Map<String,Integer>>();
            mapMap.put("scene", intMap);
            Map<String,Object> paramsMap = new HashMap<String,Object>();
            paramsMap.put("expire_seconds", expireSeconds);
            paramsMap.put("action_name", QR_SCENE);
            paramsMap.put("action_info", mapMap);
            String data = new Gson().toJson(paramsMap);
            String tse = HttpRequestUtil.post(create_ticket_path+"?access_token="+accessToken, data);
            Gson ticket_gson = new Gson();
            JsonObject ticketInfo = ticket_gson.fromJson(tse, JsonObject.class);
            String ticket = ticketInfo.get("ticket").toString().replaceAll("\"", "");
            return showqrcode_path+"?ticket="+ticket;
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 验证签名
     * 
     * @param signature
     * @param timestamp
     * @param nonce
     * @return
     */
    public static boolean checkSignature(String signature, String timestamp, String nonce) {
        String[] arr = new String[] { token, timestamp, nonce };
        // 将token、timestamp、nonce三个参数进行字典序排序
        // Arrays.sort(arr);
        sort(arr);
        StringBuilder content = new StringBuilder();
        for (int i = 0; i < arr.length; i++) {
            content.append(arr[i]);
        }
        MessageDigest md = null;
        String tmpStr = null;

        try {
            md = MessageDigest.getInstance("SHA-1");
            // 将三个参数字符串拼接成一个字符串进行sha1加密
            byte[] digest = md.digest(content.toString().getBytes());
            tmpStr = byteToStr(digest);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        content = null;
        // 将sha1加密后的字符串可与signature对比，标识该请求来源于微信
        return tmpStr != null ? tmpStr.equals(signature.toUpperCase()) : false;
    }

    /**
     * 将字节数组转换为十六进制字符串
     * 
     * @param byteArray
     * @return
     */
    private static String byteToStr(byte[] byteArray) {
        String strDigest = "";
        for (int i = 0; i < byteArray.length; i++) {
            strDigest += byteToHexStr(byteArray[i]);
        }
        return strDigest;
    }

    /**
     * 将字节转换为十六进制字符串
     * 
     * @param mByte
     * @return
     */
    private static String byteToHexStr(byte mByte) {
        char[] Digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
        char[] tempArr = new char[2];
        tempArr[0] = Digit[(mByte >>> 4) & 0X0F];
        tempArr[1] = Digit[mByte & 0X0F];
        String s = new String(tempArr);
        return s;
    }
    public static void sort(String a[]) {
        for (int i = 0; i < a.length - 1; i++) {
            for (int j = i + 1; j < a.length; j++) {
                if (a[j].compareTo(a[i]) < 0) {
                    String temp = a[i];
                    a[i] = a[j];
                    a[j] = temp;
                }
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
    	System.out.println(createTempTicket(getAccessToken(),"6400",12345));
	}
}
