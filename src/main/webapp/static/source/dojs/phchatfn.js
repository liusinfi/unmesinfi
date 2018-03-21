function fileInport(){
    $("#filesend").click();
}

function outmodal(){
    var browserName=navigator.appName;
    if (browserName=="Netscape") {
        window.opener=null;
        window.open('','_self');
        window.location.href = 'about:blank';
    } else {
        window.close();
    }
}
function opensibar(){
    $("#admin-offcanvas").on('open.offcanvas.amui', function() {
        $(window).off('resize.offcanvas.amui orientationchange.offcanvas.amui');
    }).on('close.offcanvas.amui', function() {
        $(".searchshow").hide();
    });
    $("#admin-offcanvas").offCanvas('open');
}


function ReWritable()
{
    var tbmian=document.getElementById("tbmain");
    for(var i=0;i<tbmain.rows.length;i++)
    {
        for(var j=0;j<tbmain.rows[i].cells.length;j++)
        {
            tbmain.rows[i].cells[j].onclick=AddObjOfText;
        }
    }

    var ctcolor=document.getElementById("CT");
    for(var i=0;i<ctcolor.rows.length;i++)
    {
        for(var j=0;j<ctcolor.rows[i].cells.length;j++)
        {
            ctcolor.rows[i].cells[j].onclick=colorToText;
        }
    }
}
function colorToText(){
    $("#colorpanel").hide();
    var tmsek = "#message";
    if(temsecretid != null && temsecretid!=""){
        var xcontent = $("#"+escapeJquery(temsecretid)+"content");
        if(xcontent.length>0 && xcontent.hasClass("am-active")){
            tmsek = tmsek + "-" + escapeJquery(temsecretid);
        }
    }
    $(tmsek).css("color",rgb2hex($(this).css("background-color")));
}
function rgb2hex(rgb) {
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}
function colorMouseOver(){
    $("#DisColor").css("background-color",rgb2hex($(this).css("background-color")));
    $("#HexColor").val(rgb2hex($(this).css("background-color")));
}
function judgeAdd(contnetname) {
    if($(".am-active").length > 0){
        $(".am-active").removeClass("am-active");
    }
    if($(".am-in").length > 0){
        $(".am-in").removeClass("am-in");
    }
    if($("#"+contnetname).length > 0){
        if(!$("#"+contnetname).hasClass("am-active")){
            $("#"+contnetname).addClass("am-active")
        }
        if(!$("#"+contnetname).hasClass("am-in")){
            $("#"+contnetname).addClass("am-in")
        }
    }
}
function AddObjOfText(){
    var innhtml = this.innerHTML;
    var i = innhtml.lastIndexOf("/");
    var df = innhtml.substring(i+1,innhtml.length-6);
    var tmsek = "#message";
    if(temsecretid != null && temsecretid!=""){
        var xcontent = $("#"+escapeJquery(temsecretid)+"content");
        if(xcontent.length>0 && xcontent.hasClass("am-active")){
            tmsek = tmsek + "-" + escapeJquery(temsecretid);
        }
    }
    $(tmsek).html($(tmsek).html()+"{"+df+"}");
    $(".box_emote").hide();
}
function showchgdailog(obj,dsecretid){
    if(dsecretid != null && dsecretid!=""){
        temsecretid = dsecretid;
    }

    if("icon-font current" == obj.className){
        if($("#fontchange").is(":hidden")){
            $("#fontchange").show();
        }else{
            $("#fontchange").hide();
        }
    }
    if("icon-emote" == obj.className){
        if($(".box_emote").is(":hidden")){
            $(".box_emote").show();
        }else{
            $(".box_emote").hide();
        }
    }
}


