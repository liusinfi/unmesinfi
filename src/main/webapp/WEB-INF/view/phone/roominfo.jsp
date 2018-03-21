<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/1/18
  Time: 15:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<div id="roominfoctrl">

<header class="am-topbar am-topbar-inverse admin-header">
    <div class="am-topbar-brand">
        <i class="am-icon-chevron-left" onclick="backPhoneChat()"></i>&nbsp;&nbsp;<span>群公告</span>
    </div>
</header>
<div class="am-panel am-panel-default" style=" height:${chathei5}px;overflow:auto;" id="roominfos">
<section data-am-widget="accordion" class="am-accordion am-accordion-default" data-am-accordion='{ "multiple": true }' id="syscontentheight">
    <dl class="am-accordion-item am-active">
        <dt class="am-accordion-title" style="text-align: center;">
            公告
        </dt>
        <dd class="am-accordion-bd am-collapse am-in">
            <!-- 规避 Collapase 处理有 padding 的折叠内容计算计算有误问题， 加一个容器 -->
            <div class="am-accordion-content">
                <p id="syscontent"></p>
            </div>
        </dd>
    </dl>
</section>
<ul class="am-list admin-sidebar-list" id="collapase-nav-1">
    <li class="am-panel">
        <a data-am-collapse="{parent: '#collapase-nav-1'}" onclick="showmembers()">
            <i class="am-icon-users am-margin-left-sm"></i> 群成员
            <i class="am-icon-angle-right am-fr am-margin-right"></i>
        </a>
    </li>
    <li class="am-panel">
        <a data-am-collapse="{parent: '#collapase-nav-1'}" onclick="showHistoryHE('${roomid}','1')">
            <i class="am-icon-users am-margin-left-sm"></i> 聊天记录
            <i class="am-icon-angle-right am-fr am-margin-right"></i>
        </a>
    </li>
</ul>
</div>
</div>
<style>
    #roominfoctrl {
        position: absolute;
        z-index: 1000;
        width: 100%;
        background-color: #f2f1f1;
        border-top: 1px solid #d8dae2;
        border-right: 1px solid #d8dae2;
        border-bottom: 0;
        padding-top: 3px;
        display: none;
        top: -5px;
    }
</style>
<script>

    function showRoomInfo() {
        $("#roominfoctrl").show();
    }
    function backPhoneChat() {
        $("#roominfoctrl").hide();
    }
    function showmembers() {
        $("#roommembersctrl").show();
    }
</script>
</body>
</html>
