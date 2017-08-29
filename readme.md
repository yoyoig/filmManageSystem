# 电影租凭系统

* 数据库配置
<p>在src/main/resources/jdbc.properties中进行配置。</p>

* 运行方式
<p>在项目根目录下 打开命令窗口，分别运行：mvn clean;mvn compile;mvn jetty:run 命令。
当命令行出现 [INFO] Started Jetty Server 时。
在浏览器打开http://localhost:8080/ 即可进入登录页面.
</p>


### 用户登录
* 用户名前端校验
<p>当用户输入用户名时,在前端会进行非空校验。
当用户名输入框不为空时，将用户名请求到后端，判断该用户是否存在</p>

* 用户名后端校验 
 <p>再后端会再一次进行非空校验，当验证通过才能后面的判断。
 当用户名不存在时，控制器会返回"用户名有误"的错误信息到前端显示。
 当用户名存在时，控制器会返回成功的信息，让前端进行页面跳转</p>
 
 
 

### 用户注销
* 退出登录连接在登录后的主页面的右上角。
<p>点击退出登录会询问是否退户登录,当确认后会请求控制器删除session中的用户。
并跳转到登录页面。
</p>

* 权限过滤
<p>后端通过过滤器拦截了除了静态资源、登录页面及登录控制的所有请求。
当用户没有登录时，被拦截的请求，会跳转到登录页面</p>


## CUSTOMER管理功能
* 首页默认进入customer管理
* 点击左边导航栏的customer管理也可进入customer管理


### 查询用户信息
* 多条件查询
<p>查询用户信息使用了多条件查询的方式,第一次进入时默认条件为空,即查询所有。
当在条件框里输入相关信息,再点击查询即可实现多条件查询,则页面显示条件查询结果,
若要查询所有,不再使用条件查询,将查询框中的条件删除即可。
要注意,地址选择为---未选择----时为空。否则会进行条件查询该地址的用户。
<p>


* 分页显示
<p>数据显示为分页显示数据,我们可以通过点击页面进入指定页面、上一页、下一页、末页和首页.
当我们的页码为首页和末页时则上一页,首页及下一页,末页不可用.
</p>

### 新增用户
* 前端校验
<p>前端会对用户进行格式校验,当用户名不为3-16位字母或字符时会进行错误提示.
当firstName通过格式校验之后,会使用ajax进行重复校验。当firsteName重复时，会提示用户名不可用。
不重复时，提示用户名可用。
对email的校验，可以为空，但当email不为空时，会对email进行格式校验，若错误会进行错误提示</p>

* 后端校验
<p>使用了hibernate validation进行后端校验。校验的方式和格式和前端一致。
当验证错误时，会返回错误消息，并展示到页面进行错误提示。</p>

* 地址选择
<p>动态的显示数据库中的地址。
当用户点击新增使，通过ajax获得address并展示到select标签中，供用户选择</p>

* 点击新增
<p>当点击确定时，会判断以上字段是否通过了验证。
当全部通过验证时，才会提交新增请求。
当新增成功后，会提示添加成功，并转向页面到新增数据所在的那一页。</p>

### 修改用户信息
* 前端校验
<p>和新增的校验基本相同，但是不能修改firstName</p>

* 后端校验
<p>和新增的校验基本相同</p>

* 地址选择
<p>显示数据库中的地址。
并默认选中该用户自身的地址。</p>

* 点击修改
<p>当点击保存时，会判断字段是否通过了验证。
当全部通过验证时，才会提交更新请求。
当修改成功会展示该用户所在的页面，方便查看更新后的信息。
</p>

### 删除用户信息
* 单个删除
<p>点击每个customer信息操作下的删除链接，即可实现单条删除。
点击时会提示是否确认删除。当删除成功后会提示删除成功，并返回到当前页面。
由于表中有大量外键关联，所以原数据删除会失败。
当删除失败会提示删除失败信息。
我们只能删除我们新增的customer</p>


* 批量删除
<p>同单条删除，我们只能删除我们新增的customer。
通过多选框选择我们要删除的数据。然后点击新增按钮旁边的删除按钮。
提示我们是否删除这些customer，点击取消则退出删除，点击确认则将请求发送到后台进行删除。
当删除成功会提示成功删除了的数据。否则提示删除失败。</p>


## FILM管理功能
* 点击左边导航栏的Film设置进入film管理页面

### 查询film

### 新增film

### 修改film

### 删除film

#### 说明
<p>功能和实现基本和Customer管理相同,没有实现多条件查询</p>