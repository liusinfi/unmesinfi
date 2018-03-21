package com.jy.webchat.utils;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UploadUtil {

    /**
     * Spring MVC文件上传,返回的是经过处理的path+fileName
     * @param request    request
     * @param folder    上传文件夹
     * @param userid    用户名
     * @return
     */
    public String upload(HttpServletRequest request, String folder, String userid) throws UnsupportedEncodingException {
        boolean isHeadImg = Boolean.valueOf(request.getAttribute("isHeadImg").toString());
        FileUtil fileUtil = new FileUtil();
        String file_url = "";
        //创建一个通用的多部分解析器
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
        //判断 request 是否有文件上传,即多部分请求
        if(multipartResolver.isMultipart(request)){
            //转换成多部分request
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;
            //取得request中的所有文件名
            Iterator<String> iter = multiRequest.getFileNames();
            while(iter.hasNext()){
                //取得上传文件
                MultipartFile file = multiRequest.getFile(iter.next());
                String prefix = fileUtil.getFilePrefix(file);
                if(file != null){
                    if(file.getSize()/1024/1024 > 1){
                        return "error|上传图片不能大于1M!";
                    }
                    String orfilename = file.getOriginalFilename();
                    String reg = ".+(.JPEG|.jpeg|.JPG|.jpg|.GIF|.gif|.BMP|.bmp|.PNG|.png)$";
                    Pattern pattern = Pattern.compile(reg);
                    Matcher matcher = pattern.matcher(orfilename.toLowerCase());
                    if(!matcher.find()){
                        return "error|请上传图片";
                    }
                    //取得当前上传文件的文件名称
                    String myFileName = file.getOriginalFilename();
                    //如果名称不为"",说明该文件存在，否则说明该文件不存在
                    if(myFileName.trim() !=""){
                        //重命名上传后的文件名
                        String fileName =  System.currentTimeMillis() + "." + prefix;
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                        String dateformat = sdf.format(new Date());
                        String path = request.getServletContext().getRealPath("/") + folder + "/" + dateformat;
                        if(isHeadImg){
                            path = request.getServletContext().getRealPath("/") + folder + "/head";
                            //fileName = new String(userid.getBytes("ISO-8859-1"), "UTF-8");
                            fileName = EncryptUtil.encryptMd5(userid) + "." + prefix;
                        }
                        File localFile = new File(path, fileName);
                        if(!localFile.exists()){
                            localFile.mkdirs();
                        }
                        try {
                            file.transferTo(localFile);
                            file_url = folder + "/" + dateformat + "/" + fileName;
                            if(isHeadImg){
                                file_url = folder + "/head/"  + fileName;
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
        return file_url;
    }

    // 将base64字符文件输出图像
    public static String GenerateImage(String imgStr, String imgSuffix,HttpServletRequest request,boolean isHeadImg,String userid) {
        String folder = "upload";
        // 对字节数组字符串进行Base64解码并生成图片
        if (StringUtils.isEmpty(imgStr)) // 图像数据为空
            return "error|上传图片为空!";
        String reg = ".+(JPEG|jpeg|JPG|jpg|GIF|gif|BMP|bmp|PNG|png)$";
        Pattern pattern = Pattern.compile(reg);
        Matcher matcher = pattern.matcher(imgSuffix.toLowerCase());
        if(!matcher.find()){
            return "error|请上传图片!";
        }
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            // Base64解码
            byte[] b = decoder.decodeBuffer(imgStr);
            for (int i = 0; i < b.length; ++i) {
                if (b[i] < 0) {// 调整异常数据
                    b[i] += 256;
                }
            }
            String fileName =  System.currentTimeMillis() +  imgSuffix;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String dateformat = sdf.format(new Date());
            String path = request.getServletContext().getRealPath("/") + folder + "/" + dateformat;
            if(isHeadImg){
                path = request.getServletContext().getRealPath("/") + folder + "/head";
                //fileName = new String(userid.getBytes("ISO-8859-1"), "UTF-8");
                fileName = userid +  imgSuffix;
            }
            File localFile = new File(path);
            if(!localFile.exists()){
                localFile.mkdirs();
            }
            OutputStream out = new FileOutputStream(path+"/"+fileName);
            out.write(b);
            out.flush();
            out.close();
            String file_url = folder + "/" + dateformat + "/" + fileName;
            if(isHeadImg){
                file_url =  folder + "/head/"  + fileName;
            }
            return file_url;
        } catch (Throwable e) {
            return "error|" + e.getMessage();
        }
    }

    // 图片转化成base64字符串
    public static String GetImageStr() {
        // 将图片文件转化为字节数组字符串，并对其进行Base64编码处理
        String imgFile = "d://test.jpg";// 待处理的图片
        InputStream in = null;
        byte[] data = null;
        // 读取图片字节数组
        try {
            in = new FileInputStream(imgFile);
            data = new byte[in.available()];
            in.read(data);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 对字节数组Base64编码
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);// 返回Base64编码过的字节数组字符串
    }
}
