<%@page import="com.ccb.library.web.Constant"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<!-- 
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
 -->
<!-- Description, Keywords 
-->
<meta name="description" content="图书，电子书，书评，影评"/>
<meta name="keywords" content="图书，电子书，书评，影评"/>
<meta name="author" content="itpudge@gmail.com"/>
<!-- Title -->
<title>三处图书角<sitemesh:title/></title>
<!-- font 
-->
<link href="${ctx}/static/styles/myfont.css" rel="stylesheet" />

<!-- Stylesheets -->
<link href="${ctx}/static/bootstrap/2.2.2/css/bootstrap.min.css" rel="stylesheet" />
<link href="${ctx}/static/styles/flexslider.css" rel="stylesheet">
<link href="${ctx}/static/styles/prettyPhoto.css" rel="stylesheet">
<link href="${ctx}/static/styles/font-awesome.css" rel="stylesheet" >
<link href="${ctx}/static/jquery-validation/1.10.0/validate.css" rel="stylesheet" />

<!--[if IE 7]>
<link href=""${ctx}/static/styles/font-awesome-ie7.css" rel="stylesheet">
<![endif]-->		

<link href="${ctx}/static/styles/style.css" rel="stylesheet"/>

<!-- Color Stylesheet - orange, blue, pink, brown, red or green-->

<link href="${ctx}/static/styles/<%out.print(Constant.type);%>.css" rel="stylesheet"/>
	
<link href="${ctx}/static/styles/bootstrap-responsive.css" rel="stylesheet"/>

<!-- HTML5 Support for IE -->
<!--[if lt IE 9]>
<script src="${ctx}/static/js/html5shim.js" type="text/javascript"></script>
<![endif]-->

<!-- jquery bootstrap -->
<script src="${ctx}/static/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="${ctx}/static/jquery-validation/1.10.0/jquery.validate.min.js" type="text/javascript"></script>
<script src="${ctx}/static/jquery-validation/1.10.0/messages_bs_zh.js" type="text/javascript"></script>
<script src="${ctx}/static/bootstrap/2.2.2/js/bootstrap.min.js" type="text/javascript"></script>

<!-- Favicon -->
<link type="image/x-icon" href="${ctx}/static/images/favicon.ico" rel="shortcut icon"/>

<sitemesh:head/>
</head>

<body>
	<%@ include file="/WEB-INF/layouts/header.jsp"%>
	<sitemesh:body/>
	<%@ include file="/WEB-INF/layouts/footer.jsp"%>
	<!-- JS -->
	<script src="${ctx}/static/js/jquery.flexslider-min.js" type="text/javascript"></script>
	<script src="${ctx}/static/js/jquery.isotope.js" type="text/javascript"></script>
	<script src="${ctx}/static/js/jquery.prettyPhoto.js" type="text/javascript"></script>
	<script src="${ctx}/static/js/filter.js" type="text/javascript"></script>
	<script src="${ctx}/static/js/custom.js" type="text/javascript"></script>

</body>
</html>
