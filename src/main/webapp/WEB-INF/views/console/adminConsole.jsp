<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page import="com.ccb.library.service.account.ShiroDbRealm.ShiroUser"%>
<%
	ShiroUser user = (ShiroUser) org.apache.shiro.SecurityUtils.getSubject().getPrincipal();
	if(user!=null){
		request.setAttribute("nowUserId", user.id);
	}
%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html>
<body>
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
						<li><a href="${ctx}/admin/user">用户管理</a></li>
						<li class="dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#">图书管理 <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="${ctx}/admin/book">库存维护</a></li>
								<li><a href="${ctx}/admin/book/borrow">借书登记</a></li>
								<li><a href="${ctx}/admin/book/return">还书登记</a></li>
							</ul></li>
						<li><a href="${ctx}/admin/ebook">电子书管理</a></li>
						<c:if test="${nowUserId==-1}">
					    <li class="pull-right"><a href="${ctx}/admin/global">全局设置</a></li>
						</c:if>
					</ul>
				</div>

					<div class="clearfix"></div>
				</div>
			</div>
		</div>


</body>
</html>