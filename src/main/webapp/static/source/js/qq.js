var PCindex=0;//默认左侧打开的是第一个窗口
var websocket = null;
//判断当前浏览器是否支持WebSocket
if ('WebSocket' in window) {
    websocket = new WebSocket("ws://localhost:8080/chatServer/10");
}
else {
    alerrt('当前浏览器 Not support websocket')
}

//连接发生错误的回调方法
websocket.onerror = function () {
    /*setMessageInnerHTML("WebSocket连接发生错误");*/
};

//连接成功建立的回调方法
websocket.onopen = function () {
    /*setMessageInnerHTML("WebSocket连接成功");*/
}

//接收到消息的回调方法
websocket.onmessage = function (event) {
    setMessageInnerHTML(event.data);
}

//连接关闭的回调方法
websocket.onclose = function () {
    /*setMessageInnerHTML("WebSocket连接关闭");*/
}

//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
window.onbeforeunload = function () {
    closeWebSocket();
}
var ipt="";
//将消息显示在网页上
function setMessageInnerHTML(innerHTML) {
    var re = /^[0-9]+.?[0-9]*$/;
    var numif="";
    var stringNum = innerHTML.split(",");
    var intername=$(".qqBox .context .conLeft ul li .liRight .intername");
    var ppppp=null;
    if(intername.length==0){

        if (re.test(stringNum[0])) {
            $("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' /><img class=Expr src=../arclist/"+stringNum[0]+".gif /></div></li></div>").appendTo("#PCContent");
            $("<li class=bg><div class=liLeft><img src=../arclist/tx.png /></div><div class=liRight><span class=intername>"+stringNum[2]+"</span><span class=badge>0</span><span class=infor >[图片]</span><input type=hidden value="+stringNum[1]+" /></div></li>").appendTo("#liContent");
        }else{
            $("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' /><span>"+stringNum[0]+"</span></div></li></div>").appendTo("#PCContent");
            $("<li class=bg><div class=liLeft><img src=../arclist/tx.png /></div><div class=liRight><span class=intername>"+stringNum[2]+"</span><span class=badge>0</span><span class=infor >"+stringNum[0]+"</span><input type=hidden value="+stringNum[1]+" /></div></li>").appendTo("#liContent");
        }
        $("<div class=headName>"+stringNum[2]+"</div>").appendTo("#name");
        $("#PCContent>div")[0].showNum=1;
        $("#liContent li")[0].children[1].children[1].innerHTML=$("#PCContent>div")[0].showNum;
        showNum();
        $("#PCContent>div").css("display","none");
    }else{
        for (let i=0;i<intername.length;i++){
            if(intername[i].innerHTML==stringNum[2]){
                if (re.test(stringNum[0])) {
                    $("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' /><img class=Expr src=../arclist/"+stringNum[0]+".gif /></div></li></div>").appendTo($($("#PCContent>div")[i]));
                }else{
                    $("<li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' /><span>"+stringNum[0]+"</span></div></li>").appendTo($($("#PCContent>div")[i]));
                    $("#liContent li")[i].children[1].children[2].innerHTML=$("#PCContent>div")[i].lastChild.children[1].children[1].innerHTML;
                }
                $("#PCContent>div")[i].showNum+=1;
                $("#liContent li")[i].children[1].children[1].innerHTML=$("#PCContent>div")[i].showNum;

                showNum();
                //document.getElementById("contentUpdate").innerHTML=stringNum[0];
                numif=1;
            }
        }
        if(numif!=1){
            /*$("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' />"+stringNum[0]+"</div></li></div>").appendTo("#PCContent");
            $("<li><div class=liLeft><img src=../arclist/tx.png /></div><div class=liRight><span class=intername>"+stringNum[2]+"</span><span class=badge>0</span><span class=infor id=contentUpdate>"+stringNum[0]+"</span><input type=hidden value="+stringNum[1]+" /></div></li>").appendTo("#liContent");*/
            if (!re.test(stringNum[1])) {
                $("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' /><img class=Expr src=../arclist/"+stringNum[0]+".gif /></div></li></div>").appendTo("#PCContent");
                $("<li class=bg><div class=liLeft><img src=../arclist/tx.png /></div><div class=liRight><span class=intername>"+stringNum[2]+"</span><span class=badge>0</span><span class=infor >[图片]</span><input type=hidden value="+stringNum[1]+" /></div></li>").appendTo("#liContent");
            }else{
                $("<div><li><div class=answerHead><img src='../arclist/tx.png' /></div><div class=answers><img class=jiao src='../arclist/jiao.jpg' />"+stringNum[0]+"</div></li></div>").appendTo("#PCContent");
                $("<li class=bg><div class=liLeft><img src=../arclist/tx.png /></div><div class=liRight><span class=intername>"+stringNum[2]+"</span><span class=badge>0</span><span class=infor >"+stringNum[0]+"</span><input type=hidden value="+stringNum[1]+" /></div></li>").appendTo("#liContent");
            }
            $("#PCContent>div")[$("#PCContent>div").length-1].showNum=1;
            $("#liContent li")[$("#PCContent>div").length-1].children[1].children[1].innerHTML=$("#PCContent>div")[$("#PCContent>div").length-1].showNum;
            showNum();
            $("#PCContent>div").css("display","none");
        }
    }

    /*document.getElementById('PCContent').innerHTML += innerHTML + '<br/>';*/

    $('.conLeft li').on('click',function(){
        $(this).addClass('bg').siblings().removeClass('bg');
        var intername=$(this).children('.liRight').children('.intername').text();
        $('.headName').text(intername);
        ipt=$(this).children('.liRight').children('input').val();
        //$('.newsList').html('');
        PCindex=$(this).index();
        $($("#PCContent>div")[PCindex])[0].showNum=0;
        console.log($($("#PCContent>div")[PCindex])[0].showNum);
        $($("#PCContent>div")[PCindex]).css("display","block").siblings().css("display","none");
        showNum();
        $("#liContent li")[PCindex].children[1].children[1].style.display="none";
    });
}
function showNum(){
    for (let i=0;i<$("#liContent li").length;i++){
        if ($($("#PCContent>div")[i])[0].showNum==0){
            console.log($($("#PCContent>div")[i])[0].showNum);
            $("#liContent li")[i].children[1].children[1].style.display="none";
        }else {
            console.log($($("#PCContent>div")[i])[0].showNum);
            $("#liContent li")[i].children[1].children[1].style.display="block";
        }
    }
}

