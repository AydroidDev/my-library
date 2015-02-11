<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<body>

<!-- Content starts -->
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
            
            <!-- Blog starts -->
            
            <div class="blog">
               <div class="row">
                  <div class="span12">
                     
                     <!-- Blog Posts -->
                     <div class="row">
                        <div class="span8">
							<c:if test="${empty articles}">
								<div id="message" class="alert alert-info"><button data-dismiss="alert" class="close">×</button>
								<h2>Nothing Found</h2>
								<p>Sorry, but nothing matched your search criteria. Please try again with some different keywords.</p>
								</div>
							</c:if>
							<c:if test="${not empty articles}">
                           <div class="posts">
                           
                              <!-- Each posts should be enclosed inside "entry" class" -->
								<c:forEach items="${articles.content}" var="article">
	                              <div class="entry">
	                                 <h2><a href="${ctx}/article/detail/${article.id}">${article.title}</a></h2>
	                                 
	                                 <!-- Meta details -->
	                                 <div class="meta">
	                                    <i class="icon-calendar"></i> <fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /> <i class="icon-user"></i> <a href="${ctx}/article/${article.user.id}">${article.user.name}</a> <i class="icon-folder-open"></i> <a href="${ctx}/article?search_EQ_catalog.id=${article.catalog.id}">${article.catalog.name }</a> <span class="pull-right"><i class="icon-comment"></i> <a href="${ctx}/article/detail/${article.id}#comment">${article.commentCount} Comments</a></span>
	                                 </div>
	                                 <!-- Summary -->
	                                 <div><p>${article.summary}</p></div>
	                                 <div class="button"><a href="${ctx}/article/detail/${article.id}">Read More...</a></div>
	                              </div>
								</c:forEach>

                              <!-- Pagination -->
                              <tags:paging page="${articles}" paginationSize="5"/>
                              
                              <div class="clearfix"></div>
                              
                           </div>
							</c:if>
                        </div>                        
                        <div class="span4">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>文章搜索</h4>
                                 <form id="searchform" action="${ctx}/article" class="form-search">
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