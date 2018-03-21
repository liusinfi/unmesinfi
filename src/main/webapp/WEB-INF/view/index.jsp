<%@ page import="com.jy.webchat.pojo.ChatRoomsWithBLOBs" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<% String usertype = (String)request.getSession().getAttribute("usertype");%>
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
    <style>
        .trBizo{
            /*background-color: #0b6fa2 !important;*/
            color: blue;
        }
    </style>
</head>
<body>
<jsp:include page="include/header.jsp"/>

<div class="am-cf admin-main">
    <jsp:include page="include/sidebar.jsp"/>

    <!-- content start -->
    <div class="admin-content">
    <div class="admin-content-body">
        <div class="am-cf am-padding am-padding-bottom-0">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">聊天室列表</strong> / <small>Table</small></div>
        </div>

        <hr>

        <div class="am-g">
            <%if("-1".equals(usertype)){%>
            <div class="am-u-sm-12 am-u-md-6">
                <div class="am-btn-toolbar">
                    <div class="am-btn-group am-btn-group-xs">
                        <button id="newRoom" type="button" class="am-btn am-btn-default"><span class="am-icon-plus"></span> 新增</button>
                        <button id="editRoom" type="button" class="am-btn am-btn-default"><span class="am-icon-save"></span> 修改</button>
                        <button id="delRoom" type="button" class="am-btn am-btn-default"><span class="am-icon-trash-o"></span> 删除</button>
                    </div>
                </div>
            </div>
            <%}%>
        </div>

        <div class="am-g">
            <div class="am-u-sm-12">
                <form class="am-form">
                    <%--<table class="am-table am-table-striped am-table-hover table-main" >--%>
                        <table class="am-table am-table-bd am-table-striped admin-content-table">
                        <thead>
                        <tr>
                            <th class="table-id">ID</th><th class="table-title">聊天室名称</th><th class="table-type">聊天室类别</th><th class="table-author am-hide-sm-only">群简介</th><th class="table-date am-hide-sm-only">修改日期</th><th class="table-set">操作</th>
                        </tr>
                        </thead>
                        <%List<ChatRoomsWithBLOBs> chatrooms = (List<ChatRoomsWithBLOBs>)request.getAttribute("ChatRooms");
                        if(chatrooms !=null && chatrooms.size()>0){%>
                        <tbody id="chatroomtable">
                        <%for(int i=0;i<chatrooms.size();i++){
                            ChatRoomsWithBLOBs chat = chatrooms.get(i);
                        %>
                        <tr>
                            <td><%=chat.getId()%></td>
                            <td><%--<a href="#">--%><%=chat.getRoomtitle()%><%--</a>--%></td>
                            <%if(1==chat.getRoomtype()){%>
                            <td>聊天室</td>
                            <%}else{%>
                            <td>聊天室</td>
                            <%}%>
                            <td class="am-hide-sm-only"><%=chat.getRoomcontent()%></td>
                            <td class="am-hide-sm-only"><%=chat.getLasttime()%></td>
                            <td>
                                <a href="javascript:void(0);" style="color: #0a628f;" onclick="accessIn(this);">进入</a>
                                <%if(Integer.valueOf(usertype)<=0){%>
                                    <a href="javascript:void(0);" style="color: #0a628f;" onclick="closeChat(this);">
                                        <%if("0".equals(chat.getRoomstatus())){%>
                                           解除禁言
                                        <%}else{%>
                                            禁言
                                        <%}%>
                                    </a>
                                <%}%>
                            </td>
                            <td style="display: none;"><%=chat.getRoomtype()%></td>
                            <td style="display: none;"><%=chat.getRoomnotice()%></td>
                            <td style="display: none;"><%=chat.getPassword()%></td>
                        </tr>
                        <%}%>
                        </tbody>

                        <%}%>
                    </table>

                    <hr />
                    <div class="am-cf">
                        共 <%=chatrooms.size()%> 条记录
                    </div>
                </form>

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
<div class="am-modal am-modal-no-btn" tabindex="2" id="doc2-modal-2" style="z-index: 9999;" >
    <div class="am-modal-dialog">
        <div class="am-modal-hd">编辑聊天室
            <a href="javascript: void(0)" class="am-close am-close-spin" style="right: 20px;top: 0px;width: 30px;font-size: 40px;text-shadow: 0 1px 0 #fff;" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <form class="am-form am-form-horizontal" id="information-form"  data-am-validator>
                <div class="am-form-group">
                    <label for="roomTitle" class="am-u-sm-2 am-form-label" style="padding-left: 0rem;">聊天室名称</label>
                    <div class="am-u-sm-10">
                        <input type="hidden" id="roomid" name="roomid" value="0">
                        <input type="text" id="roomTitle" name="roomTitle" value="" required placeholder="聊天室名称...">
                    </div>
                </div>

                <div class="am-form-group">
                    <label for="password" class="am-u-sm-2 am-form-label">群密码</label>
                    <div class="am-u-sm-10">
                        <input type="text" id="password" name="password" value="" placeholder="这里输入你的密码...">
                    </div>
                </div>

                <div class="am-form-group">
                    <label for="roomType" class="am-u-sm-2 am-form-label">聊天室类别</label>
                    <div class="am-u-sm-10" style="text-align: left;">
                        <select id="roomType"  name="roomType" data-am-selected>
                            <option selected></option>
                            <option value="1">聊天群</option>
                        </select>
                    </div>
                </div>
                <div class="am-form-group">
                    <label for="roomContent" class="am-u-sm-2 am-form-label">群简介</label>
                    <div class="am-u-sm-10">
                        <textarea class="" id="roomContent" name="roomContent" rows="5" placeholder="这里可以写下群简介..."></textarea>
                    </div>
                </div>
                <div class="am-form-group">
                    <label for="roomNotice" class="am-u-sm-2 am-form-label">群公告</label>
                    <div class="am-u-sm-10">
                        <textarea class="" id="roomNotice" name="roomNotice" rows="5" placeholder="这里可以写下群公告..."></textarea>
                    </div>
                </div>
                <div class="am-form-group">
                    <div class="am-u-sm-10 am-u-sm-offset-2">
                        <button type="button" id="roominfo" class="am-btn am-btn-primary"><span class="am-icon-send"></span> 提交</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">删除</div>
        <div class="am-modal-bd">
            确定要删除这条记录吗？
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>

