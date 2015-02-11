<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
							<li><a href="${ctx}/console/about-me">个人资料</a></li>
							<li><a href="${ctx}/console/profile">修改密码</a></li>
						</ul>
					</div>

					<div class="clearfix"></div>
				</div>
			</div>
		</div>


</body>
</html>