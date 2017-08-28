$(document).ready(function () {
    /**
     * 获取当前rul，并取出空格
     * @type {*}
     */
    var $url = $.trim($("#url").val());

    /**
     * 全局变量，存放查询条件
     */
    var $eaxmple;

    $("#select_customer_btn").click(function () {
        $eaxmple = $("#customer_example").serialize();
        toPage(1);
    })

    insertAddressExample($("#select_example"))

    function insertAddressExample(position) {

        $.ajax({
            url:$url+"address",
            type:"GET",
            success:function (result) {
                if (result.code==100){
                    console.log(result)
                    renderTemplate(result.map.addressList,$("#address_add_customer_example-template"),position)
                }
            }
        })
    }

    /**
     * ---------------------handlebar的自定义helper
      */

    /**
     * 返回上一页页码
     */
    Handlebars.registerHelper("pre",function (value) {
        if(value>1){
            return value-1;
        }else {
            return 1;
        }
    })

    /**
     * 返回下一页页码
     */
    Handlebars.registerHelper("next",function (value,value2) {
        if (value<value2) {
            return value + 1;
        }else{
            return value2;
        }
    })


    /**
     * 判断该页码是否为当前页码，是则为选中状态
     */
    Handlebars.registerHelper("active",function(curPage,page,options){
        if (curPage==page){
            return options.fn(this);
        }

    })


    /**
     * 判断customer的address是否匹配，匹配则当前addres为选中状态
     */
    Handlebars.registerHelper("addrSlt",function (caId,adId,options) {
        if (caId==adId){
            return options.fn(this)
        }
    })

    Handlebars.registerHelper("isFilm",function (value,options) {
        if (value=="filmPage"){
            options.inverse()
        }else {
            options.fn(this)
        }
    })

// ----------------------------------------


    /**
     * 访问时默认进入首页
     */
    toPage(1);

    /**
     * 将数据填充到制定模板，并将模板放入指定位置
     * @param result  数据
     * @param content 模板
     * @param position 坐标
     */
    function  renderTemplate(result,content,position) {
        var t = content.html();
        var f = Handlebars.compile(t);
        var h = f(result);
        position.empty();
        position.html(h);
    }

    /**
     * 进入到指定的页码页面
     * @param num 页码
     */
    function toPage(num) {
        $.ajax({
            // url:$url+"customer",
            // data:{"pageName":num},

            //根据条件查询
            url:$url+"customerByExam/"+num,
            data:$eaxmple,

            type:"GET",
            success:function (result) {
                if(result == "unlogin"){
                    window.location.href=$url+"index.jsp";
                }

                renderTemplate(result.map.pageInfo.list,$("#customer-template"),$("#customer_list"));
                renderTemplate(result.map.pageInfo,$("#pageCode-template"),$("#page-list"));

                if(result.map.pageInfo.hasPreviousPage==false){
                    $("[class='pre page']").parent().addClass("disabled");
                    $("[class='first page']").parent().addClass("disabled");
                }else if(result.map.pageInfo.hasNextPage==false){
                    $("[class='next page']").parent().addClass("disabled");
                    $("[class='end page']").parent().addClass("disabled");
                }
            }
        })
    }




    /**
     * 给页码添加跳转页面的事件
     */
    $(document).on("click",".page",function () {
        //获取当前组件中的page属性
        var $page = $(this).attr("page");
        //转到指定页面
        toPage($page);
    })


    //*******************************************新增功能js*******************************************

    /**
     * 清楚表单中的数据
     * @param ele 表单对象
     */
    function reset_form(ele) {
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").html("");

    }

    /**
     * 给添加按钮绑定事件，显示添加customer页面
     */
    $("#add_customer_btn").click(function () {
        $("#customer_list_div").css("display","none");
        $("#customer_add_div").css("display","block");

        reset_form($("#add_customer_form"))

        // 进入新增页面时，将数据库中的address信息放入select中
        insertAddress($("#address_select"),null);
    })

    /**
     * 将数据库中的address取出，放入到指定的select标签中
     * @param position   坐标
     * @param languageId 当前默认的address
     */
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


    /**
     *点击退出添加customer页面
     */
    $("#cancel_add_btn").click(function () {
        $("#customer_add_div").css("display","none");
        $("#customer_list_div").css("display","block");
    })


    /**
     * 清楚校验状态
     * @param parent 表单组件
     * @param next   提示组件
     */
    function cleanStatus(parent,next) {
        parent.removeClass("has-success has-error");
        next.html("");
    }

    /**
     * 对first_name进行格式校验，格式通过后再进行重复校验
     */
    $("#first_name").blur(function () {
        var $this = $(this)
        var $firstName = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();

        var reg = /[A-Za-z0-9]{3,16}$/;
        if(reg.test($firstName)){

            //对firstName进行重复校验
            $.ajax({
                url:$url+"customerExist/"+$firstName,
                type:"GET",
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

    /**
     * 对last_name进行格式校验，该校验和编辑共用
     */
    $(document).on("blur",".customer_last_name",function () {
        var $this = $(this)
        var $lastName = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();
        var reg = /[A-Za-z0-9]{3,16}$/;
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


    /**
     * 对email进行格式校验，该校验和编辑共用
     */
    $(document).on("blur",".customer_email",function () {
        var $this = $(this)
        var $email = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();
        if ($email!=null && $email!=""){
            var rep = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
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



    /**
     * 确认添加customer按钮，首先检查字段校验是否通过，
     * 若通过则添加成功，并返回到最后一页
     */
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


    /**
     * 点击显示编辑页面，并将customer展示到页面
     */
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

    /**
     * 点击进行修改操作，先进行字段校验，校验通过后，
     * 向后端请求修改信息
     */
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
                        $("#eidt_Customer_Modal").modal("hide");
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

    /**
     * *************************删除*******************************************
     */

    /**
     * 删除单个film
     */
    $(document).on("click",".delete",function () {
        var $customerId = $(this).attr("customerId")
        var $firstName = $(this).attr("name")
        var $pageName = $("#save_cur_page").attr("curPage")

        if (confirm("是否删除"+$firstName+"?")) {
            $.ajax({
                url: $url + "customer/" + $customerId,
                type: "DELETE",
                success: function (result) {
                    if (result.code == 100) {
                        alert("删除成功")
                        toPage($pageName)
                    } else {
                        alert("删除失败")
                    }
                }
            })
        }

    })

    /**
     * 批量删除时，全选点击后，customer
     */
    $("#select_all_customer").click(function () {
        // alert($(this).prop("checked"))
        if($(this).prop("checked")){
            $(".select_one_customer").prop("checked",true);
        }else{
            $(".select_one_customer").prop("checked",false);
        }
    })

    /**
     * 批量删除时，customer，全选框为选择状态
     */
    $(document).on("change",".select_one_customer",function () {
        //$(".check:checked") 为选取类为check，且被选取的组件
        if ($(".select_one_customer:checked").length==10){
            $("#select_all_customer").prop("checked",true);
        }else {
            $("#select_all_customer").prop("checked",false);
        }
    })

    /**
     * 批量删除，customer，拼装id后，请求后台删除
     */
    $("#delete_customer_btn").click(function () {

        var $customerId = "";
        var $firstName = "";

        $(".select_one_customer:checked").each(function () {
            $customerId+=($(this).attr("customerId")+"-");
            $firstName+=($(this).attr("firstName")+",");
        })

        var ids = $customerId.substring(0,$customerId.length-1);
        var names = $firstName.substring(0,$firstName.length-1);

        if(names==null || names==""){
            alert("请选择你要删除的customer")
            return false
        }

        if (confirm("确定删除["+names+"]?")){

            $.ajax({
                url:$url+"customer/"+ids,
                type:"DELETE",
                success:function (result) {

                    if (result.code ==100) {
                        alert("成功删除id为"+result.map.ids+"的customer!")
                        toPage($("#save_cur_page").attr("curPage"));
                    }else {
                        alert("删除失败");
                    }
                }


            })
        }


    })


    /**
     * 主菜单切换到customer
     */
    $(document).on("click","#customer_menu",function () {
        $("#film_list_div").css("display","none");
        $("#customer_add_div").css("display","none");
        $("#film_add_div").css("display","none");
        toPage(1)
        $("#customer_list_div").css("display","block");
    })


    /**
     * 用户退出
     */
    $("#logout").click(function () {

        if (confirm("是否退出登录？")) {

            $.ajax({
                url: $url + "customerLogout",
                type: "GET",
                success: function (result) {
                    if (result.code == 100) {
                        alert("退出成功")
                        window.location.href=$url+'index.jsp';
                    }
                }
            })
        }else{
            return false;
        }

    })


})