//关闭WebSocket连接
function closeWebSocket() {
    websocket.close();
}

/* $('.conLeft li').on('click',function(){
     $(this).addClass('bg').siblings().removeClass('bg');
     var intername=$(this).children('.liRight').children('.intername').text();
     $('.headName').text(intername);
     //$('.newsList').html('');
 });*/


/*$('.sendBtn').on('click',function(){
    var news=$('#dope').val();
    if(!news){
        alert('不能为空');
    }else{
        $('#dope').val('');
        var str='';
        str+='<li>'+
            '<div class="nesHead"><img src="../arclist/logo.png"/></div>'+
            '<div class="news"><img class="jiao" src="../arclist/jiao.jpg"><span>'+news+'</span></div>'+
            '</li>';
        $($('.newsList>div')[PCindex]).append(str);
        //setTimeout(answers,1000);
        $('.conLeft').find('li.bg').children('.liRight').children('.infor').text(news);
        $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
        longLong();
        websocket.send(news+","+ipt);
    }
});*/
var isSend=false;
$(document).keydown(function(event){
    if (event.keyCode==13&&isSend){
        var news=$('#dope').val();
        console.log(news);
        if(!news){
            alert('不能为空');
        }else{
            $('#dope').val('');
            var str='';
            str+='<li>'+
                '<div class="nesHead"><img src="../arclist/logo.png"/></div>'+
                '<div class="news"><img class="jiao" src="../arclist/jiao.jpg"><span>'+news+'</span></div>'+
                '</li>';
            $($('.newsList>div')[PCindex]).append(str);
            $('.conLeft').find('li.bg').children('.liRight').children('.infor').text(news);
            $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
            longLong();
            websocket.send(news+","+ipt);
        }
        isSend=false;
    }
});
$(document).keyup(function(event){
    if (event.keyCode==13&&!isSend){
        isSend=true;
    }
});
/*function answers(){
    var arr=["你好"];
    var aa=Math.floor((Math.random()*arr.length));
    var answer='';
    answer+='<li>'+
                '<div class="answerHead"><img src="../arclist/tx.png"/></div>'+
                '<div class="answers"><img class="jiao" src="../arclist/jiao.jpg">'+arr[aa]+'</div>'+
            '</li>';
    $('.newsList').append(answer);
    $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
}*/
/*$('.ExP').on('mouseenter',function(){
    $('.emjon').show();
})
$('.emjon').on('mouseleave',function(){
    $('.emjon').hide();
})
$('.emjon li').on('click',function(){
    var imgSrc=$(this).children('img').attr('src');
    var str="";
    str+='<li>'+
        '<div class="nesHead"><img src="../arclist/logo.png"/></div>'+
        '<div class="news"><img class="jiao" src="../arclist/jiao.jpg"><img class="Expr" src="'+imgSrc+'"></div>'+
        '</li>';
    /!*$('.newsList').append(str);*!/
    $($('.newsList>div')[PCindex]).append(str);
    $('.emjon').hide();
    $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
    longLong();
    websocket.send(imgSrc+","+ipt);
});*/
function longLong(){
    var news=document.querySelectorAll(".news");
    for (let i=0;i<news.length;i++){
        if (news[i].offsetWidth>=490){
            news[i].parentNode.style.height=news[i].offsetHeight+"px";
        }
    }
}