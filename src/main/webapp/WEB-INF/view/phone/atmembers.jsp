<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<div id="atmemberdiv">
    <header class="am-topbar am-topbar-inverse admin-header">
        <div class="am-topbar-brand">
            <i class="am-icon-chevron-left" onclick="$('#atmemberdiv').hide();"></i>&nbsp;&nbsp;<span>选择要@成员</span>
        </div>
    </header>
<div class="am-panel am-panel-default" style=" height:${chathei5}px;overflow:auto;" id="atmemdiv">
    <div class="am-input-group-sm">
        <input id="atsearchinput" type="text" class="am-form-field" oninput="atsearchuser()" placeholder="请输入名称"
               style="border-radius: 6px;background: url(${ctx}/static/source/img/search.png) no-repeat scroll right center transparent;">
    </div>

    <ul class="am-list am-list-static am-list-striped" style="height:${chathei6}px;" id="atlist">
        <%List<User> roomList2 = (List)request.getAttribute("roomlists");
            String usertype2 = (String)request.getSession().getAttribute("usertype");
            if(roomList2 !=null && roomList2.size()>0){
                for(User rmb : roomList2){
        %>
        <li id="liitA<%=rmb.getUserid()%>">
            <img width="48" height="48" style="border-radius:50%;" alt="" src="${ctx}/<%=rmb.getProfilehead()%>">
            <%if(Integer.valueOf(rmb.getUsertype())<=0){%>
            <a href="javascript:void(0);" class="atadminclr" style="display:inline;padding-left: 0.3rem;" onclick="addAtUserText('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype2)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
            <%}else{%>
            <a href="javascript:void(0);" style="display:inline;padding-left: 0.3rem;" onclick="addAtUserText('<%=rmb.getUserid()%>')"><%=Integer.valueOf(usertype2)<=0?(rmb.getUserid()+"("+ (StringUtils.isEmpty(rmb.getKname())?"无":rmb.getKname())+")"):rmb.getUserid()%></a>
            <%}%>
        </li>
        <%}}%>
    </ul>
    <ul class="am-list am-list-static am-list-striped" style="height:${chathei6}px;" id="atlistsearch">
    </ul>
</div>
</div>
<style>
    #atmemberdiv {
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
    #atlistsearch {
        position: absolute;
        z-index: 1002;
        width: 100%;
        background-color: #f2f1f1;
        border-top: 1px solid #d8dae2;
        border-right: 1px solid #d8dae2;
        border-bottom: 0;
        padding-top: 3px;
        display: none;
        top: 88px;
    }
    .boxatmsgcls {
        position: absolute;
        z-index: 2000;
        width: 100%;
        background: #fff;
        bottom: 60px;
    }
    .atadminclr{
        color: red;
    }
</style>
<script>
    $(function () {
        $("#message").on("input", function() {
            var msg = $("#message").html();
            if(msg.lastIndexOf("@")==0){
                $("#atmemberdiv").show();
            }
        });
    });
    function atsearchuser() {
        $("#atlistsearch").html("");
        $("#atlistsearch").hide();
        var valusk = $("#atsearchinput").val();
        if(valusk == null || valusk==""){
            layer.msg("请输入名称", { offset: 0, shift: 6 });
            return;
        }
        var lis = $("#atlist li");var x = 0;
        for(var i=0;i<lis.length;i++){
            if(lis[i].innerText.indexOf(valusk)>=0 ){
                $("#atlistsearch").append("<li>"+lis[i].innerHTML+"</li>");
                x++;
            }
        }
        if(x>0){
            $("#atlistsearch").css("height",(document.body.clientHeight-90)+"px");
            $("#atlistsearch").show();
        }
    }
    function addAtUserText(willTh,flag) {
        willTh = willTh.replace(" ","");//多出空格去掉
        willTh = willTh.split("(")[0];
        var msg = $("#message").html();
        $("#message").html(msg.substring(0,msg.lastIndexOf("@")) +"<a href='#'>@"+willTh+"&nbsp;&nbsp;</a>")
        $("#atmemberdiv").hide();
        if(flag !=null){
            $("#"+flag).remove();
        }
    }
    function showAtInfo(from,contentsh,to) {
        var flag = "L"+uuid(3,9);
        $("#atmsginf").append("<li id=\""+flag+"\" style='border: 1px solid #dedede;font-size: 1.2rem;'>" +
            "<a href='#' onclick='addAtUserText(\""+from+"\",\""+flag+"\")'>"+from+"</a>&nbsp;:&nbsp;"+
            contentsh+"<a href='#' onclick='addAtUserText(\""+from+"\",\""+flag+"\")'>&nbsp;&nbsp;[回复]</a><a href=\"#\" class=\"am-close\" onclick=\"removeAtInf('"+flag+"')\" style='float: right;'>&times;</a>" + "</li>");
    }
    function removeAtInf(flag) {
        $("#"+flag).remove();
    }
</script>
</body>
</html>
