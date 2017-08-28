<%--
  Created by IntelliJ IDEA.
  User: 铭刻
  Date: 2017/8/26
  Time: 18:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="<c:url value="js/jquery-3.2.1.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="js/bootstrap.min.js" />"></script>
    <script type="text/javascript" src="<c:url value="js/handlebars-v4.0.10.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="css/bootstrap.min.css" />">
    <link rel="stylesheet" href="<c:url value="css/main.css" />">
    <link rel="stylesheet" href="<c:url value="css/addCustomer.css"/>">
    <link rel="stylesheet" href="<c:url value="css/addFilm.css"/>">

    <link rel="stylesheet" href="<c:url value="css/film.css"/>">
    <script type="text/javascript" src="<c:url value="js/mainCustomer.js"/>" ></script>
    <script type="text/javascript" src="<c:url value="js/film.js"/>" ></script>
    
    <script type="text/x-handlebars-template" id="customer-template">
        {{#each this}}
            <tr>
                <td><input customerId="{{customerId}}" firstName="{{firstName}}" class="select_one_customer" type="checkbox"></td>
                <td>{{customerId}}</td>
                <td>{{firstName}}</td>
                <td>{{lastName}}</td>
                <td>{{address.address}}</td>
                <td>{{email}}</td>
                <td>{{lastUpdate}}</td>
                <td>
                    <a class="edit" customerId="{{customerId}}" href="#">编辑</a>|
                    <a class="delete" name="{{firstName}}" customerId="{{customerId}}"  href="#">删除</a>
                </td>
            </tr>
        {{/each}}
    </script>

    <%--customer分页页码模板--%>
    <script type="text/x-handlebars-template" id="pageCode-template">
            <%--给每个页码添加上page类，且有page属性为该页得页码，每次埋下当前页码，方便取用--%>
            <li><a id="save_cur_page" curPage="{{pageNum}}"  class="first page"   page="1" href="#">首页</a></li>
            <li>
                <a class="pre page" page="{{pre pageNum}}" href="#" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            {{#each navigatepageNums}}
                <li {{#active ../pageNum this}} class="active" {{/active}} ><a class="page" page="{{this}}" href="#">{{this}}</a></li>
            {{/each}}
            <li>
                <a class="next page" page="{{next pageNum pages}}" href="#" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
            <li><a class="end page" page="{{pages}}" href="#">末页</a></li>
    </script>

    <%--film分页页码模板--%>
    <script type="text/x-handlebars-template" id="film-pageCode-template">
        <%--给每个页码添加上page类，且有page属性为该页得页码，每次埋下当前页码，方便取用--%>
        <li><a id="film_save_cur_page" curPage="{{pageNum}}"  class="first filmPage"   page="1" href="#">首页</a></li>
        <li>
            <a class="pre filmPage" page="{{pre pageNum}}" href="#" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
            </a>
        </li>
        {{#each navigatepageNums}}
        <li {{#active ../pageNum this}} class="active" {{/active}} ><a class="filmPage" page="{{this}}" href="#">{{this}}</a></li>
        {{/each}}
        <li>
            <a class="next filmPage" page="{{next pageNum pages}}" href="#" aria-label="Next">
                <span aria-hidden="true">&raquo;</span>
            </a>
        </li>
        <li><a class="end filmPage" page="{{pages}}" href="#">末页</a></li>
    </script>

    <%--customer地址选择模板--%>
    <script type="text/x-handlebars-template" id="address_add_customer-template">
        {{#with map}}
            {{#each addressList}}
                <option {{#addrSlt ../addrId addressId}} selected="selected" {{/addrSlt}}  value="{{addressId}}" >{{address}}</option>
            {{/each}}
        {{/with}}
    </script>

    <%--条件地址模板--%>
    <script type="text/x-handlebars-template" id="address_add_customer_example-template">
        <option value="0">---未选择---</option>
            {{#each this}}
                <option value="{{addressId}}" >{{address}}</option>
            {{/each}}
    </script>

    <%--film语言选择模板--%>
    <script type="text/x-handlebars-template" id="language_add_film-template">
        {{#with map}}
            {{#each languageList}}
            <option {{#addrSlt ../addrId languageId}} selected="selected" {{/addrSlt}}  value="{{languageId}}" >{{name}}</option>
            {{/each}}
        {{/with}}
    </script>

    <%--编辑customer模态框模板--%>
    <script type="text/x-handlebars-template" id="eidt_customer_template">

        <div class="form-group">
            <label for="first_name" class="col-sm-2 control-label">First&nbsp;Name<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <input type="hidden" id="edit_customer_id" value="{{customerId}}">
                {{firstName}}
            </div>
        </div>
        <div class="form-group">
            <label for="last_name" class="col-sm-2 control-label">Last&nbsp;Name<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <input type="text" name="lastName" value="{{lastName}}" add_validate="success" class="form-control customer_last_name" id="edit_last_name" placeholder="Last Name">
                <span class="help-block"></span>
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail" class="col-sm-2 control-label">Email</label>
            <div class="col-sm-4">
                <input type="email" name="email" value="{{email}}" add_validate="success" class="form-control customer_email" id="edit_InputEmail" placeholder="Email">
                <span class="help-block"></span>
            </div>
        </div>
        <div class="form-group">
            <label  class="col-sm-2 control-label">Address<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <select name="addressId" id="edit_select" class="form-control">

                </select>
            </div>
        </div>

    </script>

    <%--&lt;%&ndash;编辑film模态框模板--%>
    <script type="text/x-handlebars-template" id="eidt_film_template">

        <div class="form-group">
            <label for="first_name" class="col-sm-2 control-label">First&nbsp;Name<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <input type="hidden" id="edit_film_id" value="{{filmId}}">
                {{title}}
            </div>
        </div>
        <div class="form-group">
            <label for="description" class="col-sm-2 control-label">Description<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <textarea rows="4" cols="4" add_validate="success" name="description" class="form-control film_description" id="edit_description">{{description}}</textarea>
                <span class="help-block"></span>
            </div>
        </div>
        <div class="form-group">
            <label  class="col-sm-2 control-label">Address<span style="color: red">*</span></label>
            <div class="col-sm-4">
                <select name="languageId" id="edit_film_select" class="form-control">

                </select>
            </div>
        </div>

    </script>

    <%--显示film信息模板--%>
    <script type="text/x-handlebars-template" id="film-template">
        {{#each this}}
        <tr>
            <td><input filmId="{{filmId}}" class="select_one_film" type="checkbox"></td>
            <td>{{filmId}}</td>
            <td>{{title}}</td>
            <td>{{description}}</td>
            <td>{{language.name}}</td>
            <td>
                <a class="edit_film" filmId="{{filmId}}" href="#">编辑</a>|
                <a class="delete_film" title="{{title}}" customerId="{{filmId}}"  href="#">删除</a>
            </td>
        </tr>
        {{/each}}
    </script>

</head>
<body>
    <input id="url" type="hidden" value="<c:url value="/" /> ">

    <%--customer编辑模态框--%>
    <div class="modal fade" id="eidt_Customer_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">修改Customer</h4>
                </div>
                <div class="modal-body">
                    <form id="edit_form" class="form-horizontal">

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" id="edit_save_btn" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <%--film编辑模态框--%>
    <div class="modal fade" id="eidt_film_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="ModalLabel">修改Film</h4>
                </div>
                <div class="modal-body">
                    <form id="edit_film_form" class="form-horizontal">

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" id="edit_save_film_btn" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <%--主页面头部显示--%>
    <div id="main_head" class="col-md-12">
        <div class="col-md-4">
            <h4>电影租凭系统</h4>
        </div>
        <div class="col-md-2 col-lg-offset-6">
            <h4>
                <span id="span" class="glyphicon glyphicon-user" aria-hidden="true">
                    ${customerLogin.firstName}|<a id="logout" href="#">退出登录</a>
                </span>

            </h4>
        </div>
    </div>

    <%--左边菜单栏--%>
    <div id="nav_menu" class="col-md-2" >
        <div class="row">
            <div class="menu_list">
                <a id="customer_menu" href="#">
                    <div>
                        Customer管理
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </div>
                </a>
            </div>
            <div id="film_menu" class="menu_list">
                <a href="#">
                    <div>
                        Film设置
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <%--//客户展示--%>
    <div style="display: block" id="customer_list_div" class="col-md-10">
        <div id="customer_list_title" class="col-md-12">
            <span>客户管理</span>
        </div>
        <div>
            <div id="table_div" class="col-md-12" >
                <div class="col-md-12">
                    <div class="col-md-2">
                    客户列表
                    </div>
                    <div class="col-md-1 col-lg-offset-2">
                        <input id="add_customer_btn" type="button" class="btn btn-primary btn-sm" value="新增">
                                          </div>
                    <div class="col-md-1 col-lg-offset-2">
                        <input id="delete_customer_btn" type="button" class="btn btn-danger btn-sm" value="删除">
                    </div>
                    <div class="col-md-1 col-lg-offset-2">
                        <input id="select_customer_btn" type="button" class="btn btn-success btn-sm" value="查询">
                    </div>
                </div>
                <div class="col-md-12">
                    <form id="customer_example" class="form-inline">
                        <div class="form-group  col-md-1">
                            <label for="select_firstName">firstName</label>
                            <input type="text" name="firstName" class="form-control" id="select_firstName" placeholder="firstName">
                        </div>
                        <div class="form-group col-md-1 col-lg-offset-2">
                            <label for="select_lastName">lastName</label>
                            <input type="text" name="lastName" class="form-control" id="select_lastName" placeholder="lastName">
                        </div>
                        <div class="form-group col-md-1 col-lg-offset-2">
                            <label for="select_lastName">address</label>
                            <select style="width: 180px" name="addressId" class="form-control" id="select_example">


                            </select>
                        </div>
                        <div class="form-group col-md-1 col-lg-offset-2">
                            <label for="select_lastName">email</label>
                            <input type="text" name="email" class="form-control" id="select_email" placeholder="email">
                        </div>
                    </form>
                </div>
                <table id="table_customer_list" class="table table-bordered table-condensed">
                    <thead id="table_head">
                    <tr >
                        <td><input id="select_all_customer" type="checkbox"></td>
                        <td>CostomerId</td>
                        <td>First Name</td>
                        <td>Last Name</td>
                        <td>Address</td>
                        <td>Email</td>
                        <td>LastUpdate</td>
                        <td>操作</td>
                    </tr>
                    </thead>
                    <tbody id="customer_list">

                    </tbody>
                </table>
                <div class="col-lg-offset-7">
                    <nav aria-label="Page navigation">
                        <ul id="page-list" class="pagination">

                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>


    <%--电影展示--%>
    <div id="film_list_div" style="display: none;" class="col-md-10">
        <div id="film_list_title" class="col-md-12">
            <span>电影设置</span>
        </div>
        <div>
            <div id="film_table_div" class="col-md-12" >
                <div class="col-md-12">
                    <div class="col-md-2">
                        电影列表
                    </div>
                    <div class="col-md-1 col-lg-offset-2">
                        <input id="add_film_btn" type="button" class="btn btn-primary btn-sm" value="新增">
                    </div>
                    <div class="col-md-1 col-lg-offset-2">
                        <input id="delete_film_btn" type="button" class="btn btn-danger btn-sm" value="删除">
                    </div>
                </div>
                <table id="table_film_list" class="table table-bordered">
                    <thead id="table_film_head">
                    <tr >
                        <td><input id="select_all_film" type="checkbox"></td>
                        <td>id</td>
                        <td>title</td>
                        <td>description</td>
                        <td>language</td>
                        <td>操作</td>
                    </tr>
                    </thead>
                    <tbody id="film_list">

                    </tbody>
                </table>
                <div class="col-lg-offset-7">
                    <nav aria-label="Page navigation">
                        <ul id="film-page-list" class="pagination">
                            <li><a href="#">首页</a></li>
                            <li>
                                <a href="#" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <li><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">4</a></li>
                            <li><a href="#">5</a></li>
                            <li>
                                <a href="#" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                            <li><a href="#">末页</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>


    <%--用户新增页面--%>
    <div id="customer_add_div" style="display: none" class="col-md-10">
        <div id="add_customer_div_head">
            <span>创建Customer</span>
        </div>
        <div id="add_customer_div">
            <div id="add_div_title" class="col-md-12">
                <h4>基本信息</h4>
            </div>
            <div id="add_div">
                <form id="add_customer_form" class="form-horizontal">
                    <div class="form-group">
                        <label for="first_name" class="col-sm-2 control-label">First Name<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <input type="text" name="firstName" class="form-control" id="first_name" placeholder="First Name">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="last_name" class="col-sm-2 control-label">Last Name<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <input type="text" name="lastName" class="form-control customer_last_name" id="last_name" placeholder="Last Name">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-4">
                            <input type="text" name="email" class="form-control customer_email" add_validate="success" id="inputEmail" placeholder="Email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Address<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <input type="hidden" name="storeId" value="1">
                            <select name="addressId" id="address_select" class="form-control">

                            </select>
                        </div>

                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-1">
                            <input id="add_customer_submit_btn" type="button" class="btn btn-primary" value="确定">
                        </div>
                        <div class="col-sm-1">
                            <input id="cancel_add_btn" type="button" class="btn btn-default" value="取消">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%--电影新增页面--%>
    <div id="film_add_div" style="display: none" class="col-md-10">
        <div id="add_film_div_head">
            <span>创建Customer</span>
        </div>
        <div id="add_film_div">
            <div id="add_film_div_title" class="col-md-12">
                <h4>基本信息</h4>
            </div>
            <div id="add_div_film">
                <form id="add_film_form" class="form-horizontal">
                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">Title<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <input type="text" name="title" class="form-control" id="title" placeholder="title">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="description" class="col-sm-2 control-label">Description<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <textarea rows="4" cols="4" name="description" class="form-control film_description" id="description"></textarea>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Language<span style="color: red">*</span></label>
                        <div class="col-sm-4">
                            <input type="hidden" name="storeId" value="1">
                            <select name="languageId" id="language_select" class="form-control">

                            </select>
                        </div>

                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-1">
                            <input id="add_film_submit_btn" type="button" class="btn btn-primary" value="确定">
                        </div>
                        <div class="col-sm-1">
                            <input id="cancel_add_film_btn" type="button" class="btn btn-default" value="取消">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
