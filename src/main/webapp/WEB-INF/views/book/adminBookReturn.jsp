<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>图书管理</title>

	<script>
		$.validator.addMethod("yyyy-MM-dd", function(value, element){
			var ereg = /^(\d{1,4})(-)(\d{1,2})(-)(\d{1,2})$/;
			var r = value.match(ereg);
			if (r == null) {
				return false;
			}
			var d = new Date(r[1], r[3] - 1, r[5]);
			var result = (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[5]);
			return this.optional(element) || (result);
		}, "请输入正确的日期");
	
		$(document).ready(function() {
			//为inputForm注册validate函数
			$("#borrowBookForm").validate({
				onkeyup: false
			});
			
		});
		
		function updateBook(id,bookId){
			
			$("#borrowBookForm #id").attr("value",id);
			$("#borrowBookForm #bookId").attr("value",bookId);
			$("#borrowBookForm #bookName").attr("value",$("tr#"+id+" td:eq(0)").text());
			$("#borrowBookForm #userName").attr("value",$("tr#"+id+" td:eq(3)").text());
			$("#borrowBookForm #bookName1").attr("value",$("tr#"+id+" td:eq(0)").text());
			$("#borrowBookForm #userName1").attr("value",$("tr#"+id+" td:eq(3)").text());
			$('#borrowBookModal').modal('show');
			$("#borrowBookForm #returnDate").focus();
			
		};
		
	
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
				<div class="manager">
					<ul class="nav nav-tabs">
						<li><a href="${ctx}/admin/user">用户管理</a></li>
						<li class="active dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#">图书管理 <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="${ctx}/admin/book">库存维护</a></li>
								<li><a href="${ctx}/admin/book/borrow">借书登记</a></li>
								<li><a href="${ctx}/admin/book/return">还书登记</a></li>
							</ul></li>
						<li><a href="${ctx}/admin/ebook">电子书管理</a></li>
					</ul>
				</div>
				
	<div class="content">
	   <div class="container">
      	<div class="row">
         <div class="span12">
            
            <div class="row">
               <div class="span9">
	
	
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th>书名</th><th>作者</th><th style="width:94px">出版社</th><th style="width:40px">借书人</th><th style="width:112px">借书时间</th></tr></thead>
			<tbody>
			<c:forEach items="${bookBorrowList.content}" var="bookBorrow">
				<tr id="${bookBorrow.id}">
					<td>${bookBorrow.book.name}</td>
					<td>${bookBorrow.book.author}</td>
					<td>${bookBorrow.book.press}</td>
					<td>${bookBorrow.user.name}</td>
					<td>
					<fmt:formatDate value="${bookBorrow.borrowDate}" pattern="yyyy-MM-dd" />
                	<button onclick=updateBook(${bookBorrow.id},${bookBorrow.book.id}) class="btn pull-right" >还</button>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	    <tags:paging page="${bookBorrowList}" paginationSize="5"/>
	        <div class="clearfix"></div>
	 
		 	</div>
		 	
                        <div class="span3">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>Search</h4>
                                 <form id="searchform" action="${ctx}/admin/book/return" class="form-search">
                                    <input type="text" name="search_LIKE_book.name" class="input-small focused " value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>
                           </div>                                                
                        </div>
		 	
		 	
		 	
		 </div>
	 
	 
      	 </div>
        </div>
       </div>


         <!-- modal content -->
          <div id="borrowBookModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>还书登记</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="borrowBookForm" action="${ctx}/admin/book/return" method="post" class="form-horizontal">
                                          <input type="text" id="id" name="id" class="hidden"/>
                                          <input type="text" id="bookId" name="book.id" class="hidden"/>
                                          <div class="modal-body">
                                          <div class="control-group">
                                            <label class="control-label" for="bookName">书名</label>
                                            <div class="controls">
                                              <input type="text" id="bookName" name="book.name" class="input-large" disabled/>
                                              </div>
                                          </div>   
                                          
                                          <div class="control-group">
                                            <label class="control-label" for="userName">还书人</label>
                                            <div class="controls">
                                              <input type="text" id="userName" name="user.name" class="input-large" disabled/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="returnDate">还书时间</label>
                                            <div class="controls">
                                              <input type="text" id="returnDate" name="returnDate"  class="input-large yyyy-MM-dd"/>
                                              <p class="help-block">格式 :2014-01-01</p>
                                            </div>
                                          </div>
                                          <input type="text" id="userName1" name="user.name" class="hidden" />
                                          <input type="text" id="bookName1" name="book.name" class="hidden" />
                                          
                                        </div>  
                                        <div class="modal-footer">
                                          <div class="form-actions">
							              <a href="#" class="btn" data-dismiss="modal" >Close</a>
							              <button type="submit" class="btn btn-primary">Save</button>
                                          </div>
							           	</div>
                                          
                                      </form>
            
            
            
          </div>
          <!-- modal end -->                           


	 
	 </div>
         
         
      </div>
   </div>
</div>   
<!-- Content ends --> 



</body>
</html>
