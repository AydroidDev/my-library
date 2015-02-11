<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>-借阅历史</title>
<script type="text/javascript">
$(document).ready(function() {
$("#searchform").submit(function(e){
	$("#searchUserName").val($("#searchBookName").val());
});
});

</script>
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
				
	<div class="content">
	   <div class="container">
      	<div class="row">
         <div class="span12">
 				<div class="hero">
                   <!-- Title. Don't forget the <span> tag -->
                   <h3><span>借阅历史</span></h3>
                </div>
            
            <div class="row">
               <div class="span9">
	
	
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th>书名</th><th>作者</th><th style="width:70px">借阅人</th><th style="width:70px">借书日期</th><th style="width:70px">应还日期</th></tr></thead>
			<tbody>
			<c:forEach items="${bookHistoryList.content}" var="bookBorrow">
				<tr id="${bookBorrow.id}">
					<td>${bookBorrow.book.name}</td>
					<td>${bookBorrow.book.author}</td>
					<td>${bookBorrow.user.name}</td>
					<td>
					<fmt:formatDate value="${bookBorrow.borrowDate}" pattern="yyyy-MM-dd" />
					</td>
					<td>
					<c:choose>
					<c:when test="${not empty bookBorrow.shouldReturnDate}"><fmt:formatDate value="${bookBorrow.shouldReturnDate}" pattern="yyyy-MM-dd" /></c:when>
					<c:otherwise>已还	</c:otherwise>
					</c:choose>
					
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	    <tags:paging page="${bookHistoryList}" paginationSize="5"/>
	        <div class="clearfix"></div>
	 
		 	</div>
                        <div class="span3">
                           <div class="sidebar">
                              <div class="widget">
                                 <h4>Search</h4>
                                 <form id="searchform" action="${ctx}/book/history" class="form-search">
                                    <input id="searchBookName" type="text" name="search_LIKE_book.name" class="input-small" value="${param["search_LIKE_book.name"]}">
                                    <input id="searchUserName" type="hidden" name="search_LIKE_user.name" class="input-small" value="${param["search_LIKE_user.name"]}">
                                    <button type="submit" class="btn">Search</button>
                                    <span class="help-block">请搜索书名或借阅人</span>
                                 </form>
                              </div>
                           </div>                                                
                        </div>
		 	
		 	
		 	
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