<style>
    .am-u-sm-2 {
        padding-left: 0rem;
        padding-right: 0rem;
    }
</style>
<script>
    $(function () {
        if("no" != '${errorinfo}'){
            layer.msg('${errorinfo}', {
                offset: 0,
                shift: 10
            });
        }
        //默认选中第一行
        $("#chatroomtable tr").eq(0).addClass("trBizo");
        $("#newRoom").on("click", function(){
            $("#roomid").val("");
            $("#roomTitle").val("");
            $("#roomContent").val("");
            //$("#roomType").val("");
            if (document.body.clientWidth<1024){
                $("#doc2-modal-2").modal({ width: 310, height: 515, closeViaDimmer: true });
            }else{
                $("#doc2-modal-2").modal({ width: 800, height: 600, closeViaDimmer: false });
            }

        });
        $('#doc-modal-1').on('close.modal.amui', function(){
            $("#chatWin").attr("src","");
            if(chatwinname && chatwinname.window){
                chatwinname.window.closeConnection();
            }
        });
        $("#editRoom").on("click", function(){
            var $td = $(".trBizo").children('td');
            var roomid = $td.eq(0).text();
            var roomTitle = $td.eq(1).text();
            var roomTypeText = $td.eq(2).text();
            var roomContent = $td.eq(3).text();
            var roomType = $td.eq(6).text();
            var roomNotice = $td.eq(7).html();
            var password = $td.eq(8).text();
            $("#roomid").val(roomid);
            $("#password").val(password);
            $("#roomTitle").val(roomTitle);
            $("#roomContent").val(roomContent);
            $('#roomType').find('option').eq(roomType).attr('selected', true);
            var reg = new RegExp( '<br>' , "g" )
            $("textarea").eq(1).val(roomNotice.replace(reg,"\r\n"));
            if (document.body.clientWidth<1024){
                $("#doc2-modal-2").modal({ width: 310, height: 515, closeViaDimmer: false });
            }else{
                $("#doc2-modal-2").modal({ width: 800, height: 600, closeViaDimmer: false });
            }
        });
        $("#delRoom").on('click', function() {
            var $td = $(".trBizo").children('td');
            var roomid = $td.eq(0).text();
            var roomTitle = $td.eq(1).text();
            $('#my-confirm').modal({
                relatedTarget: this,
                onConfirm: function(options) {
                    var iurl = "${ctx}/modifyChatRoom";
                    var iobj = {
                        'roomid' : roomid,
                        'delFlag' : '1'
                    }
                    $.ajax({
                        type: "POST",
                        async : false,
                        url: iurl,
                        data: iobj,// 要提交的表单
                        success: function (msg) {
                            if(msg.split("|")[0]=="error"){
                                layer.msg(msg.split("|")[1], {
                                    offset: 0,
                                    shift: 10
                                });
                            }else if(msg.split("|")[0]=="success"){
                                layer.msg("删除成功", {
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
                },
                onCancel: function() {
                }
            });
        });
        var $table  = $("#chatroomtable tr");//
        $("#chatroomtable tr").click(function () {
            if($(".trBizo") && $("trBizo")!=null && $("trBizo")!="" && $("trBizo")!='undefined'){
                $(".trBizo").removeClass("trBizo");
            }
            $(this).addClass("trBizo");
        });

        $("#roominfo").click(function(){
            var iurl = "${ctx}/modifyChatRoom";
            //var iobj = $('#information-form').serialize();
            var iobj = {
                'roomTitle' : $("#roomTitle").val(),
                'password' : $("#password").val(),
                'roomType' : $("#roomType").val(),
                'roomContent' : $("#roomContent").val(),
                'roomNotice' : $("#roomNotice").val()
            }
            /*if(iobj.password=="" || iobj.password==null){
                layer.msg("请输入密码!", {
                    offset: 0,
                    shift: 10
                });
                return ;
            }*/
            if(iobj.roomType=="" || iobj.roomType==null){
                layer.msg("请选择聊天室类型!", {
                    offset: 0,
                    shift: 10
                });
                return ;
            }
            if(iobj.roomContent=="" || iobj.roomContent==null){
                layer.msg("请输入简介!", {
                    offset: 0,
                    shift: 10
                });
                return ;
            }
            if(iobj.roomTitle=="" || iobj.roomTitle==null){
                layer.msg("请输入聊天室名称!", {
                    offset: 0,
                    shift: 10
                });
                return ;
            }
            if(iobj.roomNotice=="" || iobj.roomNotice==null){
                layer.msg("请输入聊天群公告!", {
                    offset: 0,
                    shift: 10
                });
                return ;
            }
            iobj.roomid = $("#roomid").val();
            $.ajax({
                type: "POST",
                async : false,
                url: iurl,
                data: iobj,// 要提交的表单
                success: function (msg) {
                    if(msg.split("|")[0]=="error"){
                        layer.msg(msg.split("|")[1], {
                            offset: 0,
                            shift: 10
                        });
                    }else if(msg.split("|")[0]=="success"){
                        layer.msg("编辑成功", {
                            offset: 0,
                            shift: 10
                        });
                        window.location.reload();
                        /*$("#roomid").val("");
                        $("#roomTitle").val("");
                        $("#roomContent").val("");
                        $("#roomType").val("");
                        $("#doc2-modal-2").modal('close');*/
                    }
                    $("#rtnInfo").html(msg);
                    $("#rtninf").click();
                },
                error: function (error) {
                    layer.msg(error, {
                        offset: 0,
                        shift: 10
                    });
                }
            });
        });
        $("#bigandsmall").on("click",modalBigBig);
    });
    var screenHeightMy = document.body.clientHeight;
    var screenWidthMy = document.body.clientWidth;
    var iframe_origin_width,iframe_origin_height,modal_margin_left,modal_margin_top;
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
        var $td = $(obj).parents("tr").children('td');
        var roomid = $td.eq(0).text();
        var roomTitle = $td.eq(1).text();
        var roomNotice = $td.eq(7).html();
        var needpassword = false;
        $.ajax({
            type: "POST",
            async : false,
            url: "${ctx}/isNeedPass",
            data: {'roomid' : roomid,'userid' : "${userid}"},
            success: function (msg) {
                if(msg.split("|")[0]=="error"){
                    layer.msg(msg.split("|")[1], {
                        offset: 0,
                        shift: 6
                    });
                    return;
                }
                if(msg=="no"){
                    jumptochat(roomid,"",roomTitle,roomNotice);
                    return;
                }else{
                    needpassword = true;
                }
            },
            error: function (error) {
                layer.msg("系统错误", {
                    offset: 0,
                    shift: 6
                });
            }
        });

        if(!needpassword){
            return;
        }
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
    }

    function closeChat(obj){
        var $td = $(obj).parents("tr").children('td');
        var roomid = $td.eq(0).text();
        $.ajax({
            type: "POST",
            async : false,
            url: "${ctx}/snoopChatStatus",
            data: {'roomid' : roomid,'userid' : "${userid}"},
            success: function (msg) {
                if(msg.split("|")[0]=="error"){
                    layer.msg(msg.split("|")[1], {
                        offset: 0,
                        shift: 6
                    });
                }else{
                    layer.msg("操作成功!", {
                        offset: 0,
                        shift: 6
                    });
                    window.location = "/QAoper";
                }
            },
            error: function (error) {
                layer.msg("系统错误", {
                    offset: 0,
                    shift: 6
                });
            }
        });
    }

    function jumptochat(roomid,password,roomTitle,roomNotice) {
        $("#chatTitle").html(roomTitle);
        if (document.body.clientWidth>=1024){
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
    }

    function setIframeHeight(iframe) {
        if (iframe) {
            var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
            if (iframeWin.document.body) {
                iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight;
                //$("#doc-modal-1").height = Number(iframe.height) +100;
            }
        }
    };

</script>

</body>
</html>
