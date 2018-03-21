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
<div id="phonejumpdiv">

    <header class="am-topbar am-topbar-inverse admin-header">
        <div class="am-topbar-brand">
            <i class="am-icon-chevron-left" onclick="$('#phonejumpdiv').hide();"></i>&nbsp;&nbsp;<span>线路选择</span>
        </div>
    </header>
    <div class="am-panel am-panel-default" style=" height:${chathei5}px;overflow:auto;">
        <section data-am-widget="accordion" class="am-accordion am-accordion-default" data-am-accordion='{ "multiple": true }' >
            <dl class="am-accordion-item am-active">
                <dt class="am-accordion-title" style="text-align: center;">
                    线路列表
                </dt>
                <dd class="am-accordion-bd am-collapse am-in">
                    <!-- 规避 Collapase 处理有 padding 的折叠内容计算计算有误问题， 加一个容器 -->
                    <div class="am-accordion-content" align="center">
                        <c:set value="${fn:split(syslocate,',')}" var="str1" />
                        <c:forEach items="${str1}" var="s" varStatus="xh">
                            <h2><a href="${s}"  target="_blank">线路${xh.index}</a></h2>
                        </c:forEach>
                    </div>
                </dd>
            </dl>
        </section>

    </div>
</div>
<style>
    #phonejumpdiv {
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
</body>
</html>
