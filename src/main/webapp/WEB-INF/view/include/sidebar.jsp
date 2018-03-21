<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<% String susertype = (String)request.getSession().getAttribute("usertype") ;%>
<!-- sidebar start -->
<div class="admin-sidebar am-offcanvas" id="admin-offcanvas">
    <div class="am-offcanvas-bar admin-offcanvas-bar">
        <div id="sibaiphoe">
        <ul class="am-list admin-sidebar-list">
            <li><a href="${ctx}/QAoper"><span class="am-icon-commenting"></span> 聊天</a></li>
            <%--<li><a href="${ctx}/${userid}" class="am-cf"><span class="am-icon-book"></span> 个人信息<span class="am-icon-star am-fr am-margin-right admin-icon-yellow"></span></a></li>--%>
            <li class="admin-parent">
                <a class="am-cf" data-am-collapse="{target: '#collapse-nav'}"><span class="am-icon-cogs"></span> 设置 <span class="am-icon-angle-right am-fr am-margin-right"></span></a>
                <ul class="am-list am-collapse admin-sidebar-sub am-in" id="collapse-nav">
                    <li><a href="${ctx}/config"><span class="am-icon-group"></span> 个人设置</a></li>
                    <%if(
            StringUtils.isNotEmpty(susertype) &&Integer.valueOf(susertype)<=0){%>
                    <li><a href="${ctx}/sysupdate"><span class="am-icon-cog"></span> 系统设置</a></li>
                    <%}%>
                </ul>
            </li>
            <%if(StringUtils.isNotEmpty(susertype) &&Integer.valueOf(susertype)<=0){%>
            <li><a href="${ctx}/roommember"><span class="am-icon-inbox"></span> 聊天室管理<span class="am-badge am-badge-secondary am-margin-right am-fr"></span></a></li>
            <li><a href="${ctx}/userlist"><span class="am-icon-inbox"></span> 用户管理<span class="am-badge am-badge-secondary am-margin-right am-fr"></span></a></li>
            <%}%>
            <li><a href="${ctx}/user/logout?m=QA"><span class="am-icon-sign-out"></span>退出</a></li>
        </ul>
        </div>
        <div class="am-panel am-panel-default admin-sidebar-panel">
            <div class="am-panel-bd">
                <p><span class="am-icon-tag"></span> 公告</p>
                <p id="syscontent">${syscontent}</p>
            </div>
        </div>
    </div>
</div>
<script>
    if (document.body.clientWidth<1024){
        $("#sibaiphoe").hide();
    }
    setInterval(function(){
        $.ajax({
            type: "GET",
            async : true,
            url: '${ctx}/scontent',
            success: function (msg) {
                if(msg !=null && msg !=""){
                    $("#syscontent").html(msg);
                }
            },
            error: function (error) {
            }
        });
    },5000);
</script>
<!-- sidebar end -->