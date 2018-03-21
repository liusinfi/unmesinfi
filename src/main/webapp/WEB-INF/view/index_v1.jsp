<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String path = request.getContextPath();%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" >
    <title>KChat登陆</title>
    <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
    <script src="<%=path%>/static/plugins/amaze/js/amazeui.min.js"></script>
    <script src="<%=path%>/static/plugins/layer/layer.js"></script>
    <script src="<%=path%>/static/source/js/prefixfree.min.js"></script>
    <link rel="stylesheet" href="<%=path%>/static/plugins/amaze/css/amazeui.min.css">
    <link rel="stylesheet" href="<%=path%>/static/source/css/normalize.min.css">
    <link href="<%=path%>/static/source/css/web.css" rel='stylesheet' type='text/css' />
</head>
<body>
    <h1>聊天系统</h1>
<div class="login" id="logindiv" align="center">
        <div style="padding-top: 15px;">
            <div class="am-input-group am-input-group-sm">
                <div style="text-align: right;">
                    <%--<img id="userimg" src="<%=path%>/upload/resizeApi.png" width="30">--%>
                    <span id="userspan">游客,你好! &nbsp;&nbsp;&nbsp;&nbsp;</span>
                </div>
                <span class="am-input-group-btn" style="right: 10px;">
                    <button class="mybtn btn-success"  type="button" id="btnlogin">登录</button>
                    <button class="mybtn btn-success"  type="button" id="btnregister">注册</button>
                    <button class="mybtn btn-success"  type="button" id="btninfo">个人信息</button>
                    <button class="mybtn btn-danger"  type="button" id="btnout">退出</button>
                  </span>

            </div>
        </div>
        <h1></h1>
    <div class="admin-content" style="margin: 0 15px 30px 15px;border: 2px solid #d8dae2;border-radius: 4px;">

        <div class="admin-content-body">

            <div class="am-cf am-padding am-padding-bottom-0" style="background-color: #337ab7;border-radius: 4px;">
                <div class="am-fl am-cf" ><strong class="am-text-primary am-text-lg" style="color: black;">聊天室列表</strong> / <small>Table</small></div>
            </div>

            <div class="am-g">
                <div class="am-u-sm-12">
                    <form class="am-form">
                        <%--<table class="am-table am-table-striped am-table-hover table-main" >--%>
                        <table class="am-table am-table-bd am-table-striped admin-content-table">
                            <thead>
                            <tr>
                                <th class="table-id">ID</th><th class="table-title">聊天室名称</th><th class="table-type">聊天室类别</th><th class="table-author am-hide-sm-only">群简介</th><th class="table-date am-hide-sm-only">人数</th><th class="table-set">操作</th>
                            </tr>
                            </thead>
                            <tbody id="chatroomtable">
                                <c:forEach items= "${ChatRooms}" var="d">
                                <tr>
                                    <td>${d.id}</td>
                                    <td>${d.roomtitle}</td>
                                    <td>聊天室</td>
                                    <td class="am-hide-sm-only">${d.roomcontent}</td>
                                    <td class="am-hide-sm-only"><span style="color: red;" id="count-${d.id}">0</span>人</td>
                                    <td>
                                        <a href="javascript:void(0);" style="color: #0a628f;" onclick="accessIn(this);">进入</a>
                                    </td>
                                    <td style="display: none;">${d.roomtype}</td>
                                    <td style="display: none;">${d.roomnotice}</td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <hr />
                        <div class="am-cf">
                            共 ${ChatRooms.size()} 条记录
                        </div>
                    </form>

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
<div class="am-modal am-modal-no-btn" tabindex="-1" id="doc-modal-1" style="z-index: 9999;" >
    <div class="am-modal-dialog">
        <div class="am-modal-hd" style="padding: 5px 5px 5px;"><span id="chatTitle"></span>
            <a href="javascript: void(0)" class="am-icon-angle-double-up" id="bigandsmall" style="float:right;margin-right: 30px;margin-top: -3px;"></a>
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <iframe id="chatWin"  width=1100 height=550 align="center" src="" name="chatwinname"></iframe>
        </div>
    </div>
</div>

