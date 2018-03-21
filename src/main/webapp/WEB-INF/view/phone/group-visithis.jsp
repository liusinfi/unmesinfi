<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String path = request.getContextPath();%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" >
    <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
    <script src="<%=path%>/static/plugins/amaze/js/amazeui.min.js"></script>
    <script src="<%=path%>/static/plugins/layer/layer.js"></script>
    <script src="<%=path%>/static/source/js/prefixfree.min.js"></script>
    <link rel="stylesheet" href="<%=path%>/static/plugins/amaze/css/amazeui.min.css">
    <link rel="stylesheet" href="<%=path%>/static/source/css/normalize.min.css">
    <link href="<%=path%>/static/source/css/login1.css" rel='stylesheet' type='text/css' />
    <script src="<%=path%>/static/source/dojs/dateutil.js"></script>
</head>
<body>
<div id="groupVisitHis">
    <header data-am-widget="header"
            class="am-header am-header-default am-no-layout">
        <div class="am-topbar-brand" style="padding: 15px 10px 15px 10px;">
            <span class="am-icon-chevron-left" onclick="window.location='/unchk/first?show=info';"></span>
        </div>
        <h1 class="am-header-title">我去过的群组</h1>
    </header>

    <div data-am-widget="list_news" class="am-list-news am-list-news-default am-no-layout">
        <div class="am-list-news-bd">
            <ul class="am-list">
                <c:forEach items= "${visitgroups}" var="vg">
                <li class="am-g am-list-item-desced am-list-item-thumbed am-list-item-thumb-left" onclick="accessIn('${vg.id}')">
                    <div class="am-u-sm-2 am-list-thumb">
                        <a href="#" class="">
                            <img src="/static/source/img/QQ_CHAT.png" alt="QQ" width="50" height="50">
                        </a>
                    </div>
                    <div class="am-u-sm-10 am-list-main">
                        <h3 class="am-list-item-hd">
                            <a href="#" class="">${vg.roomtitle}</a>
                        </h3>
                        <div class="am-list-item-text dateformat">${vg.createdate}</div>
                    </div>
                </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>
<script>
    var screenHeightMy = document.body.clientHeight;
    /*$.each($(".dateformat"), function(index, item){
        $(item).text(datetimeFormat_1($(item).text()));\
    });*/
    function accessIn(roomid) {
        $.ajax({
            type: "POST",
            async : false,
            url: "/unchk/canVisitRoom",
            data: {'roomid' : roomid,'userid' : "${userid}"},
            success: function (msg) {
                if(msg == "0"){
                    window.location = "/unchk/jumpchat?roomid="+roomid+"&scrnhei="+screenHeightMy;
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
