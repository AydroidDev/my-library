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
                                       <span><a href='${ctx}/ebook?search_EQ_user.id=${user.id}'>更多</a></span>
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
			
         </div>
      </div>
   </div>
</div>   


<!-- Content ends --> 

</body>
</html>