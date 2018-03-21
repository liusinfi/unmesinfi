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
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" >
    <jsp:include page="include/commonfile.jsp"/>
    <link rel="stylesheet" href="${ctx}/static/source/css/input.css">
    <script src="${ctx}/static/plugins/jquery/jquery-ui.min.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.fileupload.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.ui.widget.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.marquee.js"></script>
    <script src="${ctx}/static/source/js/grayscale.js"></script>
    <script src="${ctx}/static/source/js/position.js"></script>
    <script src="${ctx}/static/source/js/mobileBUGFix.mini.js"></script>
    <script src="${ctx}/static/source/dojs/picts.js"></script>
    <script src="${ctx}/static/source/dojs/wcfn.js"></script>
</head>
<body style="font-size: 1.4rem;line-height: 1.2;background: none;">
<div class="admin-content <%--am-g-fixed--%>" style="scrolling:no;">
    <div class="img_show" align="center" style="display: none;"></div>

    <div class="chat_his" style="display: none;">
        <header class="am-topbar" style="margin-bottom: 0rem;">
            <h1 class="am-topbar-brand">
                <a href="#">聊天记录</a>
            </h1>
            <div class="am-collapse am-topbar-collapse" id="doc-topbar-collapse">
                <div class="am-topbar-right">
                    <button class="am-btn am-btn-primary am-topbar-btn am-btn-sm" onclick="$('.chat_his').hide();">关闭</button>
                </div>
            </div>
        </header>
        <%--<h1>聊天记录</h1><a href="#" class="am-close">&times;</a>--%>
        <div class="am-scrollable-vertical" id="his-chat-view" style="height: 430px;resize:none;margin-left: 50px;">
            <ul class="am-comments-list am-comments-list-flip" id="his-chat">
            </ul>
        </div>
        <div class="am-cf" style="">
            <div class="am-fr">
                <ul class="am-pagination" id="pageinfo">

                </ul>
            </div>
        </div>
    </div>
    <div class="admin-content-body">
        <div class="am-tabs " data-am-tabs="{noSwipe: 1}" id="doc-tab-demo-1">
            <ul class="am-tabs-nav am-nav am-nav-tabs" id="ulsecretli">
                <li class="am-active"><a href="javascript: void(0)" onclick="hidesecretchats()" id="chatwin">聊天</a></li>
                <li><a href="javascript: void(0);" onclick="hidesecretchats()">公告</a></li>
                <li><a href="javascript: void(0);" onclick="subgo()">在线投注</a></li>
                <li><a href="javascript: void(0);" onclick="subgo()">联系客服</a></li>
                <li><a href="javascript: void(0);" onclick="hidesecretchats()">手机APP下载</a></li>
                <li><a href="javascript: void(0);" onclick="outmodal()">退出</a></li>
            </ul>

            <div class="am-tabs-bd">
                <div class="am-tab-panel am-active" >
                    <table>
                        <div class="" style="width: 80%;float:left;" id="chatquediv">
                            <!-- 聊天区 -->
                            <div class="am-scrollable-vertical" id="chat-view" style="height: 430px;resize:none;">
                                <ul class="am-comments-list am-comments-list-flip" id="chat">
                                </ul>
                            </div>

                            <div class="chat-toolbar">
                                <a href="javascript:void(0);" class="icon-font current" onclick="showchgdailog(this)">字体</a>
                                <a href="javascript:;" class="icon-emote" onclick="showchgdailog(this)">表情</a>
                                <a href="javascript:void(0);" class="icon-image" onclick="fileInport()">图片</a>
                                <div class="pull-right">
                                    <span class="pull-right btn-history" style="color:#0e93d7;" onclick="showHistoryHE('${roomid}')">聊天记录</span>
                                </div>
                               <%-- </section>--%>
                            </div>
                            <!-- 输入区 -->
                            <div class="am-form-group am-form">
                                    <div class="dmsgcls" id="message" name="message" contenteditable="true" ></div>
                            </div>
                            <div class="am-btn-group am-btn-group-xs" style="float:right;">
                                <button class="am-btn am-btn-default" type="button" onclick="closeNoticeSound()" id="closeOpenSound"><span  class="am-icon-bug"></span>关闭提示音</button>
                                <button class="am-btn am-btn-default" type="button" onclick="clearConsole()"><span class="am-icon-trash-o"></span> 清屏</button>
                                <button class="am-btn am-btn-default" type="button" onclick="sendMessage()"><span class="am-icon-commenting"></span> 发送</button>
                                    <div style="float: right;width: 25px;">
                                        <select id="enterselect" data-am-selected="{btnWidth: '10%', btnSize: 'sm', btnStyle: 'secondary',dropUp: 1}" style="float: right;" onchange="changeEnterEvent()">
                                            <option value="a">按Enter键发送消息</option>
                                            <option value="b" selected>按Ctrl+Enter键发送消息</option>
                                        </select>
                                    </div>
                            </div>
                        </div>
                        <!-- 列表区 -->
                        <div class="am-panel am-panel-default" id="listque" style="float:right;width: 20%; height:530px;overflow:hidden;overflow-x: hidden;">
                            <div class="am-panel-hd" style="text-align:center">
                                <h3 class="am-panel-title">群成员 [<span id="onlinenum">0</span>/<span id="allnum">0</span>]</h3>
                            </div>
                            <div class="am-input-group am-input-group-sm" style="display: inherit;">
                                <input id="searchinput" type="text" class="am-form-field" oninput="searchuser()" placeholder="请输入名称"
                                       style="background: url(${ctx}/static/source/img/search.png) no-repeat scroll right center transparent;">
                            </div>
                            <div style="overflow-y: auto;overflow-x: hidden;float: left;width: 100%;" id="listhieght">
                            <ul class="am-list am-list-static am-list-striped" style="line-height: 1.4;font-size: 1.4rem;/*height: 420px;*/" id="list">
                                <%List<User> roomList = (List)request.getAttribute("roomlists");
                                    String usertype = (String)request.getSession().getAttribute("usertype");
                                    if(roomList !=null && roomList.size()>0){
                                        for(User rmb : roomList){
                                %>
                                <li id="liit<%=rmb.getUserid()%>" class="graydown">
                                    <img width="40" height="40" style="border-radius:50%;" alt="" src="${ctx}/<%=rmb.getProfilehead()%>">
                                    <%if(Integer.valueOf(rmb.getUsertype())<=0){%>
                                    <a href="javascript:void(0);" class="adminclr" style="display:inline;padding-left: 0.3rem;" onclick="addTab('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
                                    <%}else{%>
                                    <a href="javascript:void(0);" style="display:inline;padding-left: 0.3rem;" onclick="addTab('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
                                    <%}%>

                                </li>
                                <%}}%>
                            </ul>
                            </div>
                            <ul class="am-list am-list-static am-list-striped" style="height:${chathei6}px;width: 215px;" id="listsearch">
                            </ul>
                        </div>
                    </table>
                </div>
                <div class="am-tab-panel">
                    <div class="am-panel am-panel-default admin-sidebar-panel">
                        <div class="am-panel-bd">
                            <p><span class="am-icon-bookmark"></span> 公告</p>
                            <p id="syscontent">${roomNotice}</p>
                        </div>
                    </div>
                </div>
                <div class="am-tab-panel" id="openwin">
                    <div class="am-panel am-panel-default admin-sidebar-panel">
                        <div class="am-panel-bd">
                            <c:set value="${fn:split(syslocate,',')}" var="str1" />
                            <c:forEach items="${str1}" var="s" varStatus="xh">
                                <h1><a href="#" onclick="window.open('${s}');">线路${xh.index}</a></h1>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="am-tab-panel" id="chatservice">
                    <div class="am-panel am-panel-default admin-sidebar-panel">
                        <div class="am-panel-bd">
                            <c:set value="${fn:split(onlineconsult,',')}" var="soc" />
                            <c:forEach items="${soc}" var="oc" varStatus="ocxh">
                                <c:choose>
                                    <c:when test="${0==ocxh.index}">
                                        <h1><a href="#" onclick="window.open('${oc}');">在线客服</a></h1>
                                    </c:when>
                                    <c:otherwise>
                                        <h1><a href="#" onclick="window.open('${oc}');">QQ客服</a></h1>
                                    </c:otherwise>
                                </c:choose>

                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="am-tab-panel">
                    <table>
                        <div style="width:50%;float: left;text-align: center;">
                            <p>IOS APP下载</p>
                            <img src="/upload/ios_qrcode.jpg" alt="" />
                        </div>
                        <div style="width:50%;float: right;text-align: center;">
                            <p>安卓 APP下载</p>
                            <img src="/upload/and_qrcode.jpg" alt="" />
                        </div>
                    </table>
                </div>
                <div class="am-tab-panel">
                    <div class="am-panel am-panel-default admin-sidebar-panel">
                        <div class="am-panel-bd">
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div></div>
<div class="am-modal am-modal-loading am-modal-no-btn" tabindex="-1" id="my-modal-loading">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">正在载入...</div>
        <div class="am-modal-bd">
            <span class="am-icon-spinner am-icon-spin"></span>
        </div>
    </div>
