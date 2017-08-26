$(document).ready(function () {
    //获取当前项目路径
    var $url = $("#url").val();
    //默认进入首页

    $.ajax({
        url:$url+"customer",
        type:"GET",
        data:{"pageName":1},
        success:function (result) {
            console.log(result.map.pageInfo.list[0].address);
            // console.log(result.map.list[0].address.address);
        }
        
    })

})