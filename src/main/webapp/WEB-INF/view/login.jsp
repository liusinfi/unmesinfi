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
  <link href="<%=path%>/static/source/css/login1.css" rel='stylesheet' type='text/css' />
  <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
  <script src="<%=path%>/static/plugins/layer/layer.js"></script>
  <script src="<%=path%>/static/source/js/prefixfree.min.js"></script>
  <link rel="stylesheet" href="<%=path%>/static/source/css/normalize.min.css">
</head>
<body>

<div class="login" id="logindiv">
  <h1>登录</h1>
  <form id="login-form" action="<%=path%>/user/login" method="post" onsubmit="return checkLoginForm()">
    <input type="text" name="userid" id="luserid" placeholder="用户名" required="required" />
    <input type="password" name="password"  id="lpassword" placeholder="密码" required="required" />
    <input type="hidden" name="randomNum"  id="lrandomNum" value="11"/>
    <input type="hidden" name="_q"  id="_q" value="QA"/>
    <button type="submit" id="LOGIN" class="btn btn-primary btn-block btn-large">登录</button>
  </form>
  <p style="color:black;">
    还没账号 ?
    <a href="javascript:void(0);" id="to_register" style="color:red;">注册</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    社交账号登录
    <a href="javascript:void(0);" id="wechat" style="color:red;">微信</a>
  </p>
</div>
<div id="wx_container" class="wx_page"></div>
<div class="login" id="registerdiv" style="display: none;">
  <h1>注册</h1>
  <form id="register-form" action="<%=path%>/user/register" method="post" onsubmit="return checkRegisterForm()">
    <input type="text" name="userid" id="rusername" placeholder="用户名" required="required" />
    <input type="password" name="password" id="rpassword" placeholder="密码" required="required" />
    <input type="password" name="passwordConfirm" id="rpasswordConfirm" placeholder="确认密码" required="required" />
    <input type="nickname" name="nickname"  id="rnickname" placeholder="QQ" required="required" />
    <button type="submit" id="REGISTER"  class="btn btn-primary btn-block btn-large">注册</button>
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
        layer.msg('${error}', {
            offset: 0,
            shift: 6
        });
    }
    if("${message}"){
      layer.msg('${message}', {
        offset: 0,
      });
    }
      if("${errorinfo}"){
          layer.msg('${errorinfo}', {
              offset: 0,
          });
      }



      $("#wechat").on("click",function () {
          if($("#wx_container").is(":hidden")){
              getQrCode();


          }
      });
    $("#to_register").on("click",function () {
        $("#logindiv").hide();
        $("#registerdiv").show();
        $("#registerdiv").css("top","45%");
    });

      if("${userid}" && "${password}"){
          $("#luserid").val("${userid}");
          $("#lpassword").val("${password}");
          $("#login-form").submit();
      }


  });

  var randomNumS;
  function randomNum(n){
      var t='';
      for(var i=0;i<n;i++){
          t+=Math.floor(Math.random()*10);
      }
      return t;
  }

  function lunxun() {
      setInterval(function(){
          $.ajax({
              type: "POST",
              async : false,
              url: "<%=path%>/user/existslx",
              data: {'randomNum':randomNumS},// 要提交的表单
              success: function (msg) {
                 if(msg=="success"){
                     $("#lrandomNum").val(randomNumS);
                     $("#login-form").submit();
                 }
              },
              error: function (error) {
                  layer.msg("轮询出错", {
                      offset: 0,
                      shift: 6
                  });
              }
          });
      },3000);
  }

  function getQrCode() {
      randomNumS = Number(randomNum(7));
      var senid = randomNumS;
      $.ajax({
          type: "GET",
          async : false,
          url: "<%=path%>/user/wxqrcode",
          data: {'senid':senid},// 要提交的表单
          success: function (msg) {
              if(msg == null || msg=="null" || msg == "" ){
                  layer.msg("生成二维码出错!", {
                      offset: 0,
                      shift: 10
                  });
              }else{
                  var htmlimg = "<img src='"+msg+"' width='300px'>";
                  $("#wx_container").html(htmlimg);
                  lunxun();
                  $("#logindiv").hide();
                  $("#wx_container").show();
              }
          },
          error: function (error) {
              layer.msg("生成二维码出错", {
                  offset: 0,
                  shift: 6
              });
          }
      });
  }

  /**
   * check the login form before user login.
   * @returns {boolean}
   */
  function checkLoginForm(){
    var username = $('#luserid').val();
    var password = $('#lpassword').val();
      var xrandomNum = $('#lrandomNum').val();
    if(xrandomNum != '11'){
        return true;
    }
    if(isNull(username) && isNull(password)){
        layer.msg('请输入账号和密码', {
            offset: 0,
        });
      return false;
    }
    if(isNull(username)){
        layer.msg('请输入账号', {
            offset: 0,
        });
      return false;
    }
    if(isNull(password)){
        layer.msg('请输入密码', {
            offset: 0,
        });
      return false;
    }
    else{
      $('#LOGIN').attr('value','登录中......');
      return true;
    }
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
  function checkRegisterForm(){
      var username = $('#rusername').val();
      var password = $('#rpassword').val();
      var passwordConfirm = $('#rpasswordConfirm').val();
      var nickname = $('#rnickname').val();
      if(isNull(username) && isNull(password)){
          layer.msg('请输入账号和密码', {
              offset: 0,
          });
          return false;
      }
      if(isNull(username)){
          layer.msg('请输入账号', {
              offset: 0,
          });
          return false;
      }
      if(isNull(password)){
          layer.msg('请输入密码', {
              offset: 0,
          });
          return false;
      }
      if(isNull(passwordConfirm)){
          layer.msg('请输入确认密码', {
              offset: 0,
          });
          return false;
      }
      if(password != passwordConfirm){
          layer.msg('两次输入密码不一致', {
              offset: 0,
          });
          return false;
      }
      if(!isQQ(nickname)){
          layer.msg('QQ号码错误', {
              offset: 0,
          });
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
          }
      });
      if(isValidate){
          $('#REGISTER').attr('value','注册中......');
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
</script>
</body>
</html>