</div>
<div class="scrollline">
    <ul id="marquee" class="marquee">
        <li>公告</li>
    </ul>
</div>
<div class="am-modal am-modal-no-btn" tabindex="-1" id="doc-modal-picture" style="z-index: 9999;" >
    <div class="am-modal-dialog">
        <div class="am-modal-hd"><span id="chatTitle"></span><a href="javascript: void(0)" onclick="bigbig()"></a>
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd" >
            <div id="imgmodal" style="height: 560px;">
            </div>
        </div>
    </div>
</div>
</div>
<%@include file="include/emojicolor.jsp" %>
<style>
    #listsearch {
        position: absolute;
        z-index: 1002;
        width: 100%;
        background-color: #f2f1f1;
        border-top: 1px solid #d8dae2;
        border-right: 1px solid #d8dae2;
        border-bottom: 0;
        padding-top: 3px;
        display: none;
        top: 77px;
    }
    .am-tabs-nav .am-icon-close {
        position: absolute;
        top: -4px;
        right: 0px;
        color: #888;
        cursor: pointer;
        z-index: 100;
        /* margin-left: 30px; */
    }
</style>
<script>
    var temsecretid = "";
    $(function () {
        $("#my-modal-loading").modal('open');
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
        var reg = new RegExp( '<br>' , "g" );
        $("#syscontent").html(decodeURI("${roomNotice}"));
        $("#marquee").html("<li>" +decodeURI("${roomNotice}").replace(reg,"  ") + "</li>");
        $("#marquee").marquee({
            yScroll: "bottom",
            showSpeed: 850,        // 初始下拉速度         ,
            scrollSpeed: 12,       // 滚动速度         ,
            pauseSpeed: 1000,      // 滚动完到下一条的间隔时间         ,
            pauseOnHover: true,    // 鼠标滑向文字时是否停止滚动         ,
            loop: -1 ,             // 设置循环滚动次数 （-1为无限循环）         ,
            fxEasingShow: "swing" , // 缓冲效果         ,
            fxEasingScroll: "linear",  // 缓冲效果         ,
            cssShowing: "marquee-showing"  //定义class

        });

        /*$('#filesend').fileupload({
            done: function (e, data) {
                if(data.result){
                    var i = data.result.split("|");
                    if(i[0]=="success"){
                        sendMessage(i[1],temsecretid);
                    }else{
                        alert(i[2]);
                    }
                }
                temsecretid = "";
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
                                        sendMessage(i[1],temsecretid);
                                    }else{
                                        alert(i[2]);
                                    }
                                }
                                temsecretid = "";
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

        $("#message").keypress(function(e){
            var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
            if (e.ctrlKey && eCode == 13 && browserTp()=="FF"){
                sendMessage();
            }else if (e.ctrlKey && eCode == 10 && (browserTp()=="Chrome" || browserTp()=="IE")){
                sendMessage();
            }
        });

        IFrameResize();
        ReWritable();
        bindPaste("message")


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
                    var xcontent = $("#"+"contentdiv"+escapeJquery(temsecretid));
                    if(xcontent.length>0 && !xcontent.is(":hidden")){
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
                var xcontent = $("#"+"contentdiv"+escapeJquery(temsecretid));
                if(xcontent.length>0 && !xcontent.is(":hidden")){
                    tmsek = tmsek + "-" + escapeJquery(temsecretid);
                }
            }
            $(tmsek).css("font-family",$(this).children('option:selected').val());
        });
        $(".font-size").change(function(){
            var tmsek = "#message";
            if(temsecretid != null && temsecretid!=""){
                var xcontent = $("#"+"contentdiv"+escapeJquery(temsecretid));
                if(xcontent.length>0 && !xcontent.is(":hidden")){
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

        timeid = window.setInterval(function(){
            if(ws && ws.readyState == 1){
                $("#my-modal-loading").modal('close');
                timeid && window.clearInterval(timeid);
            }
        }, 1000);
        var navStr = navigator.userAgent.toLowerCase();
        if(navStr.indexOf("msie 10.0")!==-1||navStr.indexOf("rv:11.0")!==-1){ // 判断是IE10或者IE11
            grayscale($(".graydown"));
        }

        var chufa = "input";
        if(browserTp()=="IE"){
            chufa = "keyup";
        }
        $("#message").on(chufa, function() {
            $("#atuserlist").html("");
            var msg = $("#message").html();
            if(msg.indexOf("@")>=0){
                var ser = msg.split("@");
                var sear = ser[ser.length-1]
                var lis = $("#list li");var x = 0;
                for(var i=0;i<lis.length;i++){
                    if(sear==null || sear==""){
                        $("#atuserlist").append("<li style='border: 1px solid #dedede;'><a href='#' onclick='addToMsgDiv(\"@"+sear+"\",\""+lis[i].innerText+"\")'>"+lis[i].innerText+"</li>");
                        x++;
                    }else if(lis[i].innerText.indexOf(sear)>=0 ){
                        $("#atuserlist").append("<li style='border: 1px solid #dedede;'><a href='#' onclick='addToMsgDiv(\"@"+sear+"\",\""+lis[i].innerText+"\")'>"+lis[i].innerText+"</li>");
                        x++;
                    }
                }
                if(x>0){
                    $("#atuserdiv").show();
                }else{
                    $("#atuserdiv").hide();
                }
            }else{
                $("#atuserdiv").hide();
            }
        });
        $('#doc-modal-picture').on('close.modal.amui', function(){
            $("#imgmodal").html("");
        });

    });
    var atUserStr;

    var wsServer = null;
    var ws = null;
    //var dksf = "192.168.31.127:8080";
    //wsServer = "ws://"+dksf + "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";
    wsServer = "ws://"+document.domain + "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";
    //wsServer = "ws://"+"${syshost}" + "${pageContext.request.contextPath}" + "/chatServer" + "/" + "${roomid}";

    var timeidws, reconnect=false;
    webSocket();
    function webSocket(){
        //连接WebSocket
        ws = new WebSocket(wsServer);
        ws.onopen = function(evt) {
            layer.msg("已经建立连接", { offset: 0});
            timeidws && window.clearInterval(timeidws);
            if(reconnect){
                layer.msg("重新建立连接", { offset: 0});
            }
        };
        ws.onmessage = function(evt){
            analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
        };
        ws.onerror = function (evt) {
            layer.msg("产生异常", { offset: 0});
        };
        //当断开时进行判断
        ws.onclose=function(evt){
            window.clearInterval(timeidws);
            //判断是否为苹果ios系统
            reconnect=true;
            timeidws = window.setInterval(webSocket, 3000);
        }
    }
    var fullscreenflag = 0;
    function ajustfullscreen(flag) {
        if(flag == 1){
            $("#chatquediv").width("86%");
            $("#listque").width("12%");
            $(".chatoneofuser").css("width",(document.body.clientWidth-15) +"px");
            fullscreenflag = 1;
        }else{
            fullscreenflag =0;
            $("#chatquediv").width("80%");
            $("#listque").width("18%");
            $(".chatoneofuser").css("width","1085px");
        }
    }

    function divoninput() {
        $("#atuserlist").html("");
        var msg = $("#message").html();
        if(msg.indexOf("@")>=0){
            var ser = msg.split("@");
            var sear = ser[ser.length-1]

            var lis = $("#list li");var x = 0;
            for(var i=0;i<lis.length;i++){
                if(sear==null || sear==""){
                    //$("#atuserlist").append("<li>"+lis[i].children("a").innerHTML+"</li>");
                    $("#atuserlist").append("<li style='border: 1px solid #dedede;'><a href='#' onclick='addToMsgDiv(\"@"+sear+"\",\""+lis[i].innerText+"\")'>"+lis[i].innerText+"</li>");
                    x++;
                }else if(lis[i].innerText.indexOf(sear)>=0 ){
                    //$("#atuserlist").append("<li>"+lis[i].innerHTML+"</li>");
                    $("#atuserlist").append("<li style='border: 1px solid #dedede;'><a href='#' onclick='addToMsgDiv(\"@"+sear+"\",\""+lis[i].innerText+"\")'>"+lis[i].innerText+"</li>");
                    x++;
                }
            }
            if(x>0){
                $("#atuserdiv").show();
                //var p = kingwolfofsky.getInputPositon(document.getElementById("message"));
                //$("#atuserdiv").css("top",p.bottom+'px')
                //$("#atuserdiv").css("left",p.left +'px')
            }else{
                $("#atuserdiv").hide();
            }
        }else{
            $("#atuserdiv").hide();
        }

    }

    function addToMsgDiv(beTh,willTh,flag) {
        willTh = willTh.replace(" ","");//多出空格去掉
        willTh = willTh.split("(")[0];
        var msg = $("#message").html();
        if(beTh==null){
            $("#message").append("<a href='#'>@"+willTh+"&nbsp;&nbsp;</a><span>&nbsp;</span>");
        }else{
            $("#message").html(msg.substring(0,msg.lastIndexOf("@")) + msg.substring(msg.lastIndexOf("@"),msg.length).replace(beTh,"<a>@"+willTh+"&nbsp;&nbsp;</a><span>&nbsp;</span>"))
        }
        $("#atuserdiv").hide();
        if(flag !=null){
            $("#"+flag).remove();
        }
    }

    function subgo(){
        $(".chatoneofuser").hide();
        $(".diybtn").css("background-color","#cacaca");
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
        }else{
            isSecretChat = true;
        }


        if(!isSecretChat && isls ==null){
            layer.msg("您没有私聊权限", {
                offset: 0,
                shift: 10
            });
            return;
        }

        $("#searchidx").hide();
        var contnetname = secretid + "content";
        if($("#"+escapeJquery(contnetname)).length>0){
            layer.msg("已打开该用户私聊标签，双击打开", {
                offset: 0,
                shift: 10
            });
            return;
        }
        var secrethtml = getHtml(secretid,'${chathei3}');
        $(document.body).append(secrethtml);
        $(".chatoneofuser").css("height",'${chathei3}'+"px");
        if(fullscreenflag==1){
            $(".chatoneofuser").css("width",(document.body.clientWidth-15) +"px");
        }
        //绑定键盘事件
        $("#message-"+escapeJquery(secretid)).keypress(function(e){
            var selectval = $("#enterselect").val();
            var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            if (selectval=="b" ){
                if (e.ctrlKey && eCode == 13 && (userAgent.indexOf("Firefox") > -1)){
                    sendMessage(null,secretid);
                }else if (e.ctrlKey && eCode == 10 && ((userAgent.indexOf("Chrome") > -1) || (!!window.ActiveXObject || "ActiveXObject" in window))){
                    sendMessage(null,secretid);
                }
            }else if(selectval=="a" ){
                if(eCode == 13 && !e.ctrlKey){
                    e.preventDefault();
                    sendMessage(null,secretid);
                }
            }
        });
        bindPaste("message-"+escapeJquery(secretid));
    }

    var chatviewhi,listquehi;
    function IFrameResize(){
        //alert('${chathei1}');alert('${chathei2}');alert('${chathei3}');
        chatviewhi = '${chathei2}';
        listquehi = '${chathei3}';
        $("#chat-view").css("height",chatviewhi+"px");
        $("#listque").css("height",listquehi+"px");
        $("#listhieght").css("height",(listquehi-66)+"px");
        var obj = parent.document.getElementById("chatWin"); //取得父页面IFrame对象
        if(obj && obj.height)
            obj.height = $('#doc-tab-demo-1').height(); //调整父页面中IFrame的高度为此页面的高度
    }



    /**
     * 发送信息给后台
     * obj 发送图片时候传入
     * user为私聊时候传入
     */
    function sendMessage(obj,user){
        if(ws == null){
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
            return;
        }
        if(ws.readyState != 1){
            layer.msg("连接未建立完成,请等待!", { offset: 0, shift: 6 });
            return;
        }
        var messagemS = "#message";
        if(user !=null && user !=""){
            messagemS = messagemS + "-" + escapeJquery(user);
        }
        //判断不是由文件按钮触发,是否有图片，然后解析图片
        if((obj==null||obj=="") && $(messagemS + " img").length > 0){
            $.each($(messagemS + " img"), function(i, v){
                var $src = v.src;
                uploadAndSend($src,user);
                $(messagemS + " img").eq(i).remove();
            });
            if($(messagemS).html() == null || $(messagemS).html() == ""){
                return;
            }
        }
        //var message = $(messagemS).val().replace("\\n","</br>");
        var message = $(messagemS).html();


        if(obj !=null && obj!=""){
            message = "/" + obj;
        }
        var to = $("#sendto").text() == "全体成员"? "": $("#sendto").text();
        if(user !=null && user !=""){
            to = user;
        }
        if(message == null || message == ""){
            layer.msg("请输入您要发送的内容!", { offset: 0, shift: 6 });
            return;
        }
        if(obj ==null || obj==""){
            //$(messagemS).val("");
            $(messagemS).html("");
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
    }

    function outChat(user) {
        if('${userid}' == user){
            outmodal();
        }
    }

    function uploadAndSend(src,touser){
        //base64 转 blob
        var $Blob= getBlobBydataURI(src,'image/jpeg');
        var formData = new FormData();
        formData.append("files", $Blob ,"file.jpeg");
        //组建XMLHttpRequest 上传文件
        var xhr = new XMLHttpRequest();
        //上传连接地址
        xhr.open("POST", "/uploadajax");
        xhr.onreadystatechange=function()
        {
            if (xhr.readyState==4)
            {
                if(xhr.status==200){
                    var responseText = xhr.responseText;
                    var text = responseText.split("|");
                    if (text!=null && text.length>1){
                        if(text[0] == "success"){
                            if(touser ==null ){
                                touser = "";
                            }
                            ws.send(JSON.stringify({
                                message : {
                                    content : "/"+text[1],
                                    from : '${userid}',
                                    to : touser,      //接收人,如果没有则置空,如果有多个接收人则用,分隔
                                    time : getDateFull()
                                },
                                type : "message"
                            }));
                        }
                        else
                            layer.msg(text[1], { offset: 0});
                    }else{
                        layer.msg("发送错误!", { offset: 0});
                    }
                }
            }
        }
        xhr.send(formData);
    }



    /**
     * 展示提示信息
     */
    function showNotice(notice,offuser){
        var chatS = "#chat";
        var chatViewS = "#chat-view";
        if(offuser != null && offuser != undefined){
            if($(chatS + "-"+escapeJquery(offuser)).length>0){
                chatS = chatS + "-"+escapeJquery(offuser);
                chatViewS = chatViewS + "-"+escapeJquery(offuser);
            }
        }
        $(chatS).append("<div><p class=\"am-text-success\" style=\"text-align:center\"><span class=\"am-icon-bell\"></span> "+notice+"</p></div>");
        var chat = $(chatViewS);
        chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
    }

    /**
     * 展示会话信息
     */
    function showChat(message){
        var chatViewmS = "#chat-view";
        var chatmS = "#chat";
        var messagemS = "#message";
        if(message.to != null && message.to != ""){
            if('${userid}' == message.to){
                chatViewmS = chatViewmS + "-" + escapeJquery(message.from);
                chatmS =  chatmS + "-" + escapeJquery(message.from);
                messagemS =  messagemS + "-" + escapeJquery(message.from);
                var isExistSecretWin = $(chatViewmS);
                if(!(isExistSecretWin.length > 0)){
                    addTab(message.from,message.from);
                }

                $("#btn-" + escapeJquery(message.from)).css("background-color","yellow");
                //$("#lichat"+escapeJquery(message.from)+"content").css("background","red");
            }else{
                chatViewmS = chatViewmS + "-" + escapeJquery(message.to);
                chatmS =  chatmS + "-" + escapeJquery(message.to);
                messagemS =  messagemS + "-" + escapeJquery(message.to);
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
        if(contentsh.indexOf("@${userid}&nbsp;&nbsp;")>=0){
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

            contentsh = "<img id=\""+imgId+"\" src=\""+contentsh + "\" alt=\"\" onclick=\"showimg('" + contentsh + "');\" style=\"/*objec-fit: cover;*/background-size: 'cover';width: 100%;\">";
            lenCon = "450px"
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
        var html =
            "<li class=\"am-comment "+isSef+" am-comment-primary\">" +
                "<a href=\"#link-to-user-home\" onclick='addToMsgDiv(null,\""+message.from+"\")'>" +
                    "<img width=\"48\" height=\"48\" class=\"am-comment-avatar\" style=\"width: 48px;height: 48px;\" alt=\"\" src=\""+fromimg+"\">" +
                "</a>" +
                "<header class=\"am-comment-hd\" style=\"border-bottom: 0px solid #fff;background:none;\">" +
                    "<div class=\"am-comment-meta\" style=\"background-color: #fff;"+headlr+":20px;text-align:"+headtexthr+";\">   " +
                        "<a class=\"am-comment-author\"  href=\"#link-to-user\">"+message.from+"</a>&nbsp;&nbsp;<time>"+hms+"</time>" +
                    "</div>" +
                "</header>" +
                "<div id=\""+divId+"\" class=\"am-comment-main\" style=\"border-radius: 15px;max-width:688px;\">" +
                    "<div class=\"am-comment-bd\" style=\"line-height: 1;word-wrap:break-word;word-break:break-all;\">" +
                        "<span id=\""+spanId+"\"> "+contentsh+"</span>" +
                    "</div>" +
                "</div>" +
            "</li>";
        $(chatmS).append(html);
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
            var imlr = '${userid}' == message.from ? "right" : "left";
            $("#"+imgId).css("float",imlr);
            $("#"+divId).css("max-width","250px");
            $("#"+divId).css("float",headtexthr);
            $("#"+divId).css(headlr,"20px");
        }else{
            //var spanwidth = Number($("#"+spanId).css("width").replace("px",""));
            $("#"+divId).css("float",headtexthr);
            $("#"+divId).css(headlr,"20px");
        }
        if(isDown){
            chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
        }
        if('${userid}' != message.from){
            if($('#chatAudio').length>0 && noticeSound){
                $('#chatAudio')[0].play();
            }
        }
    }
    var noticeSound = true;


    /**
     * 展示在线列表
     */
    function showOnline(list,onuser) {
        var navStr = navigator.userAgent.toLowerCase();
        if('${userid}' == onuser){//如果上线的是自己当前，将在线列表的用户全部上线。
            if(!$("#liit"+escapeJquery(onuser)).length>0){
                var li = "<li id=\"liit"+onuser+"\" class=\"graydown\"><img width=\"40\" height=\"40\" style=\"border-radius:50%;\"  alt=\"\" src=\"${ctx}/upload/resizeApi.png\"><a href=\"javascript:void(0);\" style=\"display:inline;padding-left: 0.3rem;\"";
                li= li + " onclick=\"addTab('" +onuser+ "')\">" +onuser+"</a></li>";
                $("#list").append(li);
            }
            $.each(list, function(index, item){
                if(navStr.indexOf("msie 10.0")!==-1||navStr.indexOf("rv:11.0")!==-1){ // 判断是IE10或者IE11
                    grayscale.reset($("#liit"+item));
                }
                $("#liit"+escapeJquery(item)).removeClass("graydown");
                $("#liit"+escapeJquery(item)).insertBefore("#list li:eq(0)");
            });
        }else{
            //不是当前用户，将刚上线的用户置为上线。
            if($("#liit"+escapeJquery(onuser)).length>0){
                if(navStr.indexOf("msie 10.0")!==-1||navStr.indexOf("rv:11.0")!==-1){ // 判断是IE10或者IE11
                    grayscale.reset($("#liit"+escapeJquery(onuser)));
                }
                $("#liit"+escapeJquery(onuser)).removeClass("graydown");
                $("#liit"+escapeJquery(onuser)).insertBefore("#list li:eq(0)");
            }else{//对于新注册的用户可能没有在之前的上线列表中，有时间差，先有人已登录，后有人注册了。添加一条并置为上线
                var li = "<li id=\"liit"+onuser+"\" class=\"graydown\"><img width=\"40\" height=\"40\" style=\"border-radius:50%;\"  alt=\"\" src=\"${ctx}/upload/resizeApi.png\"><a href=\"javascript:void(0);\" style=\"display:inline;padding-left: 0.3rem;\"";
                li= li + " onclick=\"addTab('" +onuser+ "')\">" +onuser+"</a></li>";
                $("#list").append(li);
                if(navStr.indexOf("msie 10.0")!==-1||navStr.indexOf("rv:11.0")!==-1){ // 判断是IE10或者IE11
                    grayscale.reset($("#liit"+escapeJquery(onuser)));
                }
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
    function showimg(obj){
        var imgsd = "<img id=\"modalpicture\" src=\"\" style=\"background-size: cover;margin-top: 10px;\"></div>";
        $("#imgmodal").append(imgsd);
        $("#modalpicture").attr("src",obj);
        setTimeout(function(){
            var $modalpic = $('#doc-modal-picture');
            $modalpic.modal({ width: 800, height: 600, closeViaDimmer: true });
            var sHei = Number($("#modalpicture").css("height").replace("px",""));
            var sWid = Number($("#modalpicture").css("width").replace("px",""));

            if(sWid < 800 && sHei < 600){
                $("#modalpicture").css("height","auto");
                $("#modalpicture").css("width","auto");
            }else if(sWid > 800 && sHei < 600){
                $("#modalpicture").css("height","auto");
                $("#modalpicture").css("width","100%");
            }else if(sWid < 800 && sHei > 600){
                $("#modalpicture").css("width","auto");
                $("#modalpicture").css("height","100%");
            }else if(sWid > 800 && sHei > 600){
                if(sWid/800>sHei/600){
                    $("#modalpicture").css("width","100%");
                    $("#modalpicture").css("height","auto");
                }else{
                    $("#modalpicture").css("height","100%");
                    $("#modalpicture").css("width","auto");
                }
            }
        },500);


    }
</script>
</body>
</html>
