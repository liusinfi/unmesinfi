<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<div id="phonechatHistDiv">
    <header class="am-topbar am-topbar-inverse admin-header">
        <div class="am-topbar-brand">
            <i class="am-icon-chevron-left" onclick="$('#phonechatHistDiv').hide();"></i>&nbsp;&nbsp;<span>聊天记录</span>
        </div>
    </header>
    <div class="am-scrollable-vertical" id="his-chat-view" style="height: ${chathei4}px; resize:none;margin-left: 6px;">
        <ul class="am-comments-list am-comments-list-flip" id="his-chat">
        </ul>
    </div>
    <div class="am-cf" style="font-size: 1.3rem;">
        <div class="am-fr">
            <ul class="am-pagination" style="margin: 0rem 0;" id="pageinfo">

            </ul>
        </div>
    </div>
</div>
<style>
    #phonechatHistDiv {
        position: absolute;
        z-index: 1002;
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
    $(function () {
        $("#his-chat-view").css("height",(Number('${chathei5}') -50) +"px")
    });

    function showHistoryHE(roomId,pageNum) {
        $("#phonechatHistDiv").show();
        hisPage(roomId,pageNum);
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
                    $("#phonechatHistDiv").show();
                }else{
                    layer.msg("当前没有聊天记录!", {
                        offset: 0,
                        shift: 10
                    });
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
        if (message.type != "message") {      //会话消息
            return;
        }
        message = message.message;
        if (!(message.to == null || message.to == "")) {
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
        if (isExists) {
            var imgId = "I" + uuid(8, 16);
            contentsh = "<img id=\"" + imgId + "\" src=\"" + contentsh + "\" alt=\"\"  style=\"background-size: 'cover';width: 35%;height:35%;\">";
        }
        if (contentsh.match(/{emoji_[0-9]*}+/g) != null && contentsh.match(/{emoji_[0-9]*}+/g).length > 0) {
            var spl = contentsh.match(/{emoji_[0-9]*}+/g);
            for (var i = 0; i < spl.length; i++) {
                var ill = spl[i].replace("{", "").replace("}", "");
                contentsh = contentsh.replace(spl[i], "<img src=\"/static/source/emoji/" + ill + ".png\" width='32' height='32'>");
            }
        }

        var spanId = "S" + uuid(8, 16);
        var html = "<li class=\"am-comment\"><div style='line-height: 1.6rem;margin-bottom: .8rem;color: #0000ff;'>" + message.from + "&nbsp;&nbsp;<time>" + message.time + "</time></div>" +
            "<div  style=\"word-wrap:break-word;word-break:break-all;\"><span id=\"" + spanId + "\"> " + contentsh + "</span></div></li>";
        $("#his-chat").append(html);
        var fontType = message.fonttype;
        if (fontType != null && fontType != "" && fontType != undefined && fontType != "undefined") {
            $("#" + spanId).css("color", fontType.color);
            $("#" + spanId).css("font-family", fontType.font_family);
            $("#" + spanId).css("font-size", fontType.font_size);
            $("#" + spanId).css("font-weight", fontType.font_weight);
            $("#" + spanId).css("text-decoration", fontType.text_decoration);
            $("#" + spanId).css("font-style", fontType.font_style);
        }
    }
</script>
</body>
</html>
