<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html class="no-js fixed-layout">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>WebChat | 个人设置</title>
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <jsp:include page="include/commonfile.jsp"/>
    <script src="${ctx}/static/plugins/jquery/jquery-ui.min.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.fileupload.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.ui.widget.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery.iframe-transport.js"></script>
    <script src="${ctx}/static/source/js/mobileBUGFix.mini.js"></script>
    <script src="${ctx}/static/source/dojs/picts.js"></script>
</head>
<body>
<header class="am-topbar am-topbar-inverse admin-header">
    <div class="am-topbar-brand">
        <i class="am-icon-chevron-left" onclick="window.location='/unchk/first';"></i>&nbsp;&nbsp;<span></span>
    </div>
</header>
<div class="am-cf admin-main">
    <div class="admin-content">
        <div class="am-cf am-padding">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">个人设置</strong> / <small>form</small></div>
        </div>

        <div class="am-tabs am-margin" data-am-tabs>
            <ul class="am-tabs-nav am-nav am-nav-tabs">
                <li class="am-active"><a href="javascript: void(0);">基本信息</a></li>
                <li><a href="javascript: void(0);">修改头像</a></li>
                <li><a href="javascript: void(0);">修改密码</a></li>
            </ul>

            <div class="am-tabs-bd">
                <div class="am-tab-panel am-fade am-in am-active" id="tab1">
                    <c:set value="${user}" var="user"/>
                    <form class="am-form am-form-horizontal" id="information-form" action="${ctx}/update" method="post" data-am-validator>
                        <div class="am-form-group">
                            <label for="userid" class="am-u-sm-2 am-form-label">用户名</label>
                            <div class="am-u-sm-10">
                                <input type="text" id="userid" name="userid" value="${user.userid}" disabled>
                            </div>
                        </div>

                        <div class="am-form-group">
                            <label for="nickname" class="am-u-sm-2 am-form-label">QQ</label>
                            <div class="am-u-sm-10">
                                <input type="text" id="nickname" name="nickname" value="${user.nickname}" required placeholder="这里输入你的QQ...">
                            </div>
                        </div>

                        <div class="am-form-group">
                            <label for="sex" class="am-u-sm-2 am-form-label">性别</label>
                            <div class="am-u-sm-10">
                                <select id="sex" name="sex" data-am-selected>
                                    <option selected></option>
                                    <option value="1">男</option>
                                    <option value="0">女</option>
                                    <option value="-1">保密</option>
                                </select>
                            </div>
                            <script>
                                $('#sex').find('option').eq(${user.sex}).attr('selected', true);
                            </script>
                        </div>
                        <div class="am-form-group">
                            <label for="age" class="am-u-sm-2 am-form-label">年龄</label>
                            <div class="am-u-sm-10">
                                <input type="number" id="age" name="age" min="1" max="100" value="${user.age}" placeholder="这里输入你的年龄...">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label for="profile" class="am-u-sm-2 am-form-label">个性签名</label>
                            <div class="am-u-sm-10">
                                <textarea class="" id="profile" name="profile" rows="5" placeholder="这里可以写下你的个性签名..."></textarea>
                            </div>
                            <script>
                                $("#profile").val("${user.profile}");
                            </script>
                        </div>
                        <div class="am-form-group">
                            <div class="am-u-sm-10 am-u-sm-offset-2">
                                <button type="submit" class="am-btn am-round am-btn-success"><span class="am-icon-send"></span> 提交</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="am-tab-panel am-fade" id="tab2">
                    <form class="am-form am-form-horizontal" style="text-align: center;">
                        <div style="text-align: center;margin-bottom: 10px">
                            <img id="userHeadimg" class="am-circle" src="${user.profilehead}" width="140" height="140" alt="${user.userid}"/>
                        </div>
                        <div class="am-form-group am-form-file">
                            <button type="button" class="am-btn am-btn-secondary am-btn-sm">
                                <i class="am-icon-cloud-upload"></i> 选择要上传的文件</button>
                            <%--<input id="file" type="file" data-url="${ctx}/uploadajax?isHead=true" name="file" onchange="checkFileType()">--%>
                            <input id="file" class="form-control" type="file" accept="image/*" name="file" onchange="checkFileType()">
                        </div>
                        <div id="file-list"></div>
                        <script>
                            $("input[type=file]").each(
                                function() {
                                    var _this = $(this);
                                    _this.localResizeIMG({
                                        width : 600,
                                        quality : 0.8,
                                        success : function(result) {
                                            //获取后缀名
                                            var att = pre.substr(pre.lastIndexOf("."));
                                            //压缩后图片的base64字符串
                                            var base64_string = result.clearBase64;
                                            //图片预览
                                            var imgObj = $("#userHeadimg");
                                            imgObj.attr("src","data:image/jpeg;base64," + base64_string).show();
                                            //拼接data字符串，传递会后台
                                            var fileData = ".png" + "," + imgObj.attr("src")
                                            //fileData.val(att + "," + imgObj.attr("src"));

                                            //此处可直接使用ajax上传，也可存于form，表单提交上传
                                            //此处例子使用ajax提交
                                            $.ajax({
                                                type : "POST",
                                                url : "<%=request.getContextPath()%>/DoUploadImg",
                                                data :{
                                                    'imgData' : fileData,
                                                    'isHead' : 'true'
                                                },
                                                success : function(msg) {
                                                    var i = msg.split("|");
                                                    if(i[0]=="success"){
                                                        layer.msg('上传成功!', {
                                                            offset: 0,
                                                            shift: 6
                                                        });
                                                    }else{
                                                        layer.msg(i[1], {
                                                            offset: 0,
                                                            shift: 10
                                                        });
                                                    }
                                                },
                                                error : function (error) {
                                                    layer.msg(error, {
                                                        offset: 0,
                                                        shift: 6
                                                    });
                                                }
                                            });

                                        }
                                    });
                                });
                        </script>
                    </form>
                </div>

                <div class="am-tab-panel am-fade" id="tab3">
                    <form class="am-form am-form-horizontal" data-am-validator action="${ctx}/pass" method="post">
                        <div class="am-form-group">
                            <label for="password1" class="am-u-sm-2 am-form-label">原密码</label>
                            <div class="am-u-sm-10">
                                <input type="password" id="password1" name="oldpass" required placeholder="请输入原密码...">
                            </div>
                        </div>

                        <div class="am-form-group">
                            <label for="password2" class="am-u-sm-2 am-form-label">新密码</label>
                            <div class="am-u-sm-10">
                                <input type="password" id="password2" name="newpass" required placeholder="请输入新密码...">
                            </div>
                        </div>

                        <div class="am-form-group">
                            <label for="password3" class="am-u-sm-2 am-form-label">确认新密码</label>
                            <div class="am-u-sm-10">
                                <input type="password" id="password3" name="newpasscf" data-equal-to="#password2" required placeholder="请确认新密码...">
                            </div>
                        </div>

                        <div class="am-form-group">
                            <div class="am-u-sm-10 am-u-sm-offset-2">
                                <button type="submit" class="am-btn am-round am-btn-success"><span class="am-icon-send"></span> 提交修改</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- content end -->
</div>
<style>
    .admin-menu {
        position: fixed;
        z-index: 10;
        top: 70px;
        right: 20px;
    }
    .am-u-sm-2 {
        padding-left: 0rem;
        padding-right: 0rem;
    }
</style>

<%--<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>--%>
<%--<jsp:include page="include/footer.jsp"/>--%>
<script>
    if("${message}"){
        layer.msg('${message}', {
            offset: 0,
        });
    }
    if("${error}"){
        layer.msg('${error}', {
            offset: 0,
            shift: 6
        });
    }
    if("${user.openid}"!=null && "${user.openid}"!="" && "${user.openid}"!='null'){
        $("#password1").val('123456');
    }
    /*if (document.body.clientWidth<1024){
        if("${user.profilehead}".indexOf("http")==0){
            $("#userHeadimg").attr("src","${user.userid}/head");
        }
    }*/


    function checkFileType(){
        var format = ["bmp","jpg","gif","png"];
        var filename = $("#file").val();
        var ext = filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
        if(jQuery.inArray(ext, format) != -1){
            return true;
        }else{
            layer.msg('头像格式只能是bmp,jpg,gif,png!', {
                offset: 0,
                shift: 6
            });
            return false;
        }
    }
</script>
</body>
</html>
