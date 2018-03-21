<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!doctype html>
<html class="no-js fixed-layout">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <jsp:include page="../include/commonfile.jsp"/>
</head>
<body>
<div id="chatINF">
<header data-am-widget="header"
        class="am-header am-header-default am-no-layout">
    <div class="am-topbar-brand">
        <i class="am-icon-weixin"></i>
    </div>
    <h1 class="am-header-title">聊天群</h1>
    <div class="am-header-right am-header-nav">
        <a href="javascript:void(0);" onclick="checkLogin()" ><span id="loginSP" class="am-header-nav-title">登录
		</span></a>
    </div>
</header>
<div id="demo-view" data-backend-compiled="" >
    <div data-am-widget="list_news" class="am-list-news am-list-news-default am-no-layout">
        <div class="am-list-news-hd am-cf">
            <a href="###" class=""><h2>交流群</h2></a>
        </div>
        <div class="am-list-news-bd" style="overflow-y: auto;overflow-x: hidden;width: 100%;">
            <ul class="am-list">
                <c:forEach items= "${ChatRooms}" var="d">
                    <li class="am-g am-list-item-desced am-list-item-thumbed am-list-item-thumb-left" onclick="accessIn('${d.id}')">
                        <div class="am-u-sm-2 am-list-thumb">
                            <a href="#" class="">
                                <img src="/static/source/img/QQ_CHAT.png" alt="QQ" width="50" height="50">
                            </a>
                        </div>
                        <div class="am-u-sm-8 am-list-main">
                            <h3 class="am-list-item-hd">
                                <a href="#" class=""><c:out value="${d.roomtitle}" ></c:out> </a>
                            </h3>
                            <div class="am-list-item-text"><c:out value="${d.roomnotice}" ></c:out></div>
                        </div>
                        <div class="am-u-sm-2 am-list-item-thumb-right">
                            <div class="am-list-item-text"><span style="color: red;" id="count-${d.id}">0</span>人</div>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>

<div data-am-widget="navbar" style="border-top: 1px solid #dedede;"
     class="am-navbar am-cf am-navbar-default am-no-layout">
    <ul class="am-navbar-nav am-cf am-avg-sm-4" style="background-color: #ffffff;">
        <li><a id="homeid" href="javascript:void(0);" onclick="showChat()" class="am-icon-home am-icon-md" style="color: #757575;"><span class="am-navbar-label">消息</span></a></li>
        <li><a id="myid" href="javascript:void(0);" onclick="showInfo()" class="am-icon-qq am-icon-sm" style="color: #757575;line-height: 30px;"><span class="am-navbar-label">我的</span></a></li>
    </ul>
</div>
</div>

<%@include file="myinfo.jsp" %>

<script>
    $(function () {
        if(("${userid}" !=null && "${userid}" !="")){
            $("#loginSP").html("已登录");
            userChangeShow();
        }
        if("${errorinfo}" !=null && "${errorinfo}" !=""){
            layer.msg("${errorinfo}", {
                offset: 0,
                shift: 6
            });
        }
        if("${show}" == "info"){
            showInfo();
        }
        var countmap = '${countMap}';
        var reg = new RegExp( '=' , "g" )
        var obj = eval('(' + countmap.replace(reg,":") + ')');
        for(var key in obj){
            $("#count-"+key).html(obj[key]);
        }
        $("#homeid").css("color","#0e90d2");
        $(".am-list-news-bd").css("height",(screenHeightMy-150)+"px");
    });
    var screenHeightMy = document.body.clientHeight;
    function checkLogin() {
        if(("${userid}" !=null && "${userid}" !="")){
            return false;
        }
        window.location = "/user/login";
        return true;
    }
    function showChat() {
        $("#userINF").hide();
        $("#homeid").css("color","#0e90d2");
        $("#myid").css("color","#757575");
    }
    function showInfo() {
        $("#userINF").show();
        $("#myid").css("color","#0e90d2");
        $("#homeid").css("color","#757575");
    }
    function accessIn(roomid) {
        $.ajax({
            type: "POST",
            async : false,
            url: "/unchk/canVisitRoom",
            data: {'roomid' : roomid,'userid' : "${userid}"},
            success: function (msg) {
                if(msg == "0"){
                    window.location = "/unchk/jumpchat?roomid="+roomid+"&scrnhei="+screenHeightMy+"&r="+Math.random();
                }else if(msg == "1"){
                    window.location = "/user/login";
                }else if(msg == "2"){
                    layer.msg("您已被踢出聊天室!", {
                        offset: 0,
                        shift: 6
                    });
                    return;
                }else if(msg == "3"){
                    window.location = "/unchk/jumptopass?roomid="+roomid;
                }else{
                    layer.msg(msg, {
                        offset: 0,
                        shift: 6
                    });
                }
            },
            error: function (error) {
                layer.msg(error, {
                    offset: 0,
                    shift: 6
                });
            }
        });
    }
</script>

</body>
</html>
