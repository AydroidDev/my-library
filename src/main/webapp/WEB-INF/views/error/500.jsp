<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page import="org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<%response.setStatus(200);%>

<%
	Throwable ex = null;
	if (exception != null)
		ex = exception;
	if (request.getAttribute("javax.servlet.error.exception") != null)
		ex = (Throwable) request.getAttribute("javax.servlet.error.exception");

	//记录日志
	if(ex!=null){
	Logger logger = LoggerFactory.getLogger("500.jsp");
	logger.error(ex.getMessage(), ex);
	request.setAttribute("message", ex.getMessage());
	}
%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<title>500 - 系统内部错误</title>
<!-- Stylesheets -->
<link href="${ctx}/static/bootstrap/2.2.2/css/bootstrap.min.css" rel="stylesheet" />

<!--[if IE 7]>
<link href=""${ctx}/static/styles/font-awesome-ie7.css" rel="stylesheet">
<![endif]-->		

<link href="${ctx}/static/styles/style.css" rel="stylesheet">

<!-- Color Stylesheet - orange, blue, pink, brown, red or green-->
<link href="${ctx}/static/styles/blue.css" rel="stylesheet">
<link href="${ctx}/static/styles/bootstrap-responsive.css" rel="stylesheet">

<!-- HTML5 Support for IE -->
<!--[if lt IE 9]>
<script src="${ctx}/static/js/html5shim.js" type="text/javascript"></script>
<![endif]-->

<!-- jquery bootstrap -->
<script src="${ctx}/static/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="${ctx}/static/bootstrap/2.2.2/js/bootstrap.min.js" type="text/javascript"></script>

<!-- Favicon -->
<link type="image/x-icon" href="${ctx}/static/images/favicon.ico" rel="shortcut icon">
</head>

<body>
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
					<c:if test="${not empty message}">
						<div id="message" class="alert alert-error">
							<button data-dismiss="alert" class="close">×</button>
							${message}
						</div>
					</c:if>
            <div class="error">
               <div class="row">
                  <div class="span12">
                     <div class="error-page">
                        <p class="error-med">Oops! Something wrong</p>                        
                        <p class="error-big">500<span class="color">!!!</span></p>                        
                        <p class="error-small">对不起，系统内部错误.</p>
                        <div class="button"><a href="<c:url value="/"/>">首页</a>&nbsp;&nbsp;<a href="javascript:history.back();">返回</a></div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>   

</body>
</html>
