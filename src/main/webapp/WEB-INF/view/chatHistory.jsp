<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String path = request.getContextPath();%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" >
    <title>KChat登陆</title>
    <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
    <script src="<%=path%>/static/plugins/amaze/js/amazeui.min.js"></script>
    <script src="<%=path%>/static/plugins/layer/layer.js"></script>
    <script src="<%=path%>/static/source/js/prefixfree.min.js"></script>
    <link rel="stylesheet" href="<%=path%>/static/plugins/amaze/css/amazeui.min.css">
    <link rel="stylesheet" href="<%=path%>/static/source/css/normalize.min.css">
    <link href="<%=path%>/static/source/css/web.css" rel='stylesheet' type='text/css' />
</head>
<body>
<div class="admin-content">
    <div class="am-scrollable-vertical" id="chat-view" style="height: 430px;resize:none;">
        <ul class="am-comments-list am-comments-list-flip" id="chatHISTORY">

            <li class="am-comment">
            </li>
        </ul>
    </div>
</div>

<script>
    $(function(){
        showHistory("${roomid}");
    });
    function showHistory(roomId) {
        $.ajax({
            type: "POST",
            async : false,
            data : {'roomId':roomId},
            url: '${ctx}/chatHistory',
            success: function (data) {
                var Jsonchatlist= eval("("+data +")");
                if(Jsonchatlist !=null && Jsonchatlist!='null' && Jsonchatlist.length > 0){
                    for(var key in Jsonchatlist){
                        var item = Jsonchatlist[key];
                        analysisHIS(item);
                    }
                }
            },
            error: function (error) {
                layer.msg(error, {
                    offset: 0,
                    shift: 10
                });
            }
        });
    }
    function analysisHIS(message) {
        if(message.type != "message"){      //会话消息
            return;
        }
        if(message.to == null || message.to == ""){
            return;
        }
        var contentsh = message.content;
        var array = new Array('gif', 'jpeg', 'png', 'jpg');  //可以上传的文件类型
        var lowk = contentsh.toLowerCase();
        var isExists = false;
        for (var i in array) {
            if (lowk.indexOf(array[i].toLowerCase()) > 0) {
                isExists = true;
                break;
            }

        }
        var lenCon = "";

        if(isExists ){
            var imgId = "I"+uuid(8,16);
            contentsh = "<img id=\""+imgId+"\" src=\""+contentsh + "\" alt=\"\" onclick=\"showimg('" + contentsh + "');\" style=\"/*objec-fit: cover;*/background-size: 'cover';width: 75%;height:75%;\">";
            lenCon = "450px"
        }else{
            lenCon = "200px";
        }
        if(contentsh.match(/{emoji_[0-9]*}+/g) != null && contentsh.match(/{emoji_[0-9]*}+/g).length > 0){
            var spl = contentsh.match(/{emoji_[0-9]*}+/g);
            for(var i=0;i<spl.length;i++){
                var ill = spl[i].replace("{","").replace("}","");
                contentsh = contentsh.replace(spl[i],"<img src=\"/static/source/emoji/"+ill+".png\" width='32' height='32'>");
            }
        }

        var divId = "D"+uuid(8,16);
        var spanId = "S" +uuid(8,16);
        var islref = '${userid}' == message.from ? "margin-left" : "margin-right";
        var headlr = '${userid}' == message.from ? "margin-right" : "margin-left";
        var headtexthr = '${userid}' == message.from ? "right" : "left";
        var html = "<li class=\"am-comment am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" style=\"width: 48px;height: 48px;\" alt=\"\" src=\"/"+message.from+"/head\"></a>" +
            "<header class=\"am-comment-hd\" style=\"border-bottom: 0px solid #fff;background:none;\"><div class=\"am-comment-meta\" style=\"background-color: #fff;"+headlr+":20px;text-align:"+headtexthr+";\">   <a class=\"am-comment-author\"  href=\"#link-to-user\">"+message.from+"</a>&nbsp;&nbsp;<time>"+message.time+"</time></div></header><div id=\""+divId+"\" class=\"am-comment-main\" style=\"border-radius: 15px;\">" +
            "<div class=\"am-comment-bd\" style=\"line-height: 1;word-wrap:break-word;word-break:break-all;\"><span id=\""+spanId+"\"> "+contentsh+"</span></div></div></li>";
        $("#chatHISTORY").append(html);
        var fontType = message.fonttype;
        if(fontType !=null && fontType!="" && fontType!=undefined && fontType !="undefined"){
            $("#"+spanId).css("color",fontType.color);
            $("#"+spanId).css("font-family",fontType.font_family);
            $("#"+spanId).css("font-size",fontType.font_size);
            $("#"+spanId).css("font-weight",fontType.font_weight);
            $("#"+spanId).css("text-decoration",fontType.text_decoration);
            $("#"+spanId).css("font-style",fontType.font_style);
        }
        if($("#"+imgId).length > 0){
            var imgwidth = Number($("#"+imgId).css("width").replace("px",""));
            var ajust = Number($("#"+divId).css("width").replace("px","")) - 150 - imgwidth;
            $("#"+divId).css(islref,"450px");
            var imlr = '${userid}' == message.from ? "right" : "left";
            $("#"+imgId).css("float",imlr);
        }else{
            var spanwidth = Number($("#"+spanId).css("width").replace("px",""));
            var ajust = Number($("#"+divId).css("width").replace("px","")) - 30 - spanwidth;
            if(ajust > 0)
                $("#"+divId).css(islref,ajust+"px");
        }
    }
</script>
</body>
</html>