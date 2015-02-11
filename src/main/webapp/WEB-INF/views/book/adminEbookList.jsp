<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>图书管理</title>
<script type="text/javascript">


		function updateBook(id){
			
			
			$("#updateBookForm #id").attr("value",id);
			$("#updateBookForm #name").attr("value",$("tr#"+id+" td:eq(0)").text());
			$('#updateBookModal').modal('show');
			
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
						<li class="dropdown"><a class="dropdown-toggle"
							data-toggle="dropdown" href="#">图书管理 <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="${ctx}/admin/book">库存维护</a></li>
								<li><a href="${ctx}/admin/book/borrow">借书登记</a></li>
								<li><a href="${ctx}/admin/book/return">还书登记</a></li>
							</ul></li>
						<li class="active"><a href="${ctx}/admin/ebook">电子书管理</a></li>
					</ul>
				</div>
				
	<div class="content">
	   <div class="container">
      	<div class="row">
         <div class="span12">
            
            <div class="row">
               <div class="span9">
	
	
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>书名</th><th style="width:70px">上传时间</th><th style="width:40px">上传人</th><th style="width:94px">操作</th></tr></thead>
		<tbody>
		<c:forEach items="${bookList.content}" var="book">
			<tr id="${book.id}">
				<td>${book.name}</td>
				<td>
					<fmt:formatDate value="${book.uploadTime}" pattern="yyyy-MM-dd" />
				</td>
				<td>${book.user.name}</td>
				
				<td><a onclick=updateBook(${book.id}) href="#">管理</a>&nbsp;&nbsp;<a onclick="{if(confirm('确定删除该电子书?')){return true;}return false;}" href="${ctx}/admin/ebook/delete/${book.id}">删除</a></td>
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
                                 <form id="searchform" action="${ctx}/admin/ebook" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-small" value="${param.search_LIKE_name}">
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
          <div id="updateBookModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>管理电子书</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="updateBookForm" action="${ctx}/admin/ebook/update" method="post" class="form-horizontal">
                                          <div class="modal-body">
                                          <input type="text" id="id" name="id" class="hidden"/>
                                          <div class="control-group">
                                            <label class="control-label" for="name">书名</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="name" class="input-large required" minlength="1" maxlength="100"/>
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
