<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<header>
<div class="container">
      <div class="row">
         <div class="span11">
            <!-- Logo and site link -->
            <div class="logo">
               <h1><a href="${ctx}/">三处图书角<span class="color">.</span></a></h1>
            </div>
         </div>
         <div class="span1">
         <shiro:guest>
			<div class="btn-group pull-right">
	         	<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
	         			<i class="icon-user"></i> Guest
						<span class="caret"></span>
	         	</a>
				<ul class="dropdown-menu">
					<li><a href="${ctx}/login">Login</a></li>
					<li><a href="${ctx}/register">Sign Up</a></li>
				</ul>
			</div>
		 </shiro:guest>
         <shiro:user>
			<div class="btn-group pull-right">
				<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
					<i class="icon-github-alt"></i>   <shiro:principal property="name"/> 
					<span class="caret"></span>
				</a>
			
				<ul class="dropdown-menu">
					<shiro:hasRole name="admin">
						<li><a href="${ctx}/admin/console"><i class="icon-cogs"></i> 管理界面</a></li>
					</shiro:hasRole>
					<li><a href="${ctx}/console/about"><i class="icon-user"></i> 个人资料</a></li>
					<li class="divider"></li>
					<li><a href="${ctx}/ebook/upload">上传电子书</a></li>
					<li><a href="${ctx}/article/create">创建书评</a></li>
					<li><a href="${ctx}/logout">退出登录</a></li>
				</ul>
			</div>
		  </shiro:user>
		  </div>
      </div>
   </div>
</header>
<!-- Navigation Starts -->

<!-- Note down the syntax before editing. It is the default twitter bootstrap navigation -->

<div class="navbar">
   <div class="navbar-inner">
     <div class="container">
       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">菜单</a>
       <div class="nav-collapse collapse">
         <!-- Navigation links starts here -->
        <ul class="nav">
          <!-- Main menu -->
          <li><a href="${ctx}/">首页</a></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">图书 <b class="caret"></b></a>
            <!-- Submenus -->
            <ul class="dropdown-menu">
              <li><a href="${ctx}/book">书籍列表</a></li>
              <li><a href="${ctx}/book/history">借阅历史</a></li>
              </ul>
          </li>
          
          <li><a href="${ctx}/ebook">电子书</a></li>
          
          <!-- Navigation with sub menu. Please note down the syntax before you need. Each and every link is important. -->
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">文章区 <b class="caret"></b></a>
            <!-- Submenus -->
            <ul class="dropdown-menu">
              <li><a href="${ctx}/article?search_EQ_catalog.id=-2">通知公告</a></li>
              <li><a href="${ctx}/article?search_EQ_catalog.id=-1">书评影评</a></li>
            </ul>
          </li>
          
        </ul>
      </div>
    </div>
  </div>
</div>
    
<!-- Navigation Ends -->   
