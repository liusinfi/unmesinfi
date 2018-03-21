<%@ page import="com.jy.webchat.pojo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" >
    <jsp:include page="../include/commonfile.jsp"/>
    <link rel="stylesheet" href="${ctx}/static/source/css/input.css">
    <script src="${ctx}/static/plugins/jquery/jquery-ui.min.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.fileupload.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.ui.widget.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.iframe-transport.js"></script>
    <script src="${ctx}/static/source/js/mobileBUGFix.mini.js"></script>
    <script src="${ctx}/static/source/dojs/picts.js"></script>
    <script src="${ctx}/static/source/dojs/phchatfn.js"></script>
    <link rel="stylesheet" href="${ctx}/static/source/css/phone.css">
</head>
<body>
<header class="am-topbar am-topbar-inverse admin-header">
    <div class="am-topbar-brand">
        <i class="am-icon-chevron-left" onclick="backChatList()"></i>&nbsp;&nbsp;<span id="smalltitle"></span>
    </div>
    <button class="am-topbar-btn am-topbar-toggle am-btn am-btn-sm am-btn-success am-show-sm-only" onclick="showRoomInfo()" <%--data-am-offcanvas="{target: '#admin-offcanvas'}"--%>><span class="am-sr-only">导航切换</span> <span class="am-icon-bars"></span></button>
</header>
<div class="admin-content <%--am-g-fixed--%>" style="scrolling:no;background-color: #f2f1f1;">
    <div class="admin-content-body">
        <table >
            <div class="" >
                <!-- 聊天区 -->
                <div class="am-scrollable-vertical" id="chat-view" style="height: 430px;resize:none;overflow-x: hidden;">
                    <div class="am-form-group am-form" id="touzhushan" style="margin-bottom: 0.5rem;">
                        <div>
                            <a href="javascript:void(0);" onclick="$('#phonejumpdiv').show();" style="padding: 10px;color: #824444;">在线投注</a>
                            <a href="javascript:void(0);" onclick="$('#phoneappimgdiv').show();" style="padding: 10px;color: #824444;">APP下载</a>
                        </div>
                    </div>
                    <ul class="am-comments-list am-comments-list-flip" id="chat">
                    </ul>
                </div>
                <div id="UINPUT">
                <div class="chat-toolbar">
                    <%--<a href="javascript:void(0);" class="icon-font current" onclick="showchgdailog(this)">字体</a>
                    <a href="javascript:;" class="icon-emote" onclick="showchgdailog(this)">表情</a>--%>
                        <a href="#" class="icon-font current">字体</a>
                        <a href="#" class="icon-emote">表情</a>
                    <a href="javascript:void(0);" class="icon-image" onclick="fileInport()">图片</a>
                    <%--<div class="pull-right">
                        <span class="pull-right btn-history" onclick="openWin('')">聊天记录</span>
                    </div>--%>
                </div>
                <!-- 输入区 -->
                <div class="am-form-group am-form" style="margin-bottom: 0.5rem;" >
                    <%--<div class="dmsgcls" id="message" name="message" contenteditable="true" ></div>--%>
                                <div contenteditable="true" id="message" name="message" class="phoneinput"></div>
                    <div style="width: 18%;float: right;display: inline-block;">
                        <button class="am-btn am-btn-primary am-round am-btn-xs" type="button" onclick="sendMessage()"><span class="am-icon-commenting"></span> 发送</button>
                    </div>
                </div>
                </div>
                <div class="am-form-group am-form" id="YKSHOW" style="margin-bottom: 0.5rem;">
                    <div><a href="/user/login?show=register" style="padding: 10px;">注册</a><a href="/user/login"style="padding: 10px;">登录</a></div>
                </div>
            </div>
            <!-- 列表区 -->
        </table>
        <%@include file="../include/emojicolor.jsp" %>
    </div>
</div>
<div class="am-modal am-modal-loading am-modal-no-btn" tabindex="-1" id="my-modal-loading">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">正在载入...</div>
        <div class="am-modal-bd">
            <span class="am-icon-spinner am-icon-spin"></span>
        </div>
    </div>
