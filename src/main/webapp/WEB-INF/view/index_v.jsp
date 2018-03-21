
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="/static/plugins/jquery/jquery-2.1.4.min.js"></script>
</head>
<body>
<script>
    $(function () {
        if (document.body.clientWidth<1024){
            window.location = "/unchk/index?m=p&e=${errorinfo}&r="+Math.random();
        }else{
            window.location = "/unchk/index?m=w&e=${errorinfo}&r="+Math.random();
        }
    });
</script>

</body>

</html>
