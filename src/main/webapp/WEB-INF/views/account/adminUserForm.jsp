<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>  
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title>-用户管理</title>
	
	<script>
		$(document).ready(function() {
			//聚焦第一个输入框
			$("#name").focus();
			//为inputForm注册validate函数
			$("#inputForm").validate();
		});
	</script>
</head>

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
            
            <!-- Login starts -->
            
            <div class="logreg">
               <div class="row">
                  <div class="span12">
                     <div class="logreg-page">
                        <h3><span class="color">用户管理</span></h3>                        
                        <hr />
						<form id="inputForm" action="${ctx}/admin/user/update" method="post" class="form-horizontal">
							<input type="hidden" name="id" value="${user.id}"/>
							<fieldset>
								<div class="control-group">
									<label class="control-label">登录名:</label>
									<div class="controls">
										<input type="text" value="${user.loginName}" class="input-large" disabled="" />
									</div>
								</div>
								<div class="control-group">
									<label for="name" class="control-label">用户名:</label>
									<div class="controls">
										<input type="text" id="name" name="name" value="${user.name}" class="input-large required" minlength="3" maxlength="12"/>
									</div>
								</div>
								<div class="control-group">
								<label for="roles" class="control-label">角色:</label>
									<div id ="roles" class="controls">
										<form:select path="user.roles" items="${allRoles}"/>
									</div>
								</div>
								<div class="control-group">
								<label for="status" class="control-label">状态:</label>
									<div id="status" class="controls">
										<form:select path="user.status" items="${allStatus}"/>
									</div>
								</div>
                                <div class="control-group">
                                  <label class="control-label" for="department">部门</label>
                                  <div class="controls">
										<form:select path="user.department" items="${allDepartment}"/>
                                 </div>
                                </div>
								
								<div class="control-group">
									<label for="plainPassword" class="control-label">密码:</label>
									<div class="controls">
										<input type="password" id="plainPassword" name="plainPassword" class="input-large" minlength="3" maxlength="12" placeholder="...Leave it blank if no change"/>
									</div>
								</div>
								<div class="control-group">
									<label for="confirmPassword" class="control-label">确认密码:</label>
									<div class="controls">
										<input type="password" id="confirmPassword" name="confirmPassword" class="input-large" equalTo="#plainPassword" />
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
            
            <!-- Login ends -->
            
         </div>
      </div>
   </div>
</div>   

<!-- Content ends --> 
</body>
</html>
