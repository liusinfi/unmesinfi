<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<body>
<div id="userINF">
    <header data-am-widget="header"
            class="am-header am-header-default am-no-layout">
        <h1 class="am-header-title">我的</h1>
    </header>
    <div data-am-widget="intro"
         class="am-intro am-cf am-intro-default am-no-layout">
        <div class="am-g am-intro-bd">
            <c:if test="${empty user}">
                <div class="am-intro-left am-u-sm-3">
                    <img src="/static/source/img/QQ_TEMP.png" alt="游客">
                </div>
                <div class="am-intro-right am-u-sm-9">
                    <h1>游客</h1>
                    <p><a href="/user/login">请先登录</a></p>
                </div>
            </c:if>
            <c:if test="${not empty user}">
                <div class="am-intro-left am-u-sm-3">
                    <img src="/${user.profilehead}" alt="${user.userid}" width="100" height="60">
                </div>
                <div class="am-intro-right am-u-sm-9">
                    <h1>${user.userid}</h1>
                </div>
            </c:if>
        </div>
    </div>

    <div id="demo-view" data-backend-compiled="">
        <div data-am-widget="list_news" class="am-list-news am-list-news-default am-no-layout">
            <div class="am-list-news-bd">
                <ul class="am-list" id="usersetting">
                    <li class="am-g am-list-item-desced am-list-item-thumbed am-list-item-thumb-left"
                        style="padding-top: 0.5rem;padding-bottom: 0.5rem;" onclick="groupVisited()">
                        <div class="am-u-sm-2 am-list-thumb">
                            <a href="#" class=""><img
                                    src="/static/source/img/GROUP.png"
                                    alt="群组"></a>
                        </div>
                        <div class="am-u-sm-7 am-list-main">
                            <div class="am-list-item-text" style="margin-top: 1.2rem;font-weight: bold;font-size: 16px;">我去过的群组</div>
                        </div>
                        <div class="am-u-sm-3">
                            <div class="am-list-item-text" style="margin-top: 1.2rem;font-weight: bold;" id="groupVisitedNum">未登录</div>
                        </div>
                    </li>
                    <li class="am-g am-list-item-desced am-list-item-thumbed am-list-item-thumb-left"
                        style="padding-top: 0.5rem;padding-bottom: 0.5rem;" onclick="infSetting()">
                        <div class="am-u-sm-2 am-list-thumb">
                            <a href="#" class=""><img
                                    src="/static/source/img/SETTING.png"
                                    alt="设置"></a>
                        </div>
                        <div class="am-u-sm-7 am-list-main">
                            <div class="am-list-item-text" style="margin-top: 1.2rem;font-weight: bold;font-size: 16px;">修改资料</div>
                        </div>
                        <div class="am-u-sm-3">
                            <div class="am-list-item-text" style="margin-top: 1.2rem;font-weight: bold;" id="settingDIV">未登录</div>
                        </div>
                    </li>
                    <%if(request.getSession().getAttribute("userid")!=null && request.getSession().getAttribute("userid")!=""){%>
                    <li class="am-g am-list-item-desced am-list-item-thumbed am-list-item-thumb-left"
                        style="padding-top: 0.5rem;padding-bottom: 0.5rem;" onclick="window.location='/user/logout'">
                        <div class="am-u-sm-2 am-list-thumb">
                            <a href="#" class=""><img
                                    src="/static/source/img/EXIT.png"
                                    alt="退出"></a>
                        </div>
                        <div class="am-u-sm-10 am-list-main">
                            <div class="am-list-item-text" style="margin-top: 1.2rem;font-weight: bold;font-size: 16px;">退出</div>
                        </div>
                    </li>
                    <%}%>
                </ul>
            </div>
        </div>
    </div>
</div>

<style>
    #userINF {
        position: absolute;
        z-index: 1000;
        width: 100%;
        background-color: #fff;
        border-top: 1px solid #d8dae2;
        border-right: 1px solid #d8dae2;
        border-bottom: 0;
        padding-top: 3px;
        display: none;
        top: -5px;
    }
</style>
<script>
    var screenHeightMy = document.body.clientHeight;
    $("#userINF").css("height",(screenHeightMy)+"px");
    function groupVisited() {
        if(!checkLogin()){
            window.location = "/unchk/groupvisited"
        }
    }
    function infSetting() {
        if(!checkLogin()){
            window.location = "/config?terminalType=phone";
        }
    }
    function userChangeShow() {
        $("#groupVisitedNum").html("${visitGrpSize}");
        $("#settingDIV").html("");
    }
</script>
</body>
</html>
