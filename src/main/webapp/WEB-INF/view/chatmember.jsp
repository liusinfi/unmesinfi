<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ page import="com.github.pagehelper.Page" %>
<%@ page import="com.jy.webchat.pojo.RoomMember" %>
<%@ page import="com.github.pagehelper.PageInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html class="no-js fixed-layout">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>WebChat | 聊天</title>
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
    <div class="admin-content-body">
        <div class="am-cf am-padding am-padding-bottom-0">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">聊天室成员列表</strong> / <small>Table</small></div>
        </div>
        <hr>
        <div class="am-u-sm-12 am-u-md-3">
            <div class="am-form-group">
                <select  id="searchroomid" name="searchroomid" data-am-selected="{btnSize: 'sm'}">
                    <option value="-1">所有聊天室</option>
                    <%List<ChatRoomsWithBLOBs> chatrooms = (List<ChatRoomsWithBLOBs>)request.getAttribute("ChatRooms");
                    if(chatrooms !=null && chatrooms.size()>0){
                        for(int i=0;i<chatrooms.size();i++){
                            ChatRoomsWithBLOBs chat = chatrooms.get(i);
                    %>
                    <option value="<%=chat.getId()%>"><%=chat.getRoomtitle()%></option>
                    <%}}%>
                </select>
            </div>
        </div>
        <div class="am-u-sm-12 am-u-md-3">
            <div class="am-input-group am-input-group-sm">
                <input type="text" id="searchuser" name="searchuser" class="am-form-field" placeholder="输入用户名">
                <span class="am-input-group-btn">
            <button id="searchbutton" class="am-btn am-btn-default" type="button">搜索</button>
          </span>
            </div>
        </div>
        <div class="am-g">
            <div class="am-u-sm-12">
                <table class="am-table am-table-striped am-table-hover table-main">
                    <thead>
                    <tr>
                        <th>聊天室名称</th><th>用户名</th><th>状态</th><th>管理</th>
                    </tr>
                    </thead>
                    <%PageInfo pageinfo = (PageInfo)request.getAttribute("page");
                        List<RoomMember> list = pageinfo.getList();
                    if(pageinfo.getTotal()>0){
                        for(int i=0;i<list.size();i++) {
                            RoomMember roomMember = list.get(i);

                    %>
                    <tbody>
                    <tr><td><%=roomMember.getRoomTitle()%></td><td><%=roomMember.getUserid()%></td>
                        <td>
                            <%if(roomMember.getBlacktype()==0){%>
                                正常
                            <%}else if(roomMember.getBlacktype()==1){%>
                                踢出
                            <%}else if(roomMember.getBlacktype()==2){%>
                                禁言
                            <%}%>
                        </td>
                        <td>
                            <div class="am-dropdown" data-am-dropdown>
                                <button class="am-btn am-btn-default am-btn-xs am-dropdown-toggle" data-am-dropdown-toggle><span class="am-icon-cog"></span> <span class="am-icon-caret-down"></span></button>
                                <ul class="am-dropdown-content">
                                    <li><a href="javascript:void(0);" onclick="operID('1','<%=roomMember.getUserid()%>','<%=roomMember.getRoomid()%>')">1. 踢出</a></li>
                                    <li><a href="javascript:void(0);" onclick="operID('2','<%=roomMember.getUserid()%>','<%=roomMember.getRoomid()%>')">2. 禁言</a></li>
                                    <li><a href="javascript:void(0);" onclick="operID('0','<%=roomMember.getUserid()%>','<%=roomMember.getRoomid()%>')">3. 恢复正常</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>

                    </tbody>
                    <%}}%>
                </table>
                <div class="am-cf">
                    共 <%=pageinfo.getTotal()%> 条记录
                    <div class="am-fr">
                        <ul class="am-pagination">
                            <li <%if("1".equals(request.getAttribute("pageNum").toString())){%>class="am-disabled" <%}%>><a href="${ctx}/roommember">«</a></li>
                            <li <%if("1".equals(request.getAttribute("pageNum").toString())){%>class="am-active"<%}%>><a href="${ctx}/roommember">1</a></li>
                            <%long lun = pageinfo.getTotal()/10;
                            for(int i=0;i<lun;i++){
                            %>
                            <li <%if(String.valueOf(i+2).equals(request.getAttribute("pageNum").toString())){%>class="am-active"<%}%>><a href="${ctx}/roommember?pageNum=<%=i+2%>"><%=i+2%></a></li>
                            <%}%>
                            <li><a href="${ctx}/roommember?pageNum=<%=lun%>">»</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</div>
<!-- content end -->
<style>
    .admin-menu {
        position: fixed;
        z-index: 10;
        top: 70px;
        right: 20px;
        height: 50px;
    }
</style>
<!-- content end -->
<%--<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>--%>
<script>
$(function () {
    $("#searchuser").val(decodeURIComponent("${searchuserid}"));
    $("#searchbutton").on("click",function () {
        var searchroomid = $("#searchroomid").val();
        var searchuser =  $("#searchuser").val();
        window.location = "${ctx}/roommember?roomid=" + searchroomid + "&searchuserid="+encodeURIComponent(encodeURIComponent(searchuser));
    });
});
function operID(opertype,userid,roomid) {
    var url = "${ctx}/operRoom";
    var iobj ={
        'beOperedId' : userid,
        'roomid' : roomid,
        'operType':opertype
    }
    $.ajax({
        type: "POST",
        async : false,
        url: url,
        data: iobj,// 要提交的表单
        success: function (msg) {
            if(msg.split("|")[0]=="error"){
                layer.msg(msg.split("|")[1], {
                    offset: 0,
                    shift: 10
                });
            }else if(msg.split("|")[0]=="success"){
                layer.msg("操作成功", {
                    offset: 0,
                    shift: 10
                });
                window.location.reload();
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

</script>

</body>
</html>