<script>
    var screenHeightMy = document.body.clientHeight;
    var screenWidthMy = document.body.clientWidth;
    var iframe_origin_width,iframe_origin_height,modal_margin_left,modal_margin_top;
    $(function(){
        if("${errorinfo}" !=null && "${errorinfo}" !=""){
            layer.msg("${errorinfo}", {
                offset: 0,
                shift: 6
            });
        }
        $("#logindiv").css("width",document.body.clientWidth*0.7+"px");
        $("#logindiv").css("left",document.body.clientWidth*0.15+"px");
        $("#btnlogin").on("click",function () {
            window.location = "/user/login";
        });
        $("#btnregister").on("click",function () {
            window.location = "/user/login?show=register";
        });
        $("#btnout").on("click",function () {
            window.location = "/user/logout";
        });
        $("#btninfo").on("click",function () {
            window.location = "/config";
        });
        if("${userid}"!=null && "${userid}"!=""){
            $("#userimg").attr("src","");
            $("#userspan").html("${userid}"+"你好!&nbsp;&nbsp;&nbsp;&nbsp;");
            $("#btnout").show();$("#btnlogin").hide();$("#btnregister").hide();$("#btninfo").show();
        }else{
            $("#btninfo").hide();$("#btnout").hide();$("#btnlogin").show();$("#btnregister").show();
        }
        $("#btn-back").on("click",function(){
            window.location = "/unchk/first?show=info";
        });
        <c:if test="${not empty param.timeout}">
        layer.msg('连接超时,请重新登陆!', {
            offset: 0,
            shift: 6
        });
        </c:if>
        $('#doc-modal-1').on('close.modal.amui', function(){
            $("#chatWin").attr("src","");
            if(iframe_origin_width!=null && iframe_origin_width !=""){
                $("#chatWin").attr("width",iframe_origin_width);
            }
            if(chatwinname && chatwinname.window){
                chatwinname.window.closeConnection();
            }
        });
        $("#bigandsmall").on("click",modalBigBig);
        var countmap = '${countMap}';
        var reg = new RegExp( '=' , "g" )
        var obj = eval('(' + countmap.replace(reg,":") + ')');
        for(var key in obj){
            $("#count-"+key).html(obj[key]);
        }
    });
    function modalBigBig() {
        $("#chatWin").attr("width",screenWidthMy-50);
        //$("#chatWin").attr("height",screenHeightMy);
        if(chatwinname && chatwinname.window){
            chatwinname.window.ajustfullscreen(1);
        }
        $("#doc-modal-1").css("width",screenWidthMy+"px");
        $("#doc-modal-1").css("margin-left",0-screenWidthMy/2+"px");
        $("#doc-modal-1").css("margin-top",0-screenHeightMy/2+"px");
        $("#bigandsmall").removeClass("am-icon-angle-double-up");
        $("#bigandsmall").addClass("am-icon-angle-double-down");
        $("#bigandsmall").on("click",modalsmall);
    }
    function modalsmall() {
        $("#chatWin").attr("width",iframe_origin_width);
        //$("#chatWin").attr("height",iframe_origin_height);
        if(chatwinname && chatwinname.window){
            chatwinname.window.ajustfullscreen(0);
        }
        $("#doc-modal-1").css("width","1120px");
        $("#doc-modal-1").css("margin-left",modal_margin_left);
        $("#doc-modal-1").css("margin-top",modal_margin_top);
        $("#bigandsmall").removeClass("am-icon-angle-double-down");
        $("#bigandsmall").addClass("am-icon-angle-double-up");
        $("#bigandsmall").on("click",modalBigBig);
    }

    function accessIn(obj){
        if(("${userid}" ==null || "${userid}" =="")){
            layer.msg('请先登陆!', {
                offset: 0,
                shift: 10
            });
            return false;
        }
        var $td = $(obj).parents("tr").children('td');
        var roomid = $td.eq(0).text();
        var roomTitle = $td.eq(1).text();
        var roomNotice = $td.eq(7).html();
        $.ajax({
            type: "POST",
            async : false,
            url: "/unchk/canVisitRoom",
            data: {'roomid' : roomid,'userid' : "${userid}"},
            success: function (msg) {
                if(msg == "0"){
                    jumptochat(roomid,null,roomTitle,roomNotice);
                }else if(msg == "1"){
                    window.location = "/user/login";
                }else if(msg == "2"){
                    layer.msg("您已被踢出聊天室!", {
                        offset: 0,
                        shift: 6
                    });
                    return;
                }else if(msg == "3"){
                    $('#my-prompt').modal({
                        relatedTarget: this,
                        onConfirm: function(e) {
                            var password = e.data;
                            var pobj = {
                                'roomid' : roomid,
                                'userid' : "${userid}",
                                'password' : password
                            }
                            $.ajax({
                                type: "POST",
                                async : false,
                                url: "${ctx}/checkRoomPass",
                                data: pobj,
                                success: function (msg) {
                                    if(msg.split("|")[0]=="error"){
                                        layer.msg(msg.split("|")[1], {
                                            offset: 0,
                                            shift: 6
                                        });
                                        return;
                                    }else{
                                        jumptochat(roomid,password,roomTitle,roomNotice);
                                    }
                                },
                                error: function (error) {
                                    layer.msg("密码错误", {
                                        offset: 0,
                                        shift: 6
                                    });
                                }
                            });
                        }
                    });
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
    function jumptochat(roomid,password,roomTitle,roomNotice) {
        $("#chatTitle").html(roomTitle);
        var url ="${ctx}/unchk/cwat?roomid="+roomid+"&password=" + password+"&scrnhei="+document.body.clientHeight+"&r="+Math.random();
        url = encodeURI(encodeURI(url));
        $("#chatWin").attr("src",url);
        var $modal = $('#doc-modal-1');
        $modal.modal({ width: 1120, height: document.body.clientHeight , closeViaDimmer: false });
        setTimeout(function () {
            iframe_origin_width = $("#chatWin").css("width");
            iframe_origin_height = $("#chatWin").css("height");
            modal_margin_left = $("#doc-modal-1").css("margin-left");
            modal_margin_top = $("#doc-modal-1").css("margin-top");
        },2000);
    }

</script>
</body>
</html>