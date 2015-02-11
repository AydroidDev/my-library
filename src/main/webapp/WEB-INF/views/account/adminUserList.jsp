<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html>
<head>
<title>-用户管理</title>
</head>

<body>
	<!-- Content starts -->

	<div class="container">
		<div class="row">
			<div class="span12">

				<c:if test="${not empty message}">
					<div id="message" class="alert alert-success">
						<button data-dismiss="alert" class="close">×</button>
						${message}
					</div>
				</c:if>
				<div class="manager">
					<ul class="nav nav-tabs">
						<li class="active"><a href="${ctx}/admin/user">用户管理</a></li>
						<li class="dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#">图书管理 <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="${ctx}/admin/book">书籍列表</a></li>
								<li><a href="${ctx}/admin/book/borrow">借书登记</a></li>
								<li><a href="${ctx}/admin/book/return">还书登记</a></li>
							</ul></li>
							<li><a href="${ctx}/admin/ebook">电子书管理</a></li>
					</ul>
				</div>
				<div class="content">
				<div class="row">
				<div class="span9">
					<table id="contentTable"
						class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th>登录名</th>
								<th>用户名</th>
								<th>角色</th>
								<th>贡献值</th>
								<th>部门</th>
								<th>状态</th>
								<th>管理</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${users.content}" var="user">
								<tr>
									<td>${user.loginName}</td>
									<td>${user.name}</td>
									<td>${allRoles[user.roles]}</td>
									<td>${user.aum}</td>
									<td>${user.department}</td>
									<td>${allStatus[user.status]}</td>
									<td><a href="${ctx}/admin/user/update/${user.id}">管理</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<tags:paging page="${users}" paginationSize="5"/>
					 <div class="clearfix"></div>
				</div>	 
				
				        <div class="span3">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>Search</h4>
                                 <form id="searchform" action="${ctx}/admin/user" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-small" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>
                           </div>                                                
                        </div>
				
				</div>
					 
					 
				</div>

			</div>
		</div>
	</div>
	<!-- Content ends -->

</body>
</html>
