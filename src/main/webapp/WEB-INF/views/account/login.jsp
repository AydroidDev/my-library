<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ page import="org.apache.shiro.authc.ExcessiveAttemptsException"%>
<%@ page import="org.apache.shiro.authc.IncorrectCredentialsException"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title>登录页</title>
	<script>
		$(document).ready(function() {
			$("#loginForm").validate();
		});
	</script>
</head>

<body>
<!-- Content strats -->

<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
            
            <!-- Login starts -->
            
            <div class="logreg">
               <div class="row">
                  <div class="span12">
                     <div class="logreg-page">
                        <h3>Log in <span class="color">Our Library</span></h3>                        
                        <hr />
                                    <div class="form">
									<%
									String error = (String) request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
									if(error != null){
										%>
										<div class="alert alert-error controls">
											<button class="close" data-dismiss="alert">×</button>
										<%
										if(error.contains("DisabledAccountException")){
											out.print("用户被禁用,请联系管理员.");
										}
										else{
											out.print("登录失败，请重试.");
										}
										%>		
										</div>
										<%
									}
									%>
						            <c:if test="${not empty message}">
										<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">×</button>${message}</div>
									</c:if>
                                      <!-- Login form (not working)-->
                                      <form  id="loginForm" action="${ctx}/login" method="post" class="form-horizontal">
                                          <!-- Username -->
                                          <div class="control-group">
                                            <label class="control-label" for="username">Username</label>
                                            <div class="controls">
                                              <input type="text" class="input-large required" id="username" name="username"  value="${username}">
                                            </div>
                                          </div>
                                          <!-- Password -->
                                          <div class="control-group">
                                            <label class="control-label" for="password">Password</label>
                                            <div class="controls">
                                              <input type="password" class="input-large required" id="password" name="password">
                                            </div>
                                          </div>
                                          <div class="control-group">
                                             <div class="controls">
                                                <label class="checkbox" for="rememberMe"><input type="checkbox" id="rememberMe" name="rememberMe"/> Remember me</label>
                                             </div>
                                          </div>                                                                               
                                          <!-- Buttons -->
                                          <div class="form-actions">
                                             <!-- Buttons -->
                                            <button type="submit" class="btn">Login</button>
                                            <button type="reset" class="btn">Reset</button>
                                          </div>
                                      </form>
                                      <hr />
                                          <div class="lregister">
                                             Don't have Account? <a href="${ctx}/register">Register</a>
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
