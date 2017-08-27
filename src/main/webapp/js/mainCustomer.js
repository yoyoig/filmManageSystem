$(document).ready(function () {
    //获取当前项目路径
    var $url = $("#url").val();

// ---------------------handlebar的自定义helper
    //得到上一页的页码
    Handlebars.registerHelper("pre",function (value) {
        if(value>1){
            return value-1;
        }else {
            return 1;
        }
    })

    //得到下一页的页码
    Handlebars.registerHelper("next",function (value,value2) {
        if (value<value2) {
            return value + 1;
        }else{
            return value2;
        }
    })

    //判断该页码是否为当前页码，是则active状态
    Handlebars.registerHelper("active",function(curPage,page,options){
        if (curPage==page){
            return options.fn(this);
        }

    })

    //当address 的 id相等时，默认该option被选择
    Handlebars.registerHelper("addrSlt",function (caId,adId,options) {
        if (caId==adId){
            return options.fn(this)
        }
    })

// ----------------------------------------


    //默认进入首页
    $.ajax({
        url:$url+"customer",
        type:"GET",
        data:{"pageName":1},
        success:function (result) {
            renderTemplate(result.map.pageInfo.list,$("#customer-template"),$("#customer_list"))
            renderTemplate(result.map.pageInfo,$("#pageCode-template"),$("#page-list"));
        }
    })

    //将数据注入到模板中，并将模板展示到指定的容器
    function  renderTemplate(result,content,position) {
        var t = content.html();
        var f = Handlebars.compile(t);
        var h = f(result);
        position.empty();
        position.html(h);
    }

    //指定到某页
    function toPage(num) {
        $.ajax({
            url:$url+"customer",
            data:{"pageName":num},
            type:"GET",
            success:function (result) {
                renderTemplate(result.map.pageInfo.list,$("#customer-template"),$("#customer_list"));
                renderTemplate(result.map.pageInfo,$("#pageCode-template"),$("#page-list"));
                //进行页面判断，若当前页为首页则首页和上一页失效，减少无用的请求和操作

            }
        })
    }

    // 给页码添加点击事件
    $(document).on("click",".page",function () {
        //获取当前组件中的page属性
        var $page = $(this).attr("page");
        //转到指定页面
        toPage($page);
    })


    //*******************************************新增功能js*******************************************

    //用于清楚表单的状态信息和表单中的信息
    function reset_form(ele) {
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").html("");

    }

    //新增按钮点击进入新增页面
    $("#add_customer_btn").click(function () {
        $("#customer_list_div").css("display","none");
        $("#customer_add_div").css("display","block");

        reset_form($("#add_customer_form"))

        // 进入新增页面时，将数据库中的address信息放入select中
        insertAddress($("#address_select"),null);
    })

    //将查询的地址放入到指定的位置中，
    function insertAddress(position,addrId) {

        $.ajax({
            url:$url+"address",
            type:"GET",
            success:function (result) {
                if (result.code==100){
                    result.map.addrId = addrId;
                    renderTemplate(result,$("#address_add_customer-template"),position)
                }
            }
        })
    }


    //取消新增按钮返回主页面
    $("#cancel_add_btn").click(function () {
        $("#customer_add_div").css("display","none");
        $("#customer_list_div").css("display","block");
    })
    //用于清楚验证状态
    function cleanStatus(parent,next) {
        parent.removeClass("has-success has-error");
        next.html("");
    }

    //新增数据前端校验
    //firstName 和 lastName 不能为空
    $("#first_name").blur(function () {
        var $this = $(this)
        var $firstName = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();

        var reg = /^[a-z0-9]{3,16}$/;
        if(reg.test($firstName)){

            //对firstName进行重复校验
            $.ajax({
                url:$url+"customerLogin",
                type:"POST",
                data:{"firstName":$firstName},
                success:function (result) {
                    if (result.code==100){
                        cleanStatus($parent,$next)
                        $parent.addClass("has-error");
                        $next.html("用户名已存在");
                        $this.attr("add_validate","error");
                    }else{
                        cleanStatus($parent,$next)
                        $parent.addClass("has-success");
                        $next.html("用户名可用");
                        $this.attr("add_validate","success");
                    }
                }
            })

        }else{
            cleanStatus($parent,$next)
            $parent.addClass("has-error");
            $next.html("用户名必须3-16位数字或字母");
            $this.attr("add_validate","error");




        }

    })

    //该验证和编辑共用

    $(document).on("blur",".customer_last_name",function () {
        var $this = $(this)
        var $lastName = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();
        var reg = /^[a-z0-9]{3,16}$/;
        if(reg.test($lastName)){
            cleanStatus($parent,$next)
            $parent.addClass("has-success");
            $this.attr("add_validate","success");
        }else{
            cleanStatus($parent,$next)
            $parent.addClass("has-error");
            $next.html("用户名必须3-16位数字或字母");
            $this.attr("add_validate","error");
        }
    })


    //可以为空，但不为空时格式不能错误
    //该验证和编辑共用
    $(document).on("blur",".customer_email",function () {
        var $this = $(this)
        var $email = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();
        if ($email!=null && $email!=""){
            var rep = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(rep.test($email)){
                cleanStatus($parent,$next)
                $parent.addClass("has-success");
                $this.attr("add_validate","success");
            }else{
                cleanStatus($parent,$next)
                $parent.addClass("has-error");
                $next.html("请输入正确的邮箱格式");
                $this.attr("add_validate","error");
            }
        }else{
            cleanStatus($parent,$next)
            $this.attr("add_validate","success");
        }
    })



    //添加按钮，点击请求后台添加该数据，并返回到最后一页
    $("#add_customer_submit_btn").click(function () {
        var $firstName = $("#first_name").attr("add_validate")
        var $lastName = $("#last_name").attr("add_validate")
        if($firstName == 'success' && $lastName=='success'){

            $.ajax({
                url:$url+"customer",
                type:"POST",
                data:$("#add_customer_form").serialize(),
                success:function (result) {
                    if (result.code==100){
                        alert("添加成功")
                        //跳转到最后一页
                        toPage(999999);
                        //回到list页面
                        $("#customer_add_div").css("display","none");
                        $("#customer_list_div").css("display","block");
                    }else{
                        alert("添加失败")
                    }
                }
            })


        }


    })

    //***************************编辑customer*******************************************


    //给编辑按钮添加事件，通过id返回编辑区用户信息
    $(document).on("click",".edit",function () {
        var $customerId = $(this).attr("customerId")
        $.ajax({
            url:$url+"customer/"+$customerId,
            type:"GET",
            success:function (result) {

                if (result.code==100){

                    renderTemplate(result.map.customer,$("#eidt_customer_template"),$("#edit_form"))
                    insertAddress($("#edit_select"),result.map.customer.addressId)
                }else{
                    alert("获取信息失败")
                }

            }

        })


        $('#eidt_Customer_Modal').modal("show")
    })

    $(document).on("click","#edit_save_btn",function () {
        var $lastName = $("#edit_last_name").attr("add_validate")
        var $email = $("#edit_InputEmail").attr("add_validate")
        var $customerId = $("#edit_customer_id").val();
        //判断是否验证成功
       if ($lastName=='success' && $email=='success'){
            $.ajax({
                url:$url+"customer/"+$customerId,
                type:"PUT",
                data:$("#edit_form").serialize(),
                success:function (result) {

                    if (result.code==100){
                        $("#editEmpModal").modal("hide");
                        toPage($("#save_cur_page").attr("curPage"));

                    }else{
                        //返回错误信息
                        if(result.map.errors.lastName!=undefined){

                            cleanStatus($("#edit_last_name").parent(),$("#edit_last_name").next())
                            $("#edit_last_name").parent().addClass("has-error");
                            $("#edit_last_name").next().html(result.map.errors.lastName);
                            $("#edit_last_name").attr("add_validate","error");

                        }else if (result.map.errors.email !=undefined){

                            cleanStatus($("#edit_InputEmail").parent(),$("#edit_InputEmail").next())
                            $("#edit_InputEmail").parent().addClass("has-error");
                            $("#edit_InputEmail").next().html(result.map.errors.email);
                            $("#edit_InputEmail").attr("add_validate","error");

                        }else if(result.map.error == 1){
                            alert("编辑失败")
                        }
                    }

                }

            })

       }else{
           return false
       }
    })


})