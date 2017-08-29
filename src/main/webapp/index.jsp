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
    <link rel="stylesheet" href="<c:url value="css/login.css" />">
    <script type="text/javascript" src="<c:url value="js/login.js"/>"></script>


</head>
<body background="img/background3.jpg">
    <div class="container">
        <div class="col-md-12">
            <h2>15254&nbsp;严铭轲</h2>
        </div>




        <div id="loginDiv" class="col-md-6 col-lg-offset-3">
            <div id="title">
                <h3>电影租凭管理系统</h3>
            </div>
            <div class="col-sm-12">
                <form id="loginForm" url="<c:url value="/"/>" class="form-horizontal">
                    <div class="form-group">
                        <label for="inputName" class="col-sm-2 control-label">用户名</label>
                        <div id="checkName" class="col-sm-10">
                            <input type="text" class="form-control" name="firstName" id="inputName" placeholder="Name">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label">密码</label>
                        <div class="col-sm-10">
                            <input type="password" class="form-control" name="password" id="inputEmail3" placeholder="password">
                            <span class="help-block" style="color: red">${msg}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2">
                            <input id="btn_submit" type="button" class="btn btn-primary" value="登录">
                        </div>
                    </div>
                </form>
            </div>
        </div>


    </div>

</body>
</html>
