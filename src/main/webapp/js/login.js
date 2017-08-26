$(document).ready(function () {

    //获取当前项目的相对路径
    var $url = $("#loginForm").attr("url");

    //用户名的前端校验
    $("#inputName").blur(function () {
        var $name = $("#inputName").val();

        if ($name == null || $name== ""){
            $("#checkName").addClass("has-error");
            $("#checkName span").html("用户名不能为空");
        }else{
            $("#checkName").removeClass("has-error");
            $("#checkName span").html("");
        }
    })

    //提交表单
    $("#btn_submit").click(function () {
        var $name = $("#inputName").val();
        //再一次验证用户名
        if ($name == null || $name== ""){
            $("#checkName").addClass("has-error");
            $("#checkName span").html("用户名不能为空");
            return false;
        }

        //登录请求道后台
        $.ajax({
            url:$url+"customerLogin",
            type:"POST",
            data:$("#loginForm").serialize(),
            success:function (result) {
                if(result.code==100){
                    window.location.href=$url+"main.jsp";
                }else{
                    $("#checkName").addClass("has-error");
                    $("#checkName span").html("用户名有误");
                }
            }
        })




    })

})