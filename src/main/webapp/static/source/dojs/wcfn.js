function ReWritable() {
    var tbmian=document.getElementById("tbmain");
    for(var i=0;i<tbmain.rows.length;i++) {
        for(var j=0;j<tbmain.rows[i].cells.length;j++) {
            tbmain.rows[i].cells[j].onclick=AddObjOfText;
        }
    }

    var ctcolor=document.getElementById("CT");
    for(var i=0;i<ctcolor.rows.length;i++) {
        for(var j=0;j<ctcolor.rows[i].cells.length;j++) {
            ctcolor.rows[i].cells[j].onclick=colorToText;
            ctcolor.rows[i].cells[j].onmouseover=colorMouseOver;
        }
    }
}
function colorToText(){
    $("#colorpanel").hide();
    var tmsek = "#message";
    if(temsecretid != null && temsecretid!=""){
        var xcontent = $("#"+"contentdiv"+escapeJquery(temsecretid));
        if(xcontent.length>0 && !xcontent.is(":hidden")){
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
    //alert(this.style.backgroundColor);
}
function AddObjOfText(){
    var innhtml = this.innerHTML;
    var i = innhtml.lastIndexOf("/");
    var df = innhtml.substring(i+1,innhtml.length-6);
    var tmsek = "#message";
    if(temsecretid != null && temsecretid!=""){
        var xcontent = $("#"+"contentdiv"+escapeJquery(temsecretid));
        if(xcontent.length>0 && !xcontent.is(":hidden")){
            tmsek = tmsek + "-" + escapeJquery(temsecretid);
        }
    }
    $(tmsek).append("{"+df+"}");
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
function changeEnterEvent() {
    //绑定键盘事件
    $("#message").keypress(function(e){
        var selectval = $("#enterselect").val();
        var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
        if (selectval=="b" ){
            if (e.ctrlKey && eCode == 13 && browserTp()=="FF"){
                sendMessage(null,secretid);
            }else if (e.ctrlKey && eCode == 10 && (browserTp()=="Chrome" || browserTp()=="IE")){
                sendMessage(null,secretid);
            }
        }else if(selectval=="a" ){
            if(eCode == 13 && !e.ctrlKey){
                e.preventDefault();
                sendMessage();
            }
        }
    });
}
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
function searchuser() {
    $("#listsearch").html("");
    $("#listsearch").hide();
    var valusk = $("#searchinput").val();
    if(valusk == null || valusk==""){
        //layer.msg("请输入名称", { offset: 0, shift: 6 });
        return;
    }
    var lis = $("#list li");var x = 0;
    for(var i=0;i<lis.length;i++){
        if(lis[i].innerText.indexOf(valusk)>=0 ){
            $("#listsearch").append("<li>"+lis[i].innerHTML+"</li>");
            x++;
        }
    }
    if(x>0){
        $("#listsearch").css("height",(document.body.clientHeight-90)+"px");
        $("#listsearch").show();
    }
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
            layer.msg("上传图片类型不正确!", { offset: 0});
            return false;
        }
        return false;
    }
}

function getConnection(){
    if(ws == null){
        ws = new WebSocket(wsServer); //创建WebSocket对象
        ws.onopen = function (evt) {
            layer.msg("成功建立连接!", { offset: 0});
        };
        ws.onmessage = function (evt) {
            analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
        };
        ws.onerror = function (evt) {
            //layer.msg("产生异常", { offset: 0});
        };
        ws.onclose = function (evt) {
            layer.msg("已经关闭连接", { offset: 0});
        };
    }else{
        layer.msg("连接已存在!", { offset: 0, shift: 6 });
    }
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

function checkConnection(){
    if(ws != null){
        layer.msg(ws.readyState == 0? "连接异常":"连接正常", { offset: 0});
    }else{
        layer.msg("连接未开启!", { offset: 0, shift: 6 });
    }
}
function getBlobBydataURI(dataURI,type) {
    var binary = atob(dataURI.split(',')[1]);
    var array = [];
    for(var i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], {type:type });
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
    var reg = new RegExp( '</br>' , "g" )
    $("#marquee").html("<li>" +msg.replace(reg,"  ") + "</li>");
    $("#marquee").marquee({
        yScroll: "bottom",
        showSpeed: 850,        // 初始下拉速度         ,
        scrollSpeed: 12,       // 滚动速度         ,
        pauseSpeed: 1000,      // 滚动完到下一条的间隔时间         ,
        pauseOnHover: true,    // 鼠标滑向文字时是否停止滚动         ,
        loop: -1 ,             // 设置循环滚动次数 （-1为无限循环）         ,
        fxEasingShow: "swing" , // 缓冲效果         ,
        fxEasingScroll: "linear",  // 缓冲效果         ,
        cssShowing: "marquee-showing"  //定义class

    });
}
function closeNoticeSound(){
    if(noticeSound){
        noticeSound = false;
        $("#closeOpenSound").html("");
        $("#closeOpenSound").html("开启提示音");
    }else{
        $("#closeOpenSound").html("");
        $("#closeOpenSound").html("关闭提示音");
        noticeSound = true;
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
        for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
        var r;
        uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
        uuid[14] = '4';
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
    var navStr = navigator.userAgent.toLowerCase();
    if(navStr.indexOf("msie 10.0")!==-1||navStr.indexOf("rv:11.0")!==-1){ // 判断是IE10或者IE11
        grayscale($("#liit"+escapeJquery(offuser)));
    }
    $("#liit"+escapeJquery(offuser)).addClass("graydown");
    //if(!$("#liit"+escapeJquery(offuser)).children("a").hasClass("adminclr")){//不是管理员置在最下方
        $("#liit"+escapeJquery(offuser)).insertAfter("#list li:last");
    //}
    //$("#liit"+escapeJquery(offuser)).insertAfter("#list li:last");
    ///$("#liit"+escapeJquery(offuser)).children().removeClass("adminclr");
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
function getHtml(secretid,heightd){
    var secretDIVID = "contentdiv"+escapeJquery(secretid);
    var contnetname = escapeJquery(secretid) + "content";
    var btngrpid = "btngrp-" + escapeJquery(secretid);
    var btnid = "btn-" + escapeJquery(secretid);
    var ulhtml = '<div class="am-btn-group" id="'+btngrpid+'">' +
        '<button type="button" id="'+btnid+'" class="am-btn am-btn-default diybtn" onclick="showSecretPage(\''+btnid+'\',\''+btngrpid+'\',\''+secretDIVID+'\')">与'+secretid+'的私聊' +
        '<span class="am-icon-close" onclick="closeSecretChat(\''+btngrpid+'\',\''+secretDIVID+'\')"></span>' +
        '</button>' +
        '                </div>';
    $("#ulsecretli").append(ulhtml);
    var secretHtml = '<div class="chatoneofuser" id="'+secretDIVID+'">' +
        '<div class="am-tab-panel" id="'+ contnetname + '">' +
        '<table>' +
        '<div class="" style="width: 99%;float:left;">' +
        '<div class="am-scrollable-vertical" id="chat-view-'+secretid+'" style="height:'+chatviewhi+'px;resize:none;">' +
        '<ul class="am-comments-list am-comments-list-flip" id="chat-'+secretid+'">' +
        '</ul>' +
        '                </div>' +
        '                <div class="chat-toolbar">' +
        '                    <a href="javascript:void(0);" class="icon-font current" onclick="showchgdailog(this,\'' + secretid +'\')">字体</a>' +
        '                    <a href="javascript:;" class="icon-emote" onclick="showchgdailog(this,\'' + secretid +'\')">表情</a>' +
        '                    <a href="javascript:void(0);" class="icon-image" onclick="fileInportsecret(\''+secretid+'\')">图片</a>' +
        '                    <div class="pull-right">' +
        //            '                        <span class="pull-right btn-history" onclick="openWin()">聊天记录</span>' +
        '                    </div>' +
        '                </div>' +
        '                <div class="am-form-group am-form">' +
        '                     <div class="dmsgcls" id="message-'+secretid+'" name="message" contenteditable="true"></div>'+
        '                </div><div style="height: 35px;background-color: #fff;">' +
        '                <div class="am-btn-group am-btn-group-xs" style="float:right;right: 23px;">' +
        '                    <button class="am-btn am-btn-default" type="button" onclick="clearConsole(\''+secretid+'\')"><span class="am-icon-trash-o"></span> 清屏</button>' +
        '                    <button class="am-btn am-btn-default" type="button" onclick="sendMessage(\'\',\''+secretid+'\')"><span class="am-icon-commenting"></span> 发送</button>' +
        '                </div></div>' +
        '            </div>' +
        //'<div class="am-panel am-panel-default" style="float:right;width: 1%; height:'+heightd+'px;"></div>' +
        '        </table>' +
        '</div></div>';
    return secretHtml;
}
function closeSecretChat(btngrpid,secretDIVID){
    $("#"+btngrpid).remove();
    $("#"+secretDIVID).remove();
}
function showSecretPage(btnid,btngrpid,secretDIVID) {
    $(".chatoneofuser").hide();
    $(".diybtn").css("background-color","#cacaca");
    $("#"+btnid).css("background-color","#ffffff");
    $("#"+secretDIVID).show();
}
function hidesecretchats() {
    $(".chatoneofuser").hide();
    $(".diybtn").css("background-color","#cacaca");
}
function fileInportsecret(tsecretid) {
    temsecretid = tsecretid;
    fileInport();
}
function browserTp(){
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera"
    }; //判断是否Opera浏览器
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //判断是否Firefox浏览器
    if (userAgent.indexOf("Chrome") > -1){
        return "Chrome";
    }
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //判断是否Safari浏览器
    if (!!window.ActiveXObject || "ActiveXObject" in window) {
        return "IE";
    }; //判断是否IE浏览器
}

function fileInport(){
    $("#filesend").click();
}

function outmodal(){
    parent.$("#doc-modal-1").modal("close");
}

function  bindPaste(bingTarget) {
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    if(userAgent.indexOf("Chrome") > -1){
        $("#"+bingTarget).on("paste", function(ev) {
            // 通过事件对象访问系统剪贴板
            var ev = ev || window.event, clipboardData = ev.clipboardData || ev.originalEvent.clipboardData,
                i = 0, items, item, files;
            if (clipboardData) {
                items = clipboardData.items;
                files = clipboardData.files;
                if (files && files.length) {
                    pasteImage(files[0],bingTarget);
                    return;
                }
                if (!items) { return; }
                for (; i < items.length; i++) {
                    if (items[i].kind === 'file' && items[i].type.match(/^image\//i)) {
                        item = items[i];
                        break;
                    }
                }
                // 如果存在图片数据
                if (item) {
                    pasteImage(item,bingTarget); // 读取该图片
                }
            }
        });
    }
}
function pasteImage(item,bingTarget) {
    var type = item.type;
    if(type && type.split('/')[0] != 'image') {
        return;
    }
    var blob = item.getAsFile ? item.getAsFile() : item, reader = new FileReader();
    var suffix = type.split('/')[1];
    var size = blob.size;
    if(size / (1024 * 1024) > 1) {
        layer.msg("发送图片大小不能超过1M", { offset: 0});
        return;
    }
    // 读取文件后将其显示在网页中
    reader.onload = function(e) {
        var node=document.createElement("img");
        node.src=e.target.result;
        node.className ="imgmsg";
        document.getElementById(bingTarget).appendChild(node);
    };
    reader.readAsDataURL(blob);
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
function showAtInfo(from,contentsh,me) {
    var flag = "L"+uuid(3,9);
    $("#atmsginf").append("<li id=\""+flag+"\" style='border: 1px solid #dedede;'>" +
        "<a href='#' onclick='addToMsgDiv(null,\""+from+"\",\""+flag+"\")'>"+from+"</a>&nbsp;:&nbsp;"+
        contentsh+"<a href='#' onclick='addToMsgDiv(null,\""+from+"\",\""+flag+"\")'>&nbsp;&nbsp;[回复]</a><a href=\"#\" class=\"am-close\" onclick=\"removeAtInf('"+flag+"')\" style='float: right;'>&times;</a>" + "</li>");
}
function removeAtInf(flag) {
    $("#"+flag).remove();
}
function showHistoryHE(roomId,pageNum) {
    if(!$(".chat_his").is(":hidden")){
        $(".chat_his").hide();
        return;
    }else{
        hisPage(roomId,1);
    }
}
function hisPage(roomId,pageNum) {
    $.ajax({
        type: "GET",
        async : false,
        data : {'roomId':roomId,'pageNum':pageNum},
        url: '/chatHistoryPage',
        success: function (data) {
            var jsonmap = eval("("+data +")");
            var Jsonchatlist= jsonmap.chatList;
            pageinfoappend(roomId,jsonmap.pageNum,jsonmap.totalPages,jsonmap.total);
            if(Jsonchatlist !=null && Jsonchatlist!='null' && Jsonchatlist.length > 0){
                $("#his-chat").html("");
                for(var key in Jsonchatlist){
                    var item = Jsonchatlist[key];
                    analysisHIS(JSON.parse(item));
                }
                $(".chat_his").show();
            }else{
                layer.msg("当前没有聊天记录!", {
                    offset: 0,
                    shift: 10
                });
                $(".chat_his").hide();
            }
        },
        error: function (error) {
            layer.msg(error, {
                offset: 0,
                shift: 10
            });
        }
    });
}
function pageinfoappend(roomid,pageNum,totalPages,total) {
    $("#pageinfo").html("");
    var totalni ="<li>共"+total+"条记录</li>";
    $("#pageinfo").append(totalni);
    var fkd = "<li><a href=\"#\""+ ((pageNum==1)?"class=\"a_disabled\"":"") + " onclick=\"hisPage('"+roomid+"','1')\">&laquo;</a></li>";
    $("#pageinfo").append(fkd);
    if(totalPages>0){
        var startIndex = totalPages-pageNum>10?pageNum-1:totalPages-10;
        var endIndex = startIndex + 10;
        for(var i=startIndex;i<endIndex;i++){
            var fkdd = "<li><a href=\"#\" onclick=\"hisPage('"+roomid+"','"+(i+1)+"')\""  ;
            if(i+1 == pageNum){
                fkdd = fkdd + "class=\"a_disabled\"";
            }
            fkdd = fkdd + ">"+(i+1)+"</a></li>";
            $("#pageinfo").append(fkdd);
        }
    }
    //var fkd3 = "<li><a href=\"#\" onclick=\"hisPage('"+roomid+"','"+pageNum+"')\">&raquo;</a></li>";
    var fkd3 = "<li><a href=\"#\""+ ((pageNum==totalPages)?"class=\"a_disabled\"":"") + " onclick=\"hisPage('"+roomid+"','"+totalPages+"')\">&raquo;</a></li>";
    $("#pageinfo").append(fkd3);
}
function analysisHIS(message) {
    if(message.type != "message"){      //会话消息
        return;
    }
    message = message.message;
    if(!(message.to == null || message.to == "")){
        return;
    }
    var contentsh = message.content;
    var array = new Array('gif', 'jpeg', 'png', 'jpg');  //可以上传的文件类型
    var lowk = contentsh.toLowerCase();
    var isExists = false;
    for (var i in array) {
        if (lowk.indexOf(array[i].toLowerCase()) > 0) {
            isExists = true;
            break;
        }

    }

    if(isExists){
        var imgId = "I"+uuid(8,16);
        contentsh = "<img id=\""+imgId+"\" src=\""+contentsh + "\" alt=\"\"  style=\"background-size: 'cover';width: 35%;height:35%;\">";
    }
    if(contentsh.match(/{emoji_[0-9]*}+/g) != null && contentsh.match(/{emoji_[0-9]*}+/g).length > 0){
        var spl = contentsh.match(/{emoji_[0-9]*}+/g);
        for(var i=0;i<spl.length;i++){
            var ill = spl[i].replace("{","").replace("}","");
            contentsh = contentsh.replace(spl[i],"<img src=\"/static/source/emoji/"+ill+".png\" width='32' height='32'>");
        }
    }

    var spanId = "S" +uuid(8,16);
    var html = "<li class=\"am-comment\"><div style='line-height: 1.6rem;margin-bottom: .8rem;color: #0000ff;'>" +message.from+"&nbsp;&nbsp;<time>"+message.time+"</time></div>" +
        "<div  style=\"word-wrap:break-word;word-break:break-all;\"><span id=\""+spanId+"\"> "+contentsh+"</span></div></li>";
    $("#his-chat").append(html);
    var fontType = message.fonttype;
    if(fontType !=null && fontType!="" && fontType!=undefined && fontType !="undefined"){
        $("#"+spanId).css("color",fontType.color);
        $("#"+spanId).css("font-family",fontType.font_family);
        $("#"+spanId).css("font-size",fontType.font_size);
        $("#"+spanId).css("font-weight",fontType.font_weight);
        $("#"+spanId).css("text-decoration",fontType.text_decoration);
        $("#"+spanId).css("font-style",fontType.font_style);
    }
}