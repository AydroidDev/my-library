<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html>
<head>
<title>评论管理</title>
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
			<li><a href="${ctx}/admin/user">用户管理</a></li>
			<li class="active dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">博客管理 <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="${ctx}/admin/blog/catalog">分类管理</a></li>
					<li><a href="${ctx}/admin/blog/article">文章管理</a></li>
					<li><a href="${ctx}/admin/blog/comment">评论管理</a></li>
				</ul>
			</li>
		</ul>
	</div>
				<div class="content">
					<table id="contentTable"
						class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th>被评论的文章</th>
								<th>文章作者</th>
								<th>评论内容</th>
								<th>评论作者</th>
								<th>时间</th>
								<th>状态</th>
								<th>管理</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${comments.content}" var="comment">
								<tr>
									<td><a href="${ctx}/blog/article/detail/${comment.article.id}">${comment.article.title}</a></td>
									<td><a href="#">${comment.article.user.name}</a></td>
									<td>${comment.content}</td>
									<td><c:choose>
											<c:when test="${not empty comment.user}">${comment.user.name}</c:when>
											<c:otherwise>${comment.author}&nbsp;(GUEST)</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate value="${comment.createTime}"
											pattern="yyyy年MM月dd日  HH时mm分ss秒" /></td>
									<td>${comment.status}</td>
									<td><a href="${ctx}/blog/comment/delete/${comment.id}?url=${url}">删除</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<tags:paging paginationSize="5" page="${comments}"></tags:paging>
				</div>
			</div>
		</div>
	</div>

	<!-- Content ends -->

</body>
</html>
