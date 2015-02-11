<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>文章管理</title>
</head>

<body>
<!-- Content starts -->

   <div class="container">
      <div class="row">
         <div class="span12">
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">×</button>${message}</div>
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
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>文章名</th><th>作者</th><th>评论数</th><th>点击数</th><th>创建时间</th><th>修改时间</th><th>管理</th></tr></thead>
		<tbody>
		<c:forEach items="${articles.content}" var="article">
			<tr>
				<td><a href="${ctx}/blog/article/detail/${article.id}">${article.title}</a></td>
				<td>${article.user.name}</td>
				<td>${article.commentCount}</td>
				<td>${article.viewCount}</td>
				<td>
					<fmt:formatDate value="${article.createTime}" pattern="yyyy年MM月dd日  HH时mm分ss秒" />
				</td>
				<td>
					<fmt:formatDate value="${article.modifyTime}" pattern="yyyy年MM月dd日  HH时mm分ss秒" />
				</td>
				<td><a href="${ctx}/blog/article/update/${article.id}">修改</a> <a href="${ctx}/console/blog/article/delete/${article.id}?url=/admin/blog/article">删除</a></td>
			</tr>
		</c:forEach>
	</table>
    <tags:paging page="${articles}" paginationSize="5"/>
        <div class="clearfix"></div>
         </div>
      </div>
   </div>
</div>   
<!-- Content ends --> 

</body>
</html>
