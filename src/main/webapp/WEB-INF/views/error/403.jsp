<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
	<title>403 - 用户权限不足</title>
</head>

<body>
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
            <div class="error">
               <div class="row">
                  <div class="span12">
                     <div class="error-page">
                        <p class="error-med">Oops! Something wrong</p>                        
                        <p class="error-big">403<span class="color">!!!</span></p>                        
                        <p class="error-small">用户权限不足.</p>
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
