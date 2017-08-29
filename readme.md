# 电影租凭系统

## 功能

#### 用户登录
* 用户名前端校验
<p>当用户输入用户名时,在前端会进行非空校验。
当用户名输入框不为空时，将用户名请求到后端，判断该用户是否存在</p>

* 用户名后端校验
 <p>再后端会再一次进行非空校验，当验证通过才能后面的判断。
 当用户名不存在时，控制器会返回"用户名有误"的错误信息到前端显示。
 当用户名存在时，控制器会返回成功的信息，让前端进行页面跳转</p>

#### 用户注销
* 退出登录连接在登录后的主页面的右上角。
<p>点击退出登录会询问是否退户登录,当确认后会请求控制器删除session中的用户。
并跳转到登录页面。
</p>

* 权限过滤
<p>后端通过过滤器拦截了除了静态资源、登录页面及登录控制的所有请求。
当用户没有登录时，被拦截的请求，会跳转到登录页面</p>

#### 查询用户信息
* 多条件查询
<p>查询用户信息使用了多条件查询的方式,
![]()
<p>

* 分页显示

#### 修改用户信息
#### 删除用户信息