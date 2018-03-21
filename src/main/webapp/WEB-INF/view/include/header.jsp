<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<% String husertype = (String)request.getSession().getAttribute("usertype") ;%>
<header class="am-topbar am-topbar-inverse admin-header">
    <div class="am-topbar-brand">
        <i class="am-icon-weixin"></i> <strong>KChat</strong> <small>K聊天室</small>
    </div>
    <button class="am-topbar-btn am-topbar-toggle am-btn am-btn-sm am-btn-success am-show-sm-only" data-am-collapse="{target: '#topbar-collapse'}"><span class="am-sr-only">导航切换</span> <span class="am-icon-bars"></span></button>
    <div class="am-collapse am-topbar-collapse" id="topbar-collapse">
        <ul class="am-nav am-nav-pills am-topbar-nav am-topbar-right admin-header-list">
            <li class="am-dropdown" data-am-dropdown>
                <a class="am-dropdown-toggle" data-am-dropdown-toggle href="javascript:;">
                    ${userid} <span class="am-icon-caret-down"></span>
                </a>
                <ul class="am-dropdown-content">
                    <li><a href="${ctx}/QAoper"><span class="am-icon-commenting"></span> 聊天</a></li>
                    <li><a href="${ctx}/config"><span class="am-icon-cog"></span> 个人设置</a></li>
                    <%if(StringUtils.isNotEmpty(husertype) && Integer.valueOf(husertype)<=0){%>
                    <li><a href="${ctx}/sysupdate"><span class="am-icon-cog"></span> 系统设置</a></li>
                    <li><a href="${ctx}/roommember"><span class="am-icon-inbox"></span> 聊天室管理<span class="am-badge am-badge-secondary am-margin-right am-fr"></span></a></li>
                    <li><a href="${ctx}/userlist"><span class="am-icon-inbox"></span> 用户管理<span class="am-badge am-badge-secondary am-margin-right am-fr"></span></a></li>
                    <%}%>
                    <li id="phoneonly"><a href="#" data-am-offcanvas="{target: '#admin-offcanvas'}"><span class="am-icon-cog"></span> 公告</a></li>
                    <li><a href="${ctx}/user/logout?m=QA"><span class="am-icon-power-off"></span>退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</header>
<script>
    if (document.body.clientWidth>=1024){
        $("#phoneonly").hide();
    }
</script>