</div>
<%@include file="roominfo.jsp" %>
<%@include file="roommembers.jsp" %>
<%@include file="atmembers.jsp" %>
<%@include file="phoneChatHistory.jsp" %>
<%@include file="phoneappdown.jsp" %>
<%@include file="touzhuweb.jsp" %>
<script>
    var temsecretid = "";
    $(function () {
        $("#my-modal-loading").modal('open');
        var reg = new RegExp( '<br>' , "g" );
        $("#syscontent").html(decodeURI("${roomNotice}"));
        $("#smalltitle").html(decodeURI("${roomTitle}"));
        /*$('#filesend').fileupload({
            done: function (e, data) {
                if(data.result){
                    var i = data.result.split("|");
                    if(i[0]=="success"){
                        sendMessage(i[1]);
                    }else{
                        alert(i[2]);
                    }
                }
            }
        });*/
        $("input[type=file]").each(
            function() {
                var _this = $(this);
                _this.localResizeIMG({
                    width : 600,
                    quality : 0.8,
                    success : function(result) {
                        //获取后缀名
                        var att = pre.substr(pre.lastIndexOf("."));
                        //压缩后图片的base64字符串
                        var base64_string = result.clearBase64;
                        //图片预览
                        var imgObj = $("#imgtem");
                        imgObj.attr("src","data:image/jpeg;base64," + base64_string).show();
                        //拼接data字符串，传递会后台
                        var fileData = att + "," + imgObj.attr("src")
                        $.ajax({
                            type : "POST",
                            url : "<%=request.getContextPath()%>/DoUploadImg",
                            data :{
                                'imgData' : fileData
                            },
                            success : function(msg) {
                                if(msg){
                                    var i = msg.split("|");
                                    if(i[0]=="success"){
                                        sendMessage(i[1]);
                                    }else{
                                        alert(i[2]);
                                    }
                                }
                            },
                            error : function (error) {
                                layer.msg(error, {
                                    offset: 0,
                                    shift: 6
                                });
                            }
                        });

                    }
                });
            });



        IFrameResize();
        ReWritable();
        $(".icon-font").click(function(e){
            if($("#fontchange").is(":hidden")){
                $("#fontchange").show();
            }else{
                $("#fontchange").hide();
            }
            e.stopPropagation();
        });
        $(".icon-emote").click(function(e){
            if($(".box_emote").is(":hidden")){
                $(".box_emote").show();
            }else{
                $(".box_emote").hide();
            }
            e.stopPropagation();
        });
        $(document).click(function (e) {
            if(!$(".box_emote").is(":hidden")){
                $(".box_emote").hide();
            }
            if(!$("#fontchange").is(":hidden")){
                $("#fontchange").hide();
            }
            e.stopPropagation();
        });
        $(".box_font td span").mouseover(function(){
            $(this).addClass("hover");
        });
        $(".box_font td span").mouseout(function(){
            $(this).removeClass("hover");
        });
        $(".box_font td span").click(
            function(){
                if($(this).hasClass("font-color")){
                    if($("#colorpanel").is(":hidden")){
                        $("#colorpanel").show();
                    }else{
                        $("#colorpanel").hide();
                    }
                    return;
                }
                var tmsek = "#message";
                if(temsecretid != null && temsecretid!=""){
                    var xcontent = $("#"+escapeJquery(temsecretid)+"content");
                    if(xcontent.length>0 && xcontent.hasClass("am-active")){
                        tmsek = tmsek + "-" + escapeJquery(temsecretid);
                    }
                }
                if($(this).hasClass("current")){
                    $(this).removeClass("current");
                    if($(this).hasClass("font-b")){
                        $(tmsek).css("font-weight","normal");
                    }
                    if($(this).hasClass("font-i")){
                        $(tmsek).css("font-style","normal");
                    }
                    if($(this).hasClass("font-u")){
                        $(tmsek).css("text-decoration","none");
                    }
                }else{
                    $(this).addClass("current");
                    if($(this).hasClass("font-b")){
                        $(tmsek).css("font-weight","bold");
                    }
                    if($(this).hasClass("font-i")){
                        $(tmsek).css("font-style","italic");
                    }
                    if($(this).hasClass("font-u")){
                        $(tmsek).css("text-decoration","underline");
                    }

                }
            }
        );
        $(".font-family").change(function(){
            var tmsek = "#message";
            if(temsecretid != null && temsecretid!=""){
                var xcontent = $("#"+escapeJquery(temsecretid)+"content");
                if(xcontent.length>0 && xcontent.hasClass("am-active")){
                    tmsek = tmsek + "-" + escapeJquery(temsecretid);
                }
            }
            $(tmsek).css("font-family",$(this).children('option:selected').val());
        });
        $(".font-size").change(function(){
            var tmsek = "#message";
            if(temsecretid != null && temsecretid!=""){
                var xcontent = $("#"+escapeJquery(temsecretid)+"content");
                if(xcontent.length>0 && xcontent.hasClass("am-active")){
                    tmsek = tmsek + "-" + escapeJquery(temsecretid);
                }
            }
            $(tmsek).css("font-size",$(this).children('option:selected').val() + "px");
        });

        $("#_cclose").click(function(){
            $("#colorpanel").hide();
        });
        $("#_creset").click(function(){
            $("#DisColor").css("background-color","#000000");
            $("#HexColor").val("#000000");
        });

        window.setTimeout(function(){
            $("#my-modal-loading").modal('close');
        }, 1500);

        if("${userid}".indexOf("YKMODE")==0){
            $("#UINPUT").remove();
            $("#YKSHOW").show();
        }
        $('#message').on('focus',function(event){
            //自动反弹 输入法高度自适应
            setTimeout(function() {
                $('body').scrollTop($('body')[0].scrollHeight);
            }, 1000);
            /*var target = this;
            setTimeout(function(){
                //$(window).scrollTop();
                target.scrollTop;
            },100);*/
        });
    });




    if("${message}"){
        layer.msg('${message}', {
            offset: 0
        });
    }
    if("${error}"){
        layer.msg('${error}', {
            offset: 0,
            shift: 6
        });
    }

    var wsServer = null;
    //var dksf = "192.168.31.127:8080";
    //wsServer = "ws://"+dksf + "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";
    wsServer = "ws://" +document.domain+ "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";
    //wsServer = "ws://"+"${syshost}" + "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";
    var ws = null;

    var timeid, reconnect=false;
    webSocket();
    function webSocket(){
        //连接WebSocket
        ws = new WebSocket(wsServer);
        ws.onopen = function(evt) {
            layer.msg("已经建立连接", { offset: 0});
            timeid && window.clearInterval(timeid);
            heartCheck.start();
            if(reconnect){
                layer.msg("重新建立连接", { offset: 0});
                showHistory('${roomid}');
            }
        };
        ws.onmessage = function(evt){
            heartCheck.reset();
            analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
        };
        ws.onerror = function (evt) {
            layer.msg("产生异常", { offset: 0});
        };
        //当断开时进行判断
        ws.onclose=function(evt){
            window.clearInterval(timeid);
            //判断是否为苹果ios系统
            reconnect=true;
            timeid = window.setInterval(webSocket, 3000);
        }
    }
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
                        analysisMessage(item);
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
    var heartCheck = {
        timeout: 30000,
        timeoutObj: null,
        serverTimeoutObj: null,
        reset: function(){
            clearTimeout(this.timeoutObj);
            this.start();
        },
        start: function(){
            var self = this;
            this.timeoutObj = setTimeout(function(){
                ws.send(JSON.stringify({
                    type : "heartbeat"
                }));
            }, this.timeout)
        },
    }
    function subgo(){
        //$('#doc-tab-demo-1').tabs('open',$('#chatwin'));
        window.open("${syslocate}");
    }

    function addTab(secretid,isls) {
        if("${userid}"== secretid){
            return;
        }
        if($("#liit"+escapeJquery(secretid)).hasClass("graydown")){
            layer.msg(secretid+'该用户未上线!', {
                offset: 0,
                shift: 6
            });
            return;
        }
        if($("#htmksecret-"+escapeJquery(secretid)).length>0){
            $("#secretaddhtml").show();
            $("#roommembersctrl").hide();
            $("#roominfoctrl").hide();
            $(".hidectrl").hide();
            $("#htmksecret-"+escapeJquery(secretid)).show();
            //$("#admin-offcanvas").offCanvas('close');
            temsecretid = secretid;
            return;
        }
        var isChatAdmin = false;
        if($("#liit"+escapeJquery(secretid)).children("a").hasClass("adminclr")){
            isChatAdmin = true;
        }
        //判断是否有私聊权限
        var isSecretChat = false;
        if(!isChatAdmin){
            $.ajax({
                type: "POST",
                async : false,
                url: '/secretchatk',
                success: function (msg) {
                    if(msg=="success"){
                        isSecretChat = true;
                    }
                },
                error: function (error) {
                    layer.msg(error, {
                        offset: 0,
                        shift: 10
                    });
                }
            });
            if(!isSecretChat && isls ==null){
                layer.msg("您没有私聊权限", {
                    offset: 0,
                    shift: 10
                });
                return;
            }
        }

        $("#searchidx").hide();
        var secrethtml = getHtml(secretid);
        $("#secretaddhtml").append(secrethtml);
        $(".secretaddclass").css("width",document.body.clientWidth);
        //$("#clse-"+secretid).css("margin-left",document.body.clientWidth/2-Number($("#clse-"+secretid).css("width").replace("px",""))/2);
        $("#secretaddhtml").show();
        $(".hidectrl").hide();
        $("#htmksecret-"+escapeJquery(secretid)).show();
        //$("#admin-offcanvas").offCanvas('close');
        temsecretid = secretid;
       /* $(".clse").css("margin-left",)
        margin-left: 100px;*/
       $("#roommembersctrl").hide();
       $("#roominfoctrl").hide();
    }

    function IFrameResize(){
        $("#chat-view").css("height",${chathei4});
    }


    /**
     * 发送信息给后台
     * obj 发送图片时候传入
     * user为私聊时候传入
     */
    function sendMessage(obj){
        if(ws == null){
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
            return;
        }
        if(ws.readyState != 1){
            layer.msg("连接未建立完成,请等待!", { offset: 0, shift: 6 });
            return;
        }
        var messagemS = "#message";
        var message = $(messagemS).html().replace("\\n","</br>");
        if(obj !=null && obj!=""){
            message = "/" + obj;
        }
        var to = $("#sendto").text() == "全体成员"? "": $("#sendto").text();
        if(temsecretid !=null && temsecretid !=""){
            to = temsecretid;
        }
        if(message == null || message == ""){
            layer.msg("请输入您要发送的内容!", { offset: 0, shift: 6 });
            return;
        }
        ws.send(JSON.stringify({
            message : {
                content : message,
                from : '${userid}',
                to : to,      //接收人,如果没有则置空,如果有多个接收人则用,分隔
                time : getDateFull(),
                fonttype : {'color':rgb2hex($(messagemS).css("color")),'font_size':$(messagemS).css("font-size"),'font_family':$(messagemS).css("font-family"),'font_weight':$(messagemS).css("font-weight"),'text_decoration':$(messagemS).css("text-decoration"),'font_style':$(messagemS).css("font-style")}
            },
            type : "message"
        }));
        if(obj !=null && obj!=""){
        }else{
            $(messagemS).html("");
        }
    }

    function showChat(message){
        var chatViewmS = "#chat-view";
        var chatmS = "#chat";
        var messagemS = "#message";
        if(message.to != null && message.to != ""){
            if('${userid}' == message.to){
                chatViewmS = chatViewmS + "-" + escapeJquery(message.from);
                chatmS =  chatmS + "-" + escapeJquery(message.from);
                //messagemS =  messagemS + "-" + message.from;
                var isExistSecretWin = $(chatViewmS);
                if(!(isExistSecretWin.length > 0)){
                    addTab(message.from,message.from);
                }else{
                    $("#secretaddhtml").show();
                    $("#roommembersctrl").hide();
                    $("#roominfoctrl").hide();
                    $(".hidectrl").hide();
                    $("#htmksecret-"+escapeJquery(message.from)).show();
                    //$("#admin-offcanvas").offCanvas('close');
                    temsecretid = message.from;
                }
            }else{
                chatViewmS = chatViewmS + "-" + escapeJquery(message.to);
                chatmS =  chatmS + "-" + escapeJquery(message.to);
                //messagemS =  messagemS + "-" + message.to;
            }
        }
        var chat = $(chatViewmS);
        var isDown = false;
        var divHeight = chat.height();
        var nScrollHeight = chat[0].scrollHeight;
        var nScrollTop = chat[0].scrollTop;
        if(nScrollTop + divHeight >= nScrollHeight) {
            isDown = true;
        }


        var to = message.to == null || message.to == ""? "全体成员" : message.to;   //获取接收人


        var contentsh = message.content;
        if(contentsh.indexOf("@${userid}&nbsp;&nbsp;")>=0 || contentsh.indexOf("@${userid} &nbsp;&nbsp;")>=0){
            //显示@栏
            showAtInfo(message.from,contentsh,"${userid}");
        }
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
            lenCon = "200px"
        }else{
            lenCon = "200px";
        }
        //content.match("{emoji_\d{1,2}")
        if(contentsh.match(/{emoji_[0-9]*}+/g) != null && contentsh.match(/{emoji_[0-9]*}+/g).length > 0){
            var spl = contentsh.match(/{emoji_[0-9]*}+/g);
            for(var i=0;i<spl.length;i++){
                var ill = spl[i].replace("{","").replace("}","");
                contentsh = contentsh.replace(spl[i],"<img src=\"/static/source/emoji/"+ill+".png\" width='25' height='25'>");
            }
        }
        //var lenCon =
        var divId = "D"+uuid(8,16);
        var spanId = "S" +uuid(8,16);
        var isSef = '${userid}' == message.from ? "am-comment-flip" : "";   //如果是自己则显示在右边,他人信息显示在左边
        var islref = '${userid}' == message.from ? "margin-left" : "margin-right";
        var headlr = '${userid}' == message.from ? "margin-right" : "margin-left";
        var headtexthr = '${userid}' == message.from ? "right" : "left";
        var hms = message.time.substring(10,message.time.length);
        var temd = $("#liit"+escapeJquery(message.from)).children("img")[0].src;
        var fromimg = temd!=null&&temd!=undefined&&temd!=""&&temd!='undefined' ? temd : "/"+message.from+"/head";
        var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" style=\"width: 48px;height: 48px;\" alt=\"\" src=\""+fromimg+"\"></a>" +
            "<header class=\"am-comment-hd\" style=\"background-color: #f2f1f1;background:none;\"><div class=\"am-comment-meta\" style=\"background-color: #f2f1f1;"+headlr+":10px;text-align:"+headtexthr+";\">   <a class=\"am-comment-author\"  href=\"#link-to-user\">"+message.from+"</a>&nbsp;&nbsp;<time>"+hms+"</time></div></header><div id=\""+divId+"\" class=\"am-comment-main\" style=\"border-radius: 15px;\">" +
            "<div class=\"am-comment-bd\" style=\"line-height: 1;width:"+(document.body.clientWidth-75)+"px;\"><span id=\""+spanId+"\"> "+contentsh+"</span></div></div></li>";
        $(chatmS).append(html);
        var fontType = message.fonttype;
        $("#"+spanId).css("color",fontType.color);
        $("#"+spanId).css("font-family",fontType.font_family);
        $("#"+spanId).css("font-size",fontType.font_size);
        $("#"+spanId).css("font-weight",fontType.font_weight);
        $("#"+spanId).css("text-decoration",fontType.text_decoration);
        $("#"+spanId).css("font-style",fontType.font_style);
        if($("#"+imgId).length > 0){
            var imgwidth = Number($("#"+imgId).css("width").replace("px",""));
            var ajust = window.screen.width - 95 - imgwidth;
            $("#"+divId).css(islref,ajust+"px");
        }else{
            var spanwidth = Number($("#"+spanId).css("width").replace("px",""));
            var ajust = window.screen.width - 95 - spanwidth;
            $("#"+divId).css(islref,ajust+"px");
        }
        //$(messagemS).val("");  //清空输入区
        //var chat = $(chatViewmS);
        //if('${userid}' == message.from){
        //    chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
        //}
        if(isDown){
            chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
        }
        if('${userid}' != message.from){
            /*$('body').on('touchstart',function(){
                $('#chatAudio')[0].play();
            })*/

        }
    }

    function showimg(obj){
        /*$(".img_show").html("");
        var html = "<figure data-am-widget=\"figure\" class=\"am am-figure am-figure-default \"   data-am-figure=\"{  pureview: 'true' }\">" +
            "<img id='ImgZoomInImage'  alt='' src='" + obj + "' data-rel='"+obj+"'></figure>";
        $(".img_show").html(html);
        /!*$(".img_show").css("height",$(document).height());
        $(".img_show").css("width",$(document).width());*!/
        ///$('#ImgZoomInImage').css('left', $(window).scrollLeft() + ($(window).width() - $('#ImgZoomInImage').width()) / 2);
        //$('#ImgZoomInImage').css('top', $(window).scrollTop() + ($(window).height() - $('#ImgZoomInImage').height()) / 2);
        $(".img_show").show();*/
    }

    function showOnline(list,onuser) {
        if('${userid}' == onuser){//如果上线的是自己当前，将在线列表的用户全部上线。
            if(!$("#liit"+escapeJquery(onuser)).length>0){
                var li = "<li id=\"liit"+onuser+"\" class=\"graydown\"><img width=\"48\" height=\"48\" style=\"border-radius:50%;\"  alt=\"\" src=\"${ctx}/upload/resizeApi.png\"><a href=\"javascript:void(0);\" style=\"display:inline;padding-left: 0.3rem;\"";
                li= li + " onclick=\"addTab('" +onuser+ "')\">" +onuser+"</a></li>";
                $("#list").append(li);
            }
            $.each(list, function(index, item){
                $("#liit"+escapeJquery(item)).removeClass("graydown");
                $("#liit"+escapeJquery(item)).insertBefore("#list li:eq(0)");
            });
        }else{
            //不是当前用户，将刚上线的用户置为上线。
            if($("#liit"+escapeJquery(onuser)).length>0){
                $("#liit"+escapeJquery(onuser)).removeClass("graydown");
                $("#liit"+escapeJquery(onuser)).insertBefore("#list li:eq(0)");
            }else{//对于新注册的用户可能没有在之前的上线列表中，有时间差，先有人已登录，后有人注册了。添加一条并置为上线
                var li = "<li id=\"liit"+onuser+"\" class=\"graydown\"><img width=\"48\" height=\"48\" style=\"border-radius:50%;\"  alt=\"\" src=\"${ctx}/upload/resizeApi.png\"><a href=\"javascript:void(0);\" style=\"display:inline;padding-left: 0.3rem;\"";
                li= li + " onclick=\"addTab('" +onuser+ "')\">" +onuser+"</a></li>";
                $("#list").append(li);
                $("#liit"+escapeJquery(onuser)).removeClass("graydown");
                $("#liit"+escapeJquery(onuser)).insertBefore("#list li:eq(0)");
            }
        }
        $.each($(".adminclr"), function(index, item){
            if(item.parentNode.className != "graydown"){
                $("#" + escapeJquery(item.parentNode.id)).insertBefore("#list li:eq(0)");
            }
        });
    }
    function outChat(user) {
        closeConnection();
        if('${userid}' == user){
            window.location='/unchk/first';
        }
    }


</script>
</body>
</html>
