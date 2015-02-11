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
			//为borrowBookForm注册validate函数
			$("#borrowBookForm").validate({
				onkeyup: false  ,
				rules: {
					'user.loginName': {
						remote: "${ctx}/api/user/loginNameIsNotExist"
					}
				},
				messages: {
					'user.loginName': {
						remote: "ID不存在"
					}
				}
			});
			
		});
		
		function updateBook(id,numInstock){
			
			$("#borrowBookForm #bookId").attr("value",id);
			$("#borrowBookForm #name").attr("value",$("tr#"+id+" td:eq(0)").text());
			$("#borrowBookForm #numInstock").attr("value",numInstock);
			
			$('#borrowBookModal').modal('show');
			$("#borrowBookForm #loginName").focus();
			
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
			<thead><tr><th>书名</th><th>作者</th><th style="width:94px">出版社</th><th style="width:52px">出版时间</th><th style="width:85px">库存 / 馆藏</th></tr></thead>
			<tbody>
			<c:forEach items="${bookList.content}" var="book">
				<tr id="${book.id}">
					<td>${book.name}</td>
					<td>${book.author}</td>
					<td>${book.press}</td>
					<td>
						<fmt:formatDate value="${book.publicationDate}" pattern="yyyy-MM" />
					</td>
					<td>
					${book.numInstock}
					/
					${book.numAll}
                	<button onclick=updateBook(${book.id},${book.numInstock}) class="btn pull-right" >借</button>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	    <tags:paging page="${bookList}" paginationSize="5"/>
	        <div class="clearfix"></div>
	 
		 	</div>
		 	
                        <div class="span3">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>Search</h4>
                                 <form id="searchform" action="${ctx}/admin/book/borrow" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-small focused " value="${param.search_LIKE_name}">
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
              <h3>借书登记</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="borrowBookForm" action="${ctx}/admin/book/borrow" method="post" class="form-horizontal">
                                          <div class="modal-body">
                                          <input type="text" id="bookId" name="book.id" class="hidden"/>
                                          <div class="control-group">
                                            <label class="control-label" for="name">书名</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="book.name" class="input-large" disabled/>
                                              </div>
                                          </div>   
                                          <div class="control-group">
                                            <label class="control-label" for="numInstock">在库</label>
                                            <div class="controls">
                                              <input type="text" id="numInstock" name="numInstock" class="input-large digits" min="1" disabled/>
                                            </div>
                                          </div>
                                          
                                          <div class="control-group">
                                            <label class="control-label" for="loginName">借书人</label>
                                            <div class="controls">
                                              <input type="text" id="loginName" name="user.loginName" class="input-large required" minlength="2" maxlength="20"/>
                                              <p class="help-block">用户ID格式: xxxx.zh</p>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="borrowDate">借书时间</label>
                                            <div class="controls">
                                              <input type="text" id="borrowDate" name="borrowDate"  class="input-large yyyy-MM-dd"/>
                                              <p class="help-block">格式 :2014-01-01</p>
                                            </div>
                                          </div>
                                          

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
