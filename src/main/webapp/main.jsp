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
    <script type="text/javascript" src="<c:url value="js/mainCustomer.js"/>" ></script>
    
    <script type="text/x-handlebars-template" id="customer-template">
        {{#each this}}
            <tr>
                <td>{{firstName}}</td>
                <td>{{lastName}}</td>
                <td>{{address.address}}</td>
                <td>{{email}}</td>
                <td>{{customerId}}</td>
                <td>{{lastUpdate}}</td>
                <td>
                    <a class="edit" customerId="{{customerId}}" href="#">编辑</a>|
                    <a class="delete" customerId="{{customerId}}"  href="#">删除</a>
                </td>
            </tr>
        {{/each}}
    </script>
    
    <script type="text/x-handlebars-template" id="pageCode-template">

        <%--给每个页码添加上page类，且有page属性为该页得页码，每次埋下当前页码，方便取用--%>
        <li><a id="save_cur_page" curPage="{{pageNum}}" class="first page" page="1" href="#">首页</a></li>
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

    <script type="text/x-handlebars-template" id="address_add_customer-template">
        {{#with map}}
            {{#each addressList}}
                <option {{#addrSlt ../addrId addressId}} selected="selected" {{/addrSlt}}  value="{{addressId}}" >{{address}}</option>
            {{/each}}
        {{/with}}
    </script>

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
</head>
<body>
    <input id="url" type="hidden" value="<c:url value="/"></c:url> ">

    <%--//编辑模态框--%>
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


<%--主页面头部显示--%>
    <div id="main_head" class="col-md-12">
        <div class="col-md-4">
            <h4>电影租凭系统</h4>
        </div>
        <div class="col-md-2 col-lg-offset-6">
            <h4>
                <span id="span" class="glyphicon glyphicon-user" aria-hidden="true">
                    ${customerLogin.firstName}&nbsp;${customerLogin.lastName}
                </span>
            </h4>
        </div>
    </div>

    <div class="col-md-2">

            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                        <li><a href="#" class="active">Customer管理</a></li>
                        <li><a href="#">Film设置</a></li>
                    </ul>
                </div>

            </div>

    </div>
    <%--//客户展示--%>
    <div id="customer_list_div" class="col-md-10">
        <div id="customer_list_title" class="col-md-12">
            <span>客户管理</span>
        </div>
        <div>
            <div id="table_div" class="col-md-12" >
                <div class="col-md-12">
                    <div class="col-md-2">
                    客户列表
                    </div>
                    <div class="col-md-1 col-lg-offset-3">
                        <input id="add_customer_btn" type="button" class="btn btn-primary btn-sm" value="新增">
                    </div>
                </div>
                <table id="table_customer_list" class="table table-bordered table-condensed">
                    <thead id="table_head">
                    <tr >
                        <td>First Name</td>
                        <td>Last Name</td>
                        <td>Address</td>
                        <td>Email</td>
                        <td>CostomerId</td>
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

    <%--新增页面--%>
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
                            <input type="text" class="form-control customer_email" add_validate="success" id="inputEmail" placeholder="Email">
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

</body>
</html>
