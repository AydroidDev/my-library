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
<title>-首页</title>
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
		<div id="notify" class="alert alert-block hidden">
		  <a class="close" data-dismiss="alert" href="#">×</a>
		  <h4 class="alert-heading">Message:</h4>
	    </div>		
	   <div class="container">
      	<div class="row">
         <div class="span12">
         
             <div class="flexslider">
              <ul class="slides">
                  <!-- Each slide should be enclosed inside li tag. -->
                  
                  <!-- Slide #1 -->
                <li>
                  <!-- Image -->
                  <img src="${ctx}/static/images/4.jpg" />
                  <!-- Caption -->
                  <div class="flex-caption" style="background: rgba(105, 36, 36, 0.8);">
                     <!-- Title 
                     <h3><span>Ericka Title #1</span></h3>
                     -->
		  <div class="manager">
		  <ul id="myTab" class="nav nav-tabs">
            <li class="active"><a href="#search1" data-toggle="tab">图书搜索</a></li>
            <li><a href="#search2" data-toggle="tab">电子书搜索</a></li>
            <li><a href="#search3" data-toggle="tab">文章搜索</a></li>
          </ul>
          </div>
          <div id="myTabContent" class="tab-content" >
            <div class="tab-pane fade in active" id="search1">
                                 <form id="searchform" action="${ctx}/book" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-medium search-query" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>
            <div class="tab-pane fade" id="search2">
                                 <form id="searchform" action="${ctx}/ebook" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-medium search-query" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>	
            <div class="tab-pane fade" id="search3">
                                 <form id="searchform" action="${ctx}/article" class="form-search">
                                    <input type="text" name="search_LIKE_title" class="input-medium search-query" value="${param.search_LIKE_title}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>					
			</div>		

                  </div>
                </li>
                
                
              </ul>
            </div>
            
            <!-- Service starts -->
            
            <div class="services">
                  <div class="row">
                      <div class="span4">  
                        <div class="service" style="min-height:160px">
                           <!-- Icon & title. Font Awesome icon used. -->
                           <h5><span><i class="icon-coffee"></i> <a style="color:#666"" href="${ctx}/article">最新文章</a></span></h5>
                              <div id="recentPost-right">
                                 <p class="loading">loading recent posts...</p>
                              </div>
                        </div>
                      </div>
                      <div class="span4">  
                        <div class="service" style="min-height:160px">
                           <!-- Icon & title. Font Awesome icon used. -->
                           <h5><span><i class="icon-book"></i> <a style="color:#666"" href="${ctx}/book">到库新书</a></span></h5>
                        	  <div id="latestBook">
                                 <p class="loading">loading...</p>
                              </div>
                        </div>                     
                      </div>
                      <div class="span4">
                        <div class="service" style="min-height:160px">
                           <!-- Icon & title. Font Awesome icon used. -->
                           <h5><span><i class="icon-bullhorn"></i> 还书通告</span></h5>
                        	  <div id="returnBookNotify">
                                 <p class="loading">loading...</p>
                              </div>
                        </div>                     
                      </div>  
                     
                        <!-- Service #3 
                        <div class="span3 service" style="height:200px">
                           <h5><span><i class="icon-home"></i> 关于</span></h5>
                           <p>三更灯火五更鸣&nbsp;&nbsp;&nbsp;正是男儿读书时<br>黑发不知勤学早&nbsp;&nbsp;&nbsp;白发方悔读书迟</p>
                        </div>  
                        -->
                        
                  </div>
            </div>
            
            <!-- Serivce ends -->
            
            
            
      	 </div>
        </div>
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
                url : '${ctx}/book/shouldReturnBooks?ver='+Math.random(),     
                dataType : 'json',     
                success : function(data) {
                  var result = "";
                  var resultMsg = "";
                  if (data) {
                	result+="<ul>";
                    $.each(data, function(i, item) {
                      if(i<5){
                    	  if(item.shouldReturnDate==null){
                              result += "\<li>"+item.user.name+"，请归还《"+item.book.name+"》"+"</li\>";
                              }else{
                              result += "\<li>"+item.user.name+"，所借《"+item.book.name+"》 将在"+item.shouldReturnDate+"到期"+"</li\>"; 
                          }  
                      }
                      if(item.user.id==${nowUserId}){
                     	 if(item.shouldReturnDate==null){
                          resultMsg += "\<p\>"+ "您所借的《"+item.book.name+"》已到期，请速速归还!"+"</p\>";
                          }else{
                          resultMsg += "\<p\>"+ "您所借《"+item.book.name+"》 将在"+item.shouldReturnDate+"到期，请注意。"+"</p\>";  
                      }
                      }
                    });
                    result+="</ul>";
                    $('#returnBookNotify > .loading').remove();
                    $('#returnBookNotify').append(result);
                    if(resultMsg){
                    $('#notify').removeClass("hidden").append(resultMsg);
                    }
                  }else{
                      $('#returnBookNotify > .loading').remove();
                      $('#returnBookNotify').append("\<p>大家都很按时还书！</p\>");
                  }
                  if(result=="<ul></ul>"){
                	  $('#returnBookNotify > .loading').remove();
                      $('#returnBookNotify').append("\<p>大家都很按时还书！</p\>");
                  }
                },     
                error : function() {
                	$('#returnBookNotify > .loading').remove();
                	$('#returnBookNotify').append("<p>load Failed.<p>")    
                }     
           });
            jQuery.ajax( {     
                type : 'GET',     
                contentType : 'application/json',     
                url : '${ctx}/book/latestBook',     
                dataType : 'json',     
                success : function(data) {
                  var result = "";
                  if (data != null) {
                	result+="<ul>";
                    $.each(data, function(i, item) {
                      result += "\<li><a href=\"${ctx}/book?search_EQ_id="+item.id+"\">《"+item.name+"》"+"</a></li\>";
                    });
                    result+="</ul>";
                    $('#latestBook > .loading').remove();
                    $('#latestBook').append(result);
                  }   
                },     
                error : function() {
                	$('#latestBook > .loading').remove();
                	$('#latestBook').append("<p>load Failed.<p>")    
                }     
           });
           jQuery.ajax( {     
                type : 'GET',     
                contentType : 'application/json',     
                url : '${ctx}/article/topArticle/latest',     
                dataType : 'json',     
                success : function(data) {
                  var resultRight="";
                  if (data != null) {
                	resultRight+="<ul>";
                	var nowDate = new Date();
                    $.each(data, function(i, item) {
                      var href = "${ctx}/article/detail/"+item.id;
                      var modifyTime = new Date(item.modifyTime.replace("-", "/").replace("-", "/"));
                      if((nowDate.getTime()-modifyTime.getTime())/(1000 * 60 * 60 * 24)<=7){
                      	resultRight += "<li><a href=\""+href+"\">"+item.title+"</a>&nbsp;&nbsp;&nbsp;<span style=\"color: #FF9B00\">NEW</span></li>";
                      }else{
                    	resultRight += "<li><a href=\""+href+"\">"+item.title+"</a></li>";
                      }
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
              
        });
        
        
</script>   
<script>
		/* Flex Slider */

		$(window).load(function() {
		  $('.flexslider').flexslider({
			animation: "slide",
			controlNav: true,
			pauseOnHover: true,
			slideshowSpeed: 15000
		  });
		});
		
		</script>
</body>
</html>
