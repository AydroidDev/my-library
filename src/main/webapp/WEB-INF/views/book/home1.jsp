<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>图书管理</title>
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
				
	   <div class="container">
      	<div class="row">
         <div class="span12">
            
            <div class="row">
              			<div class="span7">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
		  <div class="manager">
		  <ul id="myTab" class="nav nav-tabs">
            <li class="active"><a href="#search1" data-toggle="tab">图书搜索</a></li>
            <li><a href="#search2" data-toggle="tab">电子书搜索</a></li>
            <li><a href="#search3" data-toggle="tab">文章搜索</a></li>
          </ul>
          </div>
          <div id="myTabContent" class="tab-content" style="height: 80px;">
            <div class="tab-pane fade in active" id="search1">
                                 <form id="searchform" action="${ctx}/book" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-xlarge" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>
            <div class="tab-pane fade" id="search2">
                                 <form id="searchform" action="${ctx}/ebook" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-xlarge" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>	
            <div class="tab-pane fade" id="search3">
                                 <form id="searchform" action="${ctx}/article" class="form-search">
                                    <input type="text" name="search_LIKE_title" class="input-xlarge" value="${param.search_LIKE_title}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
            </div>					
			</div>		
					
					
					
                              </div>
                           </div>   
                     <br/>
                     <div class="testimonial">
                           <div class="col-md-7">
                              <!-- Testimonial 2 -->
                              <div class="testi">
								 <h5><span class="color">书摘</span></h5>
                                 <div class="tquote">“你们很美，但你们是空虚的。”小王子仍然在对她们说，“没有人能为你们去死。当然啰，我的那朵玫瑰花，一个普通的过路人以为她和你们一样。可是，她单独一朵就比你们全体更重要，因为她是我浇灌的。因为她是我放在花罩中的。因为她是我用屏风保护起来的。因为她身上的毛虫（除了留下两三只为了变蝴蝶而外）是我除灭的。因为我倾听过她的怨艾和自诩，甚至有时我聆听着她的沉默。因为她是我的玫瑰。”</div>
                                 <div class="tauthor pull-right">-安东尼·德·圣-埃克苏佩里   <span class="color">《小王子》</span></div>
                                 <div class="clearfix"></div>
                              </div>
                              
                           </div>
                     </div>
                           
                           
                                                                       
                        </div>
		 	
                        <div class="span5">
                           <div class="sidebar">
                              <div id="recentPost-right" class="widget">
                                 <h4>最新文章</h4>
                                 <p class="loading">loading recent posts...</p>
                              </div>
                              <div id="returnBookNotify" class="widget">
                                 <h4>还书通告</h4>
                                 <p class="loading">loading...</p>
                              </div>
                              <div class="widget">
                                 <h4>About</h4>
                                 <p>三更灯火五更鸣&nbsp;&nbsp;&nbsp;正是男儿读书时<br>黑发不知勤学早&nbsp;&nbsp;&nbsp;白发方悔读书迟</p>
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

<script type="text/javascript">         
        $(document).ready(function(){     
            jQuery.ajax( {     
                type : 'GET',     
                contentType : 'application/json',     
                url : '${ctx}/book/shouldReturnBooks',     
                dataType : 'json',     
                success : function(data) {
                  var result = "";
                  if (data != null) {
                	result+="<ul>";
                    $.each(data, function(i, item) {
                      if(item.shouldReturnDate==null){
                      result += "\<li>"+item.user.name+"，请归还《"+item.book.name+"》，已到期"+"</li\>";
                      }else{
                      result += "\<li>"+item.user.name+"，所借《"+item.book.name+"》 将在"+item.shouldReturnDate+"到期"+"</li\>";  
                      }
                    });
                    result+="</ul>";
                    $('#returnBookNotify > .loading').remove();
                    $('#returnBookNotify').append(result);
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
              
        });
</script>   

</body>
</html>
