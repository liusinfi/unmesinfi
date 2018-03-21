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
  <title>KChat注册</title>
  <link href="<%=path%>/static/source/css/login.css" rel='stylesheet' type='text/css' />
  <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
  <script src="<%=path%>/static/plugins/layer/layer.js"></script>
  <style>

  </style>
</head>
<body>

<h1>注册</h1>
<div class="login-form">
  <div class="close"> </div>
  <div class="head-info">
    <label class="lbl-1"></label>
    <label class="lbl-2"></label>
    <label class="lbl-3"></label>
  </div>
  <div class="clear"> </div>
  <div class="avtar"><img src="<%=path%>/static/source/img/adm.png" /></div>
  <form id="register-form" action="<%=path%>/user/register" method="post" onsubmit="return checkLoginForm()">
    <div class="key">
      <input type="text" id="username" name="userid" placeholder="请输入账号" >
    </div>
    <div class="key">
      <input type="password" id="password" name="password" style="margin-bottom: 0em;" placeholder="请输入密码">
    </div>
    <div class="key">
      <input type="password" id="passwordConfirm" name="passwordConfirm"  style="margin-bottom: 0em;" placeholder="确认密码">
    </div>
    <div class="key">
      <input type="text" id="nickname" name="nickname" style="margin-top: 0em;" placeholder="请输入QQ号" >
    </div>
    <div class="signin">
      <input type="submit" id="submit" value="注册" >
    </div>
  </form>
</div>

<script>
  $(function(){
    <c:if test="${not empty param.timeout}">
      layer.msg('连接超时,请重新登陆!', {
        offset: 0,
        shift: 6
      });
    </c:if>

    if("${error}"){
      $('#submit').attr('value',"${error}").css('background','red');
    }
      if (document.body.clientWidth<1024){
          $("body").css("min-height",$(window).height());
      }
    if("${message}"){
      layer.msg('${message}', {
        offset: 0,
      });
    }

    $('.close').on('click', function(c){
      $('.login-form').fadeOut('slow', function(c){
        $('.login-form').remove();
      });
    });

    $('#username,#password,#passwordConfirm,#nickname').change(function(){
      $('#submit').attr('value','注册').css('background','#3ea751');
    });
  });

  /**
   * check the login form before user login.
   * @returns {boolean}
   */
  function checkLoginForm(){
    var username = $('#username').val();
    var password = $('#password').val();
    var passwordConfirm = $('#passwordConfirm').val();
      var nickname = $('#nickname').val();
    if(isNull(username) && isNull(password)){
      $('#submit').attr('value','请输入账号和密码!!!').css('background','red');
      return false;
    }
    if(isNull(username)){
      $('#submit').attr('value','请输入账号!!!').css('background','red');
      return false;
    }
    if(isNull(password)){
      $('#submit').attr('value','请输入密码!!!').css('background','red');
      return false;
    }
    if(isNull(passwordConfirm)){
        $('#submit').attr('value','请输入确认密码!!!').css('background','red');
        return false;
    }
    if(password != passwordConfirm){
          $('#submit').attr('value','两次输入密码不一致!!!').css('background','red');
          return false;
      }
      if(!isQQ(nickname)){
          $('#submit').attr('value','QQ号码错误!!!').css('background','red');
          return false;
      }
  var obj = {
      'userid' : username
  }
  var isValidate = false;
      $.ajax({
          type: "GET",
          async : false,
          url: "<%=path%>/user/registerValidate",
          data: obj,// 要提交的表单
          success: function (msg) {
              if(msg.split("|")[0]=="error"){
                  layer.msg(msg.split("|")[1], {
                      offset: 0,
                      shift: 10
                  });
              }else{
                  isValidate = true;
              }
          },
          error: function (error) {
              layer.msg("注册错误", {
                  offset: 0,
                  shift: 6
              });
              return false;
          }
      });
      if(isValidate){
          $('#submit').attr('value','注册中......');
          return true;
      }else{
          return false;
      }

  }

  function isQQ(aQQ) {
      var bValidate = RegExp(/^[1-9][0-9]{4,9}$/).test(aQQ);
      if (bValidate) {
          return true;
      }
      else
          return false;
  }

  /**
   * check the param if it's null or '' or undefined
   * @param input
   * @returns {boolean}
   */
  function isNull(input){
    if(input == null || input == '' || input == undefined){
      return true;
    }
    else{
      return false;
    }
  }
</script>
</body>
</html>