<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ page import="com.github.pagehelper.Page" %>
<%@ page import="com.jy.webchat.pojo.RoomMember" %>
<%@ page import="com.github.pagehelper.PageInfo" %>
<%@ page import="com.jy.webchat.pojo.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html class="no-js fixed-layout">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>KChat用户管理</title>
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
<div class="admin-content" style="overflow:auto;">
    <div class="admin-content-body">
        <div class="am-cf am-padding am-padding-bottom-0">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">用户列表</strong> / <small>Table</small></div>
        </div>
        <hr>
        <div class="am-u-sm-12 am-u-md-3">
            <div class="am-form-group">
                <select  id="searchroomid" name="searchroomid" data-am-selected="{btnSize: 'sm'}">
                    <option value="-1">用户名</option>
                </select>
            </div>
        </div>
        <div class="am-u-sm-12 am-u-md-3">
            <div class="am-input-group am-input-group-sm">
                <input type="text" id="searchuser" name="searchuser" class="am-form-field" placeholder="输入用户名/备注/QQ">
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
                        <th>用户名</th><th>QQ</th><th>性别</th><th>注册时间</th><th>最后登录时间</th><th>用户权限</th><th>备注名</th><th>管理</th>
                    </tr>
                    </thead>
                    <%PageInfo pageinfo = (PageInfo)request.getAttribute("page");
                        String usertype = (String)request.getSession().getAttribute("usertype") ;
                        List<User> list = pageinfo.getList();
                    if(pageinfo.getTotal()>0){
                        for(int i=0;i<list.size();i++) {
                            User user = list.get(i);

                    %>
                    <tbody>
                    <tr><td><%=user.getUserid()%></td><td><%=user.getNickname()%></td>
                        <td>
                            <%if(user.getSex()==-1){%>
                                保密
                            <%}else if(user.getSex()==1){%>
                                男
                            <%}else if(user.getSex()==0){%>
                                女
                            <%}%>
                        </td>
                        <td><%=user.getFirsttime()%></td>
                        <td><%=user.getLasttime()%></td>
                        <td>
                            <%if(Integer.valueOf(user.getUsertype())<=0){%>
                            管理员
                            <%}else if("1".equals(user.getUsertype())){%>
                            私聊权限
                            <%}else if("2".equals(user.getUsertype())){%>
                            普通
                            <%}%>
                        </td>
                        <td><input id="ip_<%=user.getUserid()%>" type="text" value='<%=user.getKname()==null?"":user.getKname()%>' onchange="operKname('<%=user.getUserid()%>')"/></td>
                        <td>

                            <div class="am-dropdown" data-am-dropdown>
                                <button class="am-btn am-btn-default am-btn-xs am-dropdown-toggle" data-am-dropdown-toggle><span class="am-icon-cog"></span> <span class="am-icon-caret-down"></span></button>
                                <ul class="am-dropdown-content">
                                    <li><a href="javascript:void(0);" onclick="operID('1','<%=user.getUserid()%>')">1. 开启私聊</a></li>
                                    <li><a href="javascript:void(0);" onclick="operID('2','<%=user.getUserid()%>')">2. 恢复普通</a></li>
                                    <li><a href="javascript:void(0);" onclick="operUserID('99','<%=user.getUserid()%>')">3. 重置密码</a></li>
                                    <%if("-1".equals(usertype)){%>
                                    <li><a href="javascript:void(0);" onclick="operID('0','<%=user.getUserid()%>')">4. 置为管理员</a></li>
                                    <%}%>
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
                            <li <%if("1".equals(request.getAttribute("pageNum").toString())){%>class="am-disabled" <%}%>>
                                <a href="${ctx}/userlist">«</a>
                            </li>
                            <li <%if("1".equals(request.getAttribute("pageNum").toString())){%>class="am-active"<%}%>><a href="${ctx}/userlist">1</a></li>
                            <%long lun = pageinfo.getTotal()/10;
                            for(int i=0;i<lun;i++){
                            %>
                            <li <%if(String.valueOf(i+2).equals(request.getAttribute("pageNum").toString())){%>class="am-active"<%}%>><a href="${ctx}/userlist?pageNum=<%=i+2%>"><%=i+2%></a></li>
                            <%}%>
                            <li><a href="${ctx}/userlist?pageNum=<%=lun%>">»</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</div>
<div class="am-modal am-modal-prompt" tabindex="-1" id="my-prompt">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">请输入密码：</div>
        <div class="am-modal-bd">
            <input type="text" class="am-modal-prompt-input">
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-confirm>确认</span>
        </div>
    </div>
</div>
<style>
    .admin-menu {
        position: fixed;
        z-index: 10;
        top: 70px;
        right: 20px;
        height:50px;
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
        var searchuser =  $("#searchuser").val();
        window.location = "${ctx}/userlist?searchuserid="+encodeURIComponent(encodeURIComponent(searchuser));
    });
});
function operKname(userid) {
    var url = "${ctx}/operKname";
    var iobj ={
        'beOperedId' : userid,
        'Kname' : $("#ip_"+userid).val()
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
                layer.msg("保存成功", {
                    offset: 0,
                    shift: 10
                });
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
function operUserID(opertype,userid) {
    if(opertype=='99'){
        $('#my-prompt').modal({
            relatedTarget: this,
            onConfirm: function(e) {
                var password = e.data;
                if(password ==null || password == ""){
                    layer.msg("请输入密码!", {
                        offset: 0,
                        shift: 10
                    });
                    return;
                }
                operID(opertype,userid,password);
            }
        });
    }
}
function operID(opertype,userid,password) {
    var url = "${ctx}/operUser";
    var iobj ={
        'beOperedId' : userid,
        'operType':opertype
    }
    if(password!=null && password !=""){
        iobj.password = password;
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
