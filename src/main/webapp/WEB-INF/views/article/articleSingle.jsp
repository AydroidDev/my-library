<%@page import="java.util.Random"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page import="org.apache.shiro.SecurityUtils" %>
<%@ page import="com.ccb.library.service.account.ShiroDbRealm.ShiroUser"%>
<%
	ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
	if(user!=null){
		request.setAttribute("nowUserId", user.id);
	}
%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<link href="${ctx}/static/ueditor/third-party/SyntaxHighlighter/shCoreDefault.css" rel="stylesheet" />
<script src="${ctx}/static/ueditor/third-party/SyntaxHighlighter/shCore.js" type="text/javascript"></script>
<script>
	$(document).ready(function() {
		$("#inputForm").validate();
	});
	$(document).ready(function() {
		$(".article>table").attr("class","table table-striped table-bordered table-condensed");
	});
	$(document).ready(function(){
		SyntaxHighlighter.all();
	});
</script>

<style type="text/css">
.article img{
	margin: 10px 0px 5px 0px;
	padding: 1px;
	box-shadow: 0px 0px 1px #777;
}
.syntaxhighlighter code {
word-wrap:break-word; /* Internet Explorer 5.5+ */ 
white-space: pre-wrap; /* Firefox */
}
</style>
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
            
            <!-- Blog starts -->
            
            <div class="blog">
               <div class="row">
                  <div class="span12">
                     
                     <!-- Blog Posts -->
                     <div class="row">
                        <div class="span8">
                           <div class="posts">
                           
                              <!-- Each posts should be enclosed inside "entry" class" -->
                              <!-- Post one -->
                              <div class="entry">
                                 <h2><a href="#">${article.title}</a></h2>
                                 
                                 <!-- Meta details -->
                                 <div class="meta">
                                    <i class="icon-calendar"></i> <fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /> <i class="icon-user"></i> <a href="${ctx}/article/${article.user.id}">${article.user.name}</a> <i class="icon-folder-open"></i> <a href="${ctx}/article?search_EQ_${article.catalog.id}">${article.catalog.name }</a> 
                                    <span class="pull-right"><i class="icon-comment"></i> <a href="#comment">${article.commentCount} Comments</a></span>
                                    <shiro:hasRole name="admin">
                                    	<span class="pull-right"><i class="icon-trash"></i> <a onclick="{if(confirm('确定删除该文章?')){return true;}return false;}" href="${ctx}/article/delete/${article.id}">Delete</a>&nbsp;&nbsp;</span>
                                    	<span class="pull-right"><i class="icon-edit"></i> <a href="${ctx}/article/update/${article.id}">Edit</a>&nbsp;&nbsp;</span>
                                    </shiro:hasRole>
                                    <shiro:hasRole name="user">
                                    <c:if test="${not empty nowUserId}">
                                    	<c:if test="${nowUserId==article.user.id}">
                                    		<span class="pull-right"><i class="icon-trash"></i> <a onclick="{if(confirm('确定删除该文章?')){return true;}return false;}" href="${ctx}/article/delete/${article.id}">Del</a>&nbsp;&nbsp;</span>
	                                    	<span class="pull-right"><i class="icon-edit"></i> <a  href="${ctx}/article/update/${article.id}">Edit</a>&nbsp;&nbsp;</span>
                                    	</c:if>
                                    </c:if>
                                    </shiro:hasRole>
                                 </div>
                                 
                                 <!-- article -->
                                 <div class="article">${article.content}</div>
                              </div>
                              
                                 <div class="clearfix"></div>
                              
                              <!-- Comment section -->
                              <div id="comment" class="comments well">
                                 
                                    <div class="title"><h4>${article.commentCount} Comments</h4></div>
                                    
                                    <ul class="comment-list">
                                    <c:forEach items="${article.commentList}" var="comment" varStatus="s">
                                      <li id="comment-${s.index}" class="comment">
	                                        <a class="pull-left" href="#">
	                                          <img class="avatar" src="${ctx}/static/images/avatar/<% out.print(new Random().nextInt(9)); %>.jpg">
	                                        </a>
	                                        <div class="comment-author">
	                                         		<a href="#">${comment.user.name}</a>
										  	</div>
                                          <div class="cmeta">Commented on&nbsp;&nbsp;<a href="#comment-${s.index}"><fmt:setLocale value="en_US"/> <fmt:formatDate value="${comment.createTime}" pattern="MMMM d, yyyy HH:mm:ss" /></a> </div>
                                          <hr/>
                                          <div><p>${comment.content}</p></div>
                                          <div class="clearfix"></div>
                                      </li>
                                    </c:forEach>
                                      <!--
                                      <li class="comment reply">
                                        <a class="pull-left" href="#">
                                          <img class="avatar" src="http://placekitten.com/64/64">
                                        </a>
                                          <div class="comment-author"><a href="#">Ashok</a></div>
                                          <div class="cmeta">Commented on 25/12/2012</div>
                                          <p>Nulla facilisi. Sed justo dui, scelerisque ut consectetur vel, eleifend id erat. Phasellus condimentum rutrum aliquet. Quisque eu consectetur erat.</p>
                                          <div class="clearfix"></div>
                                      </li>
                                        -->
                                    </ul>
                              </div>
                              
                              <!-- Comment posting -->
                              
                              <div class="respond well">
                                 <div class="title"><h4>Post Reply</h4></div>
                                 <shiro:user>
                                 <div class="form">
                                   <form id="inputForm" method="post" action="${ctx}/article/comment/create" class="form-horizontal">
                                   		<input type="hidden" name="article.id" value="${article.id}" id="article_id">
                                   		<input type="hidden" name="replyCommentId" id="reply_comment_id">
                                       <div class="control-group">
                                         <label class="control-label" for="comment">Comment</label>
                                         <div class="controls">
                                           <textarea class="input-xlarge require" name="content"id="comment" rows="5"></textarea>
                                         </div>
                                       </div>
                                       <div class="form-actions">
                                         <button type="submit" class="btn">Submit</button>
                                         <button type="reset" class="btn">Reset</button>
                                       </div>
                                   </form>
                                 </div>
                                 </shiro:user>
                              </div>
                             <!-- Navigation -->
                              <div class="navigation button">
                              <c:if test="${not empty previousArticleId }">
                                    <div class="pull-left"><a href="${ctx}/article/detail/${previousArticleId}">&laquo; Previous Post</a></div>
                              </c:if>
                              <c:if test="${not empty nextArticleId }">  
                                    <div class="pull-right"><a href="${ctx}/article/detail/${nextArticleId}">Next Post &raquo;</a></div>
                              </c:if>
                                    <div class="clearfix"></div>
                              </div>
                              <div class="clearfix"></div>
                           </div>
                        </div>                        
                        <div class="span4">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>文章搜索</h4>
                                 <form method="get" id="searchform" action="${ctx}/article" class="form-search">
                                    <input type="text" name="search_LIKE_title" class="input-medium" value="${param.search_LIKE_title}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>

                              <div id="recentPost-right" class="widget">
                                 <h4>最新文章</h4>
                                 <p class="loading">loading recent posts...</p>
                              </div>
							  <div id="excerpt-right" class="widget">
                                 <h4>书摘</h4>
                                 <p class="loading">loading...</p>
                              </div>
                           </div>                                                
                        </div>
                     </div>
                     
                     
                     
                  </div>
               </div>
            </div>
            
            
            <!-- Service ends -->
            
            <!-- CTA starts -->
            
            
         </div>
      </div>
   </div>
