$(document).ready(function () {
    /**
     * 获取当前rul，并取出空格
     * @type {*}
     */
    var $url = $.trim($("#url").val());

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
    function toFilmPage(num) {
        $.ajax({
            url:$url+"film",
            data:{"pageName":num},
            type:"GET",
            success:function (result) {
                renderTemplate(result.map.pageInfo.list,$("#film-template"),$("#film_list"));
                renderTemplate(result.map.pageInfo,$("#film-pageCode-template"),$("#film-page-list"));
                $("#table_film_list").addClass("table-condensed")

                if(result.map.pageInfo.hasPreviousPage==false){
                    $("[class='pre filmPage']").parent().addClass("disabled");
                    $("[class='first filmPage']").parent().addClass("disabled");
                }else if(result.map.pageInfo.hasNextPage==false){
                    $("[class='next filmPage']").parent().addClass("disabled");
                    $("[class='end filmPage']").parent().addClass("disabled");
                }
            }
        })
    }

    /**
     * 给页码添加跳转页面的事件
     */
    $(document).on("click",".filmPage",function () {
        //获取当前组件中的page属性
        var $page = $(this).attr("page");
        //转到指定页面
        toFilmPage($page);
    })


    /**
     * 将数据库中的language取出，放入到指定的select标签中
     * @param position   坐标
     * @param languageId 当前默认的language
     */
    function insertLanguage(position,languageId) {

        $.ajax({
            url:$url+"language",
            type:"GET",
            success:function (result) {
                if (result.code==100){
                    result.map.languageId = languageId;
                    renderTemplate(result,$("#language_add_film-template"),position)
                }
            }
        })
    }


    /****************新增Film*********************************
     *
     */
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
     * 给添加按钮绑定事件，显示添加film页面
     */
    $("#add_film_btn").click(function () {
        //显示页面
        $("#film_list_div").css("display","none");
        $("#film_add_div").css("display","block");

        //清楚数据
        reset_form($("#add_film_form"))

        //将数据库中的language放入到select
        insertLanguage($("#language_select"),0)


    })

    /**
     *点击退出添加film页面
     */
    $("#cancel_add_film_btn").click(function () {
        $("#film_add_div").css("display","none");
        $("#film_list_div").css("display","block");
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

    //前端验证


    /**
     * 对title进行格式校验，格式通过后再进行重复校验
     */
    $("#title").blur(function () {
        var $this = $(this)
        var $title = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();

        var reg = /[A-Za-z0-9]{3,16}$/;

        //格式校验
        if(reg.test($title)){

            //对firstName进行重复校验
            $.ajax({
                url:$url+"filmExist/"+$this.val(),
                type:"GET",
                success:function (result) {
                    if (result.code==100){
                        cleanStatus($parent,$next)
                        $parent.addClass("has-success");
                        $next.html("电影名可用");
                        $this.attr("add_validate","success");
                    }else{
                        cleanStatus($parent,$next)
                        $parent.addClass("has-error");
                        $next.html("电影名已存在");
                        $this.attr("add_validate","error");
                    }
                }
            })

        }else{
            cleanStatus($parent,$next)
            $parent.addClass("has-error");
            $next.html("电影名必须3-16位数字或字母");
            $this.attr("add_validate","error");
        }


    })

    /**
     * 对description进行格式校验，该校验和编辑共用
     */
    $(document).on("blur",".film_description",function () {
        var $this = $(this)
        var $lastName = $.trim($(this).val());
        //获取当前元素的父节点
        var $parent = $(this).parent();
        //获取当前元素的下一个兄弟节点
        var $next = $(this).next();
        var reg = /^[A-Za-z0-9\s]{5,300}$/;
        if(reg.test($lastName)){
            cleanStatus($parent,$next)
            $parent.addClass("has-success");
            $this.attr("add_validate","success");
        }else{
            cleanStatus($parent,$next)
            $parent.addClass("has-error");
            $next.html("描述必须5-300个字母或数字");
            $this.attr("add_validate","error");
        }
    })


    /**
     * 确认添加film按钮，首先检查字段校验是否通过，
     * 若通过则添加成功，并返回到最后一页
     */
    $("#add_film_submit_btn").click(function () {
        var $title = $("#title").attr("add_validate")
        var $description = $("#description").attr("add_validate")
        if($title == 'success' && $description=='success'){
            $.ajax({
                url:$url+"film",
                type:"POST",
                data:$("#add_film_form").serialize(),
                success:function (result) {
                    if (result.code==100){
                        alert("添加成功")
                        //跳转到最后一页
                        toFilmPage(999999);
                        //回到list页面
                        $("#film_add_div").css("display","none");
                        $("#film_list_div").css("display","block");
                    }else{
                        alert("添加失败")
                    }
                }
            })


        }
    })


    /**
     ***************************************编辑film**********************
     */

    /**
     * 点击显示编辑页面，并将该film展示到页面方便修改
     */
    $(document).on("click",".edit_film",function () {
        var $filmId = $(this).attr("filmId")
        $.ajax({
            url:$url+"film/"+$filmId,
            type:"GET",
            success:function (result) {

                if (result.code==100){
                    //将编辑信息展示到编辑表单中
                    renderTemplate(result.map.film,$("#eidt_film_template"),$("#edit_film_form"))
                    //添加film的language信息
                    insertLanguage($("#edit_film_select"),result.map.film.languageId)
                }else{
                    alert("获取信息失败")
                }

            }

        })
        $('#eidt_film_Modal').modal("show")
    })

    /**
     * 点击进行修改操作，先进行字段校验，校验通过后，
     * 向后端请求修改信息
     */
    $(document).on("click","#edit_save_film_btn",function () {
        var $description = $("#edit_description").attr("add_validate")
        var $filmId = $("#edit_film_id").val();
        //判断是否验证成功
        if ($description=='success'){
            $.ajax({
                url:$url+"film/"+$filmId,
                type:"PUT",
                data:$("#edit_film_form").serialize(),
                success:function (result) {

                    if (result.code==100){
                        $("#eidt_film_Modal").modal("hide");
                        toFilmPage($("#film_save_cur_page").attr("curPage"));

                    }else{
                        //返回错误信息
                        if(result.map.errors.description!=undefined){

                            cleanStatus($("#edit_last_name").parent(),$("#edit_last_name").next())
                            $("#edit_last_name").parent().addClass("has-error");
                            $("#edit_last_name").next().html(result.map.errors.lastName);
                            $("#edit_last_name").attr("add_validate","error");

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
     ***************************************删除film**********************
     */

    /**
     * 删除单个film
     */
    $(document).on("click",".delete_film",function (){
        var $filmId = $(this).attr("customerId");
        var $filmTitle = $(this).attr("title")
        var $pageName = $("#film_save_cur_page").attr("curPage")
        if(confirm("是否删除"+$filmTitle+"?")){
            $.ajax({
                url: $url + "film/" + $filmId,
                type: "DELETE",
                success: function (result) {

                    if (result.code == 100) {
                        alert("删除成功");
                        toFilmPage($pageName)
                    } else {
                        alert("删除失败");
                    }
                }
            })

        }else {
            return false;
        }





    })


    /**
     * 批量删除时，全选点击后，当前页面中所有film选中
     */
    $("#select_all_film").click(function () {
        // alert($(this).prop("checked"))
        if($(this).prop("checked")){
            $(".select_one_film").prop("checked",true);
        }else{
            $(".select_one_film").prop("checked",false);
        }
    })

    /**
     * 批量删除时，当前film全选时，全选框为选择状态
     */
    $(document).on("change",".select_one_film",function () {
        //$(".check:checked") 为选取类为check，且被选取的组件
        if ($(".select_one_film:checked").length==10){
            $("#select_all_film").prop("checked",true);
        }else {
            $("#select_all_film").prop("checked",false);
        }
    })

    /**
     * 批量删除，获取所有选中的film，拼装id后，请求后台删除
     */
    $("#delete_film_btn").click(function () {

        var $filmId = "";
        var $title = "";

        $(".select_one_film:checked").each(function () {
            $filmId+=($(this).attr("filmId")+"-");
            $title+=($(this).attr("title")+",");
        })

        var ids = $filmId.substring(0,$filmId.length-1);
        var names = $title.substring(0,$title.length-1);

        if(names==null || names==""){
            alert("请选择你要删除的film")
            return false
        }

        if (confirm("确定删除["+names+"]?")){

            $.ajax({
                url:$url+"film/"+ids,
                type:"DELETE",
                success:function (result) {

                    if (result.code ==100) {
                        alert("成功删除id为"+result.map.ids+"的film!")
                        toFilmPage($("#film_save_cur_page").attr("curPage"));
                    }else {
                        alert("删除失败");
                    }
                }


            })
        }


    })



    /**
     * 主菜单切换到电影
     */
    $(document).on("click","#film_menu",function () {
        $("#customer_add_div").css("display","none");
        $("#film_add_div").css("display","none");
        $("#customer_list_div").css("display","none");
        // 进入首页
        toFilmPage(1);
        $("#film_list_div").css("display","block");
    })
})