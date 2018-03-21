<%@ page import="com.jy.webchat.pojo.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String path = request.getContextPath();%>
<html>
<body>
<div id="roommembersctrl">
    <header class="am-topbar am-topbar-inverse admin-header">
        <div class="am-topbar-brand">
            <i class="am-icon-chevron-left" onclick="$('#roommembersctrl').hide();"></i>&nbsp;&nbsp;<span>群成员</span>
        </div>
    </header>
<div class="am-panel am-panel-default" style=" height:${chathei5}px;overflow:auto;" id="panneldiv">
    <div class="am-panel-hd" style="text-align:center">
        <h3 class="am-panel-title">群成员 [<span id="onlinenum">0</span>/<span id="allnum">0</span>]</h3>
    </div>
    <div class="am-input-group-sm">
        <input id="searchinput" type="text" class="am-form-field" oninput="searchuser()" placeholder="请输入名称"
               style="border-radius: 6px;background: url(${ctx}/static/source/img/search.png) no-repeat scroll right center transparent;">
    </div>

    <ul class="am-list am-list-static am-list-striped" style="height:${chathei6}px;" id="list">
        <%List<User> roomList = (List)request.getAttribute("roomlists");
            String usertype = (String)request.getSession().getAttribute("usertype");
            if(roomList !=null && roomList.size()>0){
                for(User rmb : roomList){
        %>
        <li id="liit<%=rmb.getUserid()%>" class="graydown">
            <img width="48" height="48" style="border-radius:50%;" alt="" src="${ctx}/<%=rmb.getProfilehead()%>">
            <%if(Integer.valueOf(rmb.getUsertype())<=0){%>
            <a href="javascript:void(0);" class="adminclr" style="display:inline;padding-left: 0.3rem;" onclick="addTab('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
            <%}else{%>
            <a href="javascript:void(0);" style="display:inline;padding-left: 0.3rem;" onclick="addTab('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
            <%}%>
        </li>
        <%}}%>
    </ul>
    <ul class="am-list am-list-static am-list-striped" style="height:${chathei6}px;" id="listsearch">
    </ul>
</div>
</div>
<style>
    #roommembersctrl {
        position: absolute;
        z-index: 1002;
        width: 100%;
        background-color: #f2f1f1;
        border-top: 1px solid #d8dae2;
        border-right: 1px solid #d8dae2;
        border-bottom: 0;
        padding-top: 3px;
        display: none;
        top: -5px;
    }
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
        top: 127px;
    }
</style>
<script>
    $(function () {
        $.each($(".adminclr"), function(i, v){
            $(".adminclr").eq(i).parent().insertBefore("#list li:eq(0)");
        });
    });

    function searchuser() {
        $("#listsearch").html("");
        $("#listsearch").hide();
        var valusk = $("#searchinput").val();
        if(valusk == null || valusk==""){
            layer.msg("请输入名称", { offset: 0, shift: 6 });
            return;
        }
        var lis = $("#list li");var x = 0;
        for(var i=0;i<lis.length;i++){
            if(lis[i].innerText.indexOf(valusk)>=0 ){
                $("#listsearch").append("<li>"+lis[i].innerHTML+"</li>");
                x++;
            }
        }
        if(x>0){
            $("#listsearch").css("height",(document.body.clientHeight-90)+"px");
            $("#listsearch").show();
        }
    }
</script>
</body>
</html>