</div>   

<!-- Content ends --> 
<script type="text/javascript">         
        $(document).ready(function(){     
           jQuery.ajax( {     
                type : 'GET',     
                contentType : 'application/json',     
                url : '${ctx}/article/topArticle/latest',     
                dataType : 'json',     
                success : function(data) {
                  var resultRight="";
                  if (data != null) {
                	resultRight+="<ul>";
                    $.each(data, function(i, item) {
                      var href = "${ctx}/article/detail/"+item.id;
                      resultRight += "\<li>\<a href=\""+href+"\"\>"+item.title+"\</a\>\</li\>";
                    });
                    resultRight+="</ul>";
                    $('#recentPost-right > .loading').remove();
                    $('#recentPost-right').append(resultRight);
                  }     
                },     
                error : function() {
                	$('#recentPost-right > .loading').remove();
                	$('#recentPost-right').append("<p>load Failed.<p>")    
                }     
          });
           
           jQuery.ajax( {     
               type : 'GET',     
               contentType : 'application/json',     
               url : '${ctx}/api/excerpt?ver='+Math.random(),     
               dataType : 'json',     
               success : function(excerpt) {
                 var resultRight="";
                 if (excerpt.content) {
                	 resultRight+= "<p>"+excerpt.content+"</p>";
                	 resultRight+="<div class=\"tauthor pull-right\">——"+excerpt.bookAuthor+"  <span class=\"color\">《"+excerpt.bookName+"》</span></div>";
                	 resultRight+="<div class=\"clearfix\"></div>";

                   $('#excerpt-right > .loading').remove();
                   $('#excerpt-right').append(resultRight);
                 }else{
                	$('#excerpt-right > .loading').remove();
                    $('#excerpt-right').append("<p>load Failed.<p>")
                 }
               },     
               error : function() {
               	$('#excerpt-right > .loading').remove();
               	$('#excerpt-right').append("<p>load Failed.<p>")    
               }     
         });
              
        });
</script>   

</body>
</html>