function analysisMessage(message){
    message = JSON.parse(message);
    if(message.type == "TR"){      //心跳消息
        outChat(message.message);
        return;
    }
    if(message.type == "roommsg"){      //心跳消息
        chgnNotice(message.message);
        return;
    }
    if(message.type == "heartbeat"){      //心跳消息
        //alert("心跳");
        return;
    }
    if(message.type == "message"){      //会话消息
        showChat(message.message);
    }
    if(message.type == "notice"){       //提示消息
        showNotice(message.message,message.offuser);
    }
    if(message.list != null && message.list != undefined && message.onuser != null && message.onuser != undefined){      //在线列表
        showOnline(message.list,message.onuser);
    }
    if(message.onlinenum != null && message.onlinenum != undefined){      //在线数目
        showOnlineNum(message.onlinenum);
    }
    if(message.offuser != null && message.offuser != undefined){      //在线列表
        showOffline(message.offuser);
    }
}
function chgnNotice(msg){
    $("#syscontent").html(msg);
}
function showNotice(notice,offuser){
    var chatS = "#chat";
    var chatViewS = "#chat-view";
    if(offuser != null && offuser != undefined){
        if($(chatS + "-"+escapeJquery(offuser)).length>0){
            chatS = chatS + "-"+escapeJquery(offuser);
            chatViewS = chatViewS + "-"+escapeJquery(offuser);
        }
    }
    $(chatS).append("<div><p class=\"am-text-success\" style=\"text-align:center\"><span class=\"am-icon-bell\"></span> "+notice+"</p></div>");
    var chat = $(chatViewS);
    chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
}
function CheckFile(obj) {
    var array = new Array('gif', 'jpeg', 'png', 'jpg');  //可以上传的文件类型
    if (obj.value == '') {
        alert("让选择要上传的图片!");
        return false;
    }
    else {
        var fileContentType = obj.value.match(/^(.*)(\.)(.{1,8})$/)[3]; //这个文件类型正则很有用：）
        var isExists = false;
        for (var i in array) {
            if (fileContentType.toLowerCase() == array[i].toLowerCase()) {
                isExists = true;
                return true;
            }
        }
        if (isExists == false) {
            obj.value = null;
            alert("上传图片类型不正确!");
            return false;
        }
        return false;
    }
}
function closeimg(){
    $(".img_show").hide();
}
function uuid(len, radix) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    var uuid = [], i;
    radix = radix || chars.length;

    if (len) {
        // Compact form
        for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
        // rfc4122, version 4 form
        var r;

        // rfc4122 requires these characters
        uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
        uuid[14] = '4';

        // Fill in random data. At i==19 set the high bits of clock sequence as
        // per rfc4122, sec. 4.1.5
        for (i = 0; i < 36; i++) {
            if (!uuid[i]) {
                r = 0 | Math.random()*16;
                uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
            }
        }
    }

    return uuid.join('');
}
function showOnlineNum(onlinenum) {
    $("#onlinenum").text(onlinenum);
    $("#allnum").text($("#list li").length);     //获取在线人数
}
function showOffline(offuser){
    $("#liit"+escapeJquery(offuser)).addClass("graydown");
    if(!$("#liit"+escapeJquery(offuser)).children("a").hasClass("adminclr")){//不是管理员置在最下方
        $("#liit"+escapeJquery(offuser)).insertAfter("#list li:last");
    }
}

function addChat(user){
    var sendto = $("#sendto");
    var receive = sendto.text() == "全体成员" ? "" : sendto.text() + ",";
    if(receive.indexOf(user) == -1){    //排除重复
        sendto.text(receive + user);
    }
}

function clearConsole(secretId){
    if(secretId !=null){
        $("#chat-"+escapeJquery(secretId)).html("");
    }else{
        $("#chat").html("");
    }
}

function appendZero(s){return ("00"+ s).substr((s+"").length);}  //补0函数

function getDateFull(){
    var date = new Date();
    var currentdate = date.getFullYear() + "-" + appendZero(date.getMonth() + 1) + "-" + appendZero(date.getDate()) + " " +
        appendZero(date.getHours()) + ":" + appendZero(date.getMinutes()) + ":" + appendZero(date.getSeconds());
    return currentdate;
}
function getHtml(secretid){
    var secretHtml =
        '<div id="htmksecret-'+secretid+'" class="hidectrl"><header class="am-topbar am-topbar-inverse admin-header" style="background-color: #0088cc;">' +
        '    <div class="am-topbar-brand">' +
        '        <i class="am-icon-chevron-left" onclick="backChatroom(\''+secretid+'\')"></i>&nbsp;&nbsp;<span id="clse-'+secretid+'">'+'与'+secretid+"私聊"+'</span>' +
        '    </div>' +
        '</header>' +
        '<div class="am-scrollable-vertical" id="chat-view-'+secretid+'" style="height:'+$("#chat-view").css("height")+';resize:none;overflow-x: hidden;">' +
        '<ul class="am-comments-list am-comments-list-flip" id="chat-'+secretid+'">' +
        '</ul>' +
        '             </div></div>';
    return secretHtml;
}
function fileInportsecret(tsecretid) {
    temsecretid = tsecretid;
    fileInport();
}
function backChatroom(secretid){
    $("#secretaddhtml").hide();
    $("#htmksecret-"+escapeJquery(secretid)).hide();
    temsecretid = "";
}
function closeConnection(){
    if(ws != null){
        ws.close();
        ws = null;
        $("#list").html("");    //清空在线列表
        layer.msg("已经关闭连接", { offset: 0});
    }else{
        layer.msg("未开启连接", { offset: 0, shift: 6 });
    }
}
function escapeJquery(srcString) {
    // 转义之后的结果
    var escapseResult = srcString;

    // javascript正则表达式中的特殊字符
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
        "]", "|", "{", "}"];

    // jquery中的特殊字符,不是正则表达式中的特殊字符
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
        ":", ";", "<", ">", ",", "/"];

    for (var i = 0; i < jsSpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp("\\"
            + jsSpecialChars[i], "g"), "\\"
            + jsSpecialChars[i]);
    }

    for (var i = 0; i < jquerySpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
            "g"), "\\" + jquerySpecialChars[i]);
    }

    return escapseResult;
}
function backChatList() {
    closeConnection();
    window.location='/unchk/first';
}