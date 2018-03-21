<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>KChat系统设置</title>
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <jsp:include page="include/commonfile.jsp"/>
</head>
<body>
<jsp:include page="include/header.jsp"/>
<div class="am-cf admin-main">
    <jsp:include page="include/sidebar.jsp"/>

    <!-- content start -->
    <div class="admin-content">

        <div class="am-cf am-padding">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">系统设置</strong> / <small>form</small></div>
        </div>
        <c:set value="${sysconfig}" var="sysconfig"/>
        <form class="am-form am-form-horizontal" id="sys-form" action="${ctx}/sysupdate" method="post" data-am-validator>
            <div class="am-form-group">
                <label for="syslocate" class="am-u-sm-2 am-form-label">跳转地址</label>
                <div class="am-u-sm-10">
                    <input type="text" id="syslocate" name="syslocate" value="${sysconfig.syslocate}">
                </div>
            </div>
            <div class="am-form-group">
                <label for="syshost" class="am-u-sm-2 am-form-label">主机地址/域名</label>
                <div class="am-u-sm-10">
                    <input type="text" id="syshost" name="syshost" value="${sysconfig.syshost}">
                </div>
            </div>
            <div class="am-form-group">
                <label for="syshost" class="am-u-sm-2 am-form-label">在线客服/QQ客服</label>
                <div class="am-u-sm-10">
                    <input type="text" id="onlineconsult" name="onlineconsult" value="${sysconfig.onlineconsult}">
                </div>
            </div>
            <div class="am-form-group">
                <label for="syscontent" class="am-u-sm-2 am-form-label">公告</label>
                <div class="am-u-sm-10">
                    <textarea  id="syscontent" name="syscontent" rows="5"></textarea>
                </div>
            </div>
            <div class="am-form-group">
                <div class="am-u-sm-10 am-u-sm-offset-2">
                    <button type="submit" class="am-btn am-round am-btn-success"><span class="am-icon-send"></span> 提交</button>
                </div>
            </div>
        </form>


    </div>
    <!-- content end -->
</div>
<%--<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>--%>
<style>
    .am-u-sm-2 {
        padding-left: 0rem;
        padding-right: 0rem;
    }
</style>
<script>
    var reg = new RegExp( '</br>' , "g" )
    $("textarea").val('${sysconfig.syscontent}'.replace(reg,"\r\n"));
    if (document.body.clientWidth<1024){
        $("body").css("min-height",$(window).height()-100);
    }
</script>
</body>
</html>
