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
	$.validator.addMethod("isDate", function(value, element){
		var ereg = /^(\d{1,4})(-)(\d{1,2})$/;
		var r = value.match(ereg);
		if (r == null) {
			return false;
		}
		var d = new Date(r[1], r[3] - 1);
		var result = (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3]);
		return this.optional(element) || (result);
	}, "请输入正确的日期");

		$(document).ready(function() {
			//为inputForm注册validate函数
			$("#inputForm").validate({
				onkeyup: false  
			});
			
		});
		
		function updateBook(id,numInstock,numAll){
			
			
			$("#updateBookForm #id").attr("value",id);
			$("#updateBookForm #name").attr("value",$("tr#"+id+" td:eq(0)").text());
			$("#updateBookForm #author").attr("value",$("tr#"+id+" td:eq(1)").text());
			$("#updateBookForm #press").attr("value",$("tr#"+id+" td:eq(2)").text());
			$("#updateBookForm #publicationDate").attr("value",$.trim($("tr#"+id+" td:eq(3)").text()));
			$("#updateBookForm #numInstock").attr("value",numInstock);
			$("#updateBookForm #numAll").attr("value",numAll);
			$("#updateBookForm #contributor").attr("value",$("tr#"+id+" td:eq(5)").text());
			
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
			<thead><tr><th>书名</th><th>作者</th><th style="width:94px">出版社</th><th style="width:52px">出版时间</th><th  style="width:65px">库存 / 馆藏</th><th  style="width:40px">捐书人</th><th  style="width:68px">操作</th></tr></thead>
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
					</td>
					<td>${book.contributor}</td>
					<td><a onclick="{updateBook(${book.id},${book.numInstock},${book.numAll})}" href="#">更新</a>&nbsp;&nbsp;<a onclick="{if(confirm('确定删除该书?')){return true;}return false;}" href="${ctx}/admin/book/delete/${book.id}">删除</a></td>
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
                                 <form id="searchform" action="${ctx}/admin/book" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-small" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>
                              <div class="widget">
                                     <h4>New Book&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      <a data-toggle="modal" href="#myModal" class="btn">新书入库</a>
                                      </h4>
                                      
                                      
          <!-- modal content -->
          <div id="myModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>New book</h3>
            </div>
            
                                      <!-- new book form-->
                                      <form id="inputForm" action="${ctx}/admin/book/new" method="post" class="form-horizontal">
                                          <div class="modal-body">
                                          <div class="control-group">
                                            <label class="control-label" for="name">书名</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="name" class="input-large required" minlength="1" maxlength="100"/>
                                            </div>
                                          </div>   
                                          <div class="control-group">
                                            <label class="control-label" for="author">作者</label>
                                            <div class="controls">
                                              <input type="text" id="author" name="author" class="input-large required" minlength="1" maxlength="50"/>
                                            </div>
                                          </div>
                                           <div class="control-group">
                                            <label class="control-label" for="numAll">数量</label>
                                            <div class="controls">
                                              <input type="text" id="numAll" name="numAll" class="input-large required digits" min="1" max="1000"/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="press">出版社</label>
                                            <div class="controls">
                                              <input type="text" id="press" name="press" class="input-large required" minlength="1" maxlength="50"/>
                                            </div>
                                          </div>
                                          <!-- 
                                           -->
                                          <div class="control-group">
                                            <label class="control-label" for="publicationDate">出版时间</label>
                                            <div class="controls">
                                              <input type="text" id="publicationDate" name="publicationDate"  class="input-large isDate"/>
                                              <p class="help-block">格式 :2014-12</p>
                                            </div>
                                          </div>
                                          
                                          <div class="control-group">
                                            <label class="control-label" for="contributor">捐书人</label>
                                            <div class="controls">
                                              <input type="text" placeholder="开发三处" id="contributor" name="contributor" class="input-large" minlength="1" maxlength="20"/>
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
                                   
          <!-- modal content -->
          <div id="updateBookModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>修改库存</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="updateBookForm" action="${ctx}/admin/book/update" method="post" class="form-horizontal">
                                          <div class="modal-body">
                                          <input type="text" id="id" name="id" class="hidden"/>
                                          <div class="control-group">
                                            <label class="control-label" for="name">书名</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="name" class="input-large required" minlength="1" maxlength="100"/>
                                              </div>
                                          </div>   
                                          <div class="control-group">
                                            <label class="control-label" for="numInstock">在库</label>
                                            <div class="controls">
                                              <input type="text" id="numInstock" name="numInstock" class="input-large required digits" min="1" max="1000"/>
                                            </div>
                                          </div>
                                          
                                           <div class="control-group">
                                            <label class="control-label" for="numAll">馆藏</label>
                                            <div class="controls">
                                              <input type="text" id="numAll" name="numAll" class="input-large required digits" min="1" max="1000"/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="author">作者</label>
                                            <div class="controls">
                                              <input type="text" id="author" name="author" class="input-large required" minlength="1" maxlength="50"/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="press">出版社</label>
                                            <div class="controls">
                                              <input type="text" id="press" name="press" class="input-large required" minlength="1" maxlength="50"/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="publicationDate">出版时间</label>
                                            <div class="controls">
                                              <input type="text" id="publicationDate" name="publicationDate"  class="input-large isDate"/>
                                              <p class="help-block">格式 :2014-12</p>
                                            </div>
                                          </div>
                                          
                                          <div class="control-group">
                                            <label class="control-label" for="contributor">捐书人</label>
                                            <div class="controls">
                                              <input type="text" placeholder="开发三处" id="contributor" name="contributor" class="input-large" minlength="1" maxlength="20"/>
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
