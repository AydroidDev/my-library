<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html>
<head>
<title>全局设置</title>
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
						<li class="dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#">图书管理 <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="${ctx}/admin/book">书籍列表</a></li>
								<li><a href="${ctx}/admin/book/borrow">借书登记</a></li>
								<li><a href="${ctx}/admin/book/return">还书登记</a></li>
							</ul></li>
							<li><a href="${ctx}/admin/ebook">电子书管理</a></li>
					    <li class="active pull-right"><a href="${ctx}/admin/global">全局设置</a></li>
					</ul>
				</div>
				<div class="content">
            <div class="logreg">
               <div class="row">
                  <div class="span12">
                     <div class="logreg-page">
                        <h3><span class="color">全局设置</span></h3>                        
                        <hr />
						<form id="inputForm" action="${ctx}/admin/global" method="post" class="form-horizontal">
							<fieldset>
								 <div class="control-group">
									<label for="style" class="control-label">网站风格:</label>
										<div id="style" class="controls">
											<form:select name="style" path="style" items="${allStyles}"/>
										</div>
								 </div>
								<div class="form-actions">
									<input id="submit_btn" class="btn" type="submit" value="Submit"/>&nbsp;	
									<input id="cancel_btn" class="btn" type="button" value="Back" onclick="history.back()"/>
								</div>
							</fieldset>
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
