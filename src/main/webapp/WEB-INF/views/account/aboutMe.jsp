<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>-个人资料</title>
<script type="text/javascript">
 $(function (){ 
	 $("#aum").popover({trigger:'hover'});
});
 
	function updateBook(id,bookId){
		$("#borrowBookForm #id").attr("value",id);
		$("#borrowBookForm #bookId").attr("value",bookId);
		$("#borrowBookForm #bookName").attr("value",$("tr#"+id+" td:eq(0)").text());
		$("#borrowBookForm #bookName1").attr("value",$("tr#"+id+" td:eq(0)").text());
		$("#borrowBookForm #bookAuthor").attr("value",$("tr#"+id+" td:eq(1)").text());
		$('#borrowBookModal').modal('show');
		
	};

</script>

</head>
<body>
<!-- Content starts -->

<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
         
            <c:if test="${not empty message}">
				<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">×</button>${message}</div>
			</c:if>
            
            <!-- Resume starts -->
            
            <div class="resume">
               <div class="row">
                  <div class="span12">
                     <h2>${user.name } <span class="rsmall"><span class="color">@</span> ${user.department } </span></h2>
                     <p></p>
                     <hr />
                     <!-- Resume -->
                     
                     <div class="row">
                        <div class="span12">
                        
                           <!-- About -->
                           <div class="rblock">
                              <div class="row">
                                 <div class="span3">
                                    <h4>关于我</h4>                            
                                 </div>
                                 <div class="span9">
                                    <div class="rinfo">
                                       <h5>用户名：${user.name }</h5>
                                       <a href="${ctx}/console/profile">修改密码</a>
                                       <div class="rmeta">用户等级：${allRoles[user.roles]}</div>
                                       <div class="rmeta">登 录 名  ：${user.loginName}</div>
                                       <div class="rmeta">部&nbsp;&nbsp;&nbsp;&nbsp;门&nbsp;&nbsp;&nbsp;：${user.department }</div>
                                       <div class="rmeta">贡 献 值  ：<a href="#" id="aum" title="积分规则" data-content="上传电子书得15分，通过本系统捐书得50分，发表书评得80分">${user.aum }分</a></div>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           
                           <!-- Education -->
                           <div class="rblock">
                              <div class="row">
                                 <div class="span3">
                                    <h4>在借书籍</h4>                            
                                 </div>
                                 <div class="span9">
                                    <div id="bookBorrowing" class="rinfo">

<c:if test="${not empty bookBorrows}">
		<table  class="table table-striped table-bordered table-condensed">
			<thead><tr><th>书名</th><th  style="mini-width:52px">作者</th><th  style="width:68px">借书日期</th><th  style="width:112px">应还日期</th></tr></thead>
			<tbody>
			<c:forEach items="${bookBorrows}" var="bookBorrow">
				<tr id="${bookBorrow.id}">
					<td>${bookBorrow.book.name}</td>
					<td>${bookBorrow.book.author}</td>
					<td>
					<fmt:formatDate value="${bookBorrow.borrowDate}" pattern="yyyy-MM-dd" />
					</td>
					<td>
					<fmt:formatDate value="${bookBorrow.shouldReturnDate}" pattern="yyyy-MM-dd" />
					<button onclick=updateBook(${bookBorrow.id},${bookBorrow.book.id}) class="btn pull-right" >还</button>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
</c:if>
<c:if test="${empty bookBorrows}">
 <div class="rmeta"><p>无</p></div>
</c:if>

                                    </div>
                                 </div>
                              </div>
                           </div>
                           
                           <!-- Skills -->
                           <div class="rblock">
                              <div class="row">
                                 <div class="span3">
                                    <h4>最近上传电子书</h4>                            
                                 </div>
                                 <div class="span9">
                                    <div class="rinfo">
                                       <!-- Class "rskills" is important -->
                                       <div id="uploadEbook" class="rskills"">
                                       <c:if test="${not empty ebooks}">
                                       <c:forEach items="${ebooks}" var="ebook"><span>《${ebook.name}》</span></c:forEach>
                                       <span><a href='${ctx}/ebook?search_EQ_user.id=<shiro:principal property="id"/>'>更多</a></span>
                                       </c:if>
                                       <c:if test="${empty ebooks}">
										  <div class="rmeta"><p>无</p></div>
									   </c:if>
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
			<!-- Resume ends -->
			
         <!-- modal content -->
          <div id="borrowBookModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>请确认还书信息</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="borrowBookForm" action="${ctx}/book/return" method="post" class="form-horizontal">
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
                                            <label class="control-label" for="bookAuthor">作者</label>
                                            <div class="controls">
                                              <input type="text" id="bookAuthor" name="book.author" class="input-large" disabled/>
                                            </div>
                                          </div>   
                                        </div>
                                        <input type="text" id="bookName1" name="book.name" class="hidden" />  
                                        <div class="modal-footer">
                                          <div class="form-actions">
							              <a href="#" class="btn" data-dismiss="modal" >取消</a>
							              <button type="submit" class="btn btn-primary">还书</button>
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