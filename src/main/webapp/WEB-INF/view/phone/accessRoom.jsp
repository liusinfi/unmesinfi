<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/1/17
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
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
</head>
<body>
<header data-am-widget="header"
        class="am-header am-header-default am-no-layout">
    <div class="am-topbar-brand" style="padding: 15px 10px 15px 10px;">
        <span class="am-icon-chevron-left" onclick="window.location='/unchk/first';"></span>
    </div>
    <h1 class="am-header-title">进入加密房间</h1>
</header>
<div class="login" id="logindiv" align="center">
    <img src="/static/source/img/QQ_LOGIN.png" alt="QQ">
    <h1>加密房间</h1>
    <form id="login-form" action="/unchk/accessWithPass" method="post" onsubmit="return checkAccessForm()">
        <input type="hidden" name="roomid" id="roomid">
        <input type="hidden" name="screenHeight" id="screenHeight">
        <input type="password" name="password" id="password" placeholder="请输入密码" required="required" />
        <button type="submit" id="ACCESS" class="btn btn-primary btn-block btn-large">立即进入</button>
    </form>
</div>
<script>
    var screenHeightMy = document.body.clientHeight;
    $(function () {
        $("#roomid").val("${roomid}");
        $("#screenHeight").val(screenHeightMy);
        if("${errorinfo}" !=null && "${errorinfo}" !=""){
            layer.msg("${errorinfo}", { offset: 0, shift: 6 });
        }
    });

    function checkAccessForm() {
        var password = $('#password').val();
        if(isNull(password)){
            layer.msg('请输入密码', {
                offset: 0,
            });
            return false;
        }
        return true;
    }
</script>
</body>
</html>
