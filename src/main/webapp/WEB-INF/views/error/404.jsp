<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%response.setStatus(200);%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<title>404 - 页面不存在</title>
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

<!-- Favicon -->
<link type="image/x-icon" href="${ctx}/static/images/favicon.ico" rel="shortcut icon">
</head>

<body>
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
            
            <!-- 404 starts -->
            
            <div class="error" >
               <div class="row">
                  <div class="span12">
                     <div class="error-page">
                        <p class="error-med">Oops! Something missing</p>                        
                        <p class="error-big">404<span class="color">!!!</span></p>                        
                        <p class="error-small">对不起，你所访问的页面不存在.</p>
                        <div class="button"><a href="<c:url value="/"/>">首页</a>&nbsp;&nbsp;<a href="javascript:history.back();">返回</a></div>
                     </div>
                  </div>
               </div>
            </div>
            
            <!-- 404 ends -->
            
         </div>
      </div>
   </div>
</div>   

</body>
</html>

