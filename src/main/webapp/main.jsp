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
    <script type="text/javascript" src="<c:url value="js/mainCustomer.js"/>" ></script>

</head>
<body>
    <input id="url" type="hidden" value="<c:url value="/"></c:url> ">
    <div id="main_head" class="col-md-12">
        <div class="col-md-4">
            <h4>电影租凭系统</h4>
        </div>
        <div class="col-md-1 col-lg-offset-11">
            <span id="span" class="glyphicon glyphicon-user" aria-hidden="true"></span>
            <span>${customerLogin.firstName}&nbsp;${customerLogin.lastName}</span>
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
    <div class="col-md-10">
        <div class="col-md-12">
            <h4>客户管理</h4>
            <hr>
        </div>
        <div>
            <div id="table_div" class="col-md-12" >
                <div class="col-md-12">
                    <div class="col-md-2">
                    客户列表
                    </div>
                    <div class="col-md-1 col-lg-offset-3">
                        <input type="button" class="btn btn-primary btn-sm" value="新增">
                    </div>
                </div>
                <table class="table table-bordered table-condensed">
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
                    <tbody>
                        <tr>
                            <td>123</td>
                            <td>123</td>
                            <td>123</td>
                            <td>123</td>
                            <td>123</td>
                            <td>123</td>
                            <td>
                                <a href="#">删除</a>|
                                <a href="#">编辑</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="col-lg-offset-8">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
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

</body>
</html>
