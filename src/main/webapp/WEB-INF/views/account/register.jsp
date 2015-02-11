<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>  
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title>-用户注册</title>
	
	<script>
		$(document).ready(function() {
			//聚焦第一个输入框
			$("#loginName").focus();
			//为inputForm注册validate函数
			$("#inputForm").validate({
				onkeyup: false  ,
				rules: {
					loginName: {
						remote: "${ctx}/api/user/checkLoginName"
					},
					name:{
						remote: "${ctx}/api/user/checkName"
					}
				},
				messages: {
					loginName: {
						remote: "用户登录名已存在"
					},
					name: {
						remote: "用户名已存在"
					}
				}
			});
		});
	</script>
</head>

<body>
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
 		<div id="message" class="alert alert-error"><button data-dismiss="alert" class="close">×</button>三处人员无需注册，其他人注册后请联系管理员审批后才能登录。</div>
            
            <!-- Login starts -->
            
            <div class="logreg">
               <div class="row">
                  <div class="span12">
                     <div class="logreg-page">
                        <h3>Register with <span class="color">Our Library</span></h3>                        
                        <hr />
                                      <!-- Register form (not working)-->
                                      <form id="inputForm" action="${ctx}/register" method="post" class="form-horizontal">
                                          <!-- Name -->
                                          <div class="control-group">
                                            <label class="control-label" for="loginName">Login Name</label>
                                            <div class="controls">
                                              <input type="text" id="loginName" name="loginName" class="input-large required" minlength="3" maxlength="20"/>
                                              <span class="help-block">请使用rtx登陆账号: xxx.zh</span>
                                            </div>
                                          </div>   
                                          <!-- Email 
                                          <div class="control-group">
                                            <label class="control-label" for="email">Email</label>
                                            <div class="controls">
                                              <input type="text" class="input-large required email required" id="email" name="email" maxlength="50">
                                            </div>
                                          </div>
                                          -->
                                          <!-- Password -->
										<div class="control-group">
											<label for="plainPassword" class="control-label">Password</label>
											<div class="controls">
												<input type="password" id="plainPassword" name="plainPassword" class="input-large required" minlength="3" maxlength="20"/>
											</div>
										</div>
										<div class="control-group">
											<label for="confirmPassword" class="control-label">Confirm Password</label>
											<div class="controls">
												<input type="password" id="confirmPassword" name="confirmPassword" class="input-large required" equalTo="#plainPassword"/>
											</div>
										</div>
                                          <!-- Username -->
                                          <div class="control-group">
                                            <label class="control-label" for="name">Real Name</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="name" class="input-large required" minlength="2" maxlength="20"/>
                                            </div>
                                          </div>
                                          
		                                <div class="control-group">
		                                  <label class="control-label" for="department">部门</label>
		                                  <div class="controls">
												<form:select path="user.department" items="${allDepartment}"/>
		                                 </div>
		                                </div>

                                          <!-- Checkbox -->
                                          <div class="control-group">
                                             <div class="controls">
                                                <label class="checkbox inline">
                                                   <input type="checkbox" id="checkbox" value="agree"> Agree with Terms and Conditions
                                                </label>
                                             </div>
                                          </div> 
                                          
                                          <!-- Buttons -->
                                          <div class="form-actions">
                                             <!-- Buttons -->
											<input id="submit_btn" class="btn" type="submit" value="Submit"/>&nbsp;	
											<input id="cancel_btn" class="btn" type="button" value="Back" onclick="history.back()"/>
                                          </div>
                                      </form>
                                      <hr />
                                          <div class="lregister">
                                             Already have account with us? <a href="${ctx}/login">Login</a>
                                          </div>
                                    </div>                           
                                    
                                                             
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
