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
			//借书按钮
			$('table tr').each(function(){
				var str = $.trim($(this).children("td:eq(6)").text());
				if(str){
					var instock = $(this).children("td:eq(6)").text().split("\/")[0];
					if(instock>0){
						$(this).find("#borrowButton").removeClass("hidden");
					}
				}
			});
			
		});
		
		
		function updateBook(id){
			
			$("#borrowBookForm #bookId").attr("value",id);
			var bookName = $.trim($("tr#"+id+" td:eq(0)").text());
			$("#borrowBookForm #name").attr("value",bookName.substring(0,bookName.lastIndexOf(" ")));
			$("#borrowBookForm #author").attr("value",$("tr#"+id+" td:eq(1)").text());
			$("#borrowBookForm #press").attr("value",$("tr#"+id+" td:eq(2)").text());
			$("#borrowBookForm #publicationDate").attr("value",$.trim($("tr#"+id+" td:eq(3)").text()));
			$('#borrowBookModal').modal('show');
			
		};

	    // jQuery 定位让body的scrollTop等于pos的top，就实现了滚动
	    function scrollOffset(scroll_offset) {
	      $("body,html").animate({
	        scrollTop: scroll_offset
	      }, 0);
	    };
	    
		function showComment(bookId){
			var loadingImg = "<img src=\"${ctx}/static/images/load.gif\"/>";
			var count = parseInt($.trim($('#'+bookId+" td:eq(0) a").text()))
			var preId = $("tr.comment").prev().attr('id');
			$("tr.comment").remove();
			$("tr.borrowHis").remove();
			if(preId == bookId){
				return;
			}
		    var selected = $("tr#"+bookId).offset().top;
			scrollOffset(selected);
			$('#'+bookId+" td:eq(0) a").html(loadingImg);
	        var result = "";
	        jQuery.ajax( {     
	            type : 'GET',     
	            contentType : 'application/json',     
	            url : '${ctx}/ebook/comment/'+bookId+"?ver="+ Math.random(),     
	            dataType : 'json',     
	            success : function(data) {
	              result = "";
	              var j=-1;
	              if (data) {
	            	result+="<tr class=\"comment\"><td colspan=\"7\">";
	            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div class=\"ptable\">";
	            	
	                $.each(data, function(i, comment) {
	               	  j=i;
	                  result+="<div id=\"comment"+comment.id+"\" class=\"pline\"><span class=\"color\">"+comment.user.name+"：</span>"+comment.content;
	                  if(comment.user.id==<shiro:principal property="id"/> || <shiro:principal property="id"/>==-1){
	                  result+=" <a onclick=\"delComment("+comment.id+","+bookId+")\" href=\"javascript:void(0)\" class=\"pull-right\"><i class=\"icon-trash\"></i></a>";
	                  }
	                  result+="</div>"
	                });
	                
	                result+="</div><textarea style=\"height: 46px; width: 502px;\" class=\"input-xlarge required\" name=\"content\" id=\"commentContent\" rows=\"1\"></textarea> <div class=\"button pull-right\" ><a class=\"btn\" id=\"commentBtn\" data-loading-text=\"评论中\" onclick=postComment("+bookId+") href=\"javascript:void(0)\">评论</a></div></div>";
	                result+="</td></tr>";
	              }
				  if(j==-1){
					result="";
	            	result+="<tr class=\"comment\"><td colspan=\"7\">";
	            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div class=\"ptable blank\">";
	                result+="<div class=\"pline\"><span class=\"color\">暂无评论，快抢沙发！</span></div>";          	
	                result+="</div><textarea style=\"height: 46px; width: 502px;\" class=\"input-xlarge required\" name=\"content\" id=\"commentContent\" rows=\"1\"></textarea> <div class=\"button pull-right\" ><a class=\"btn\" id=\"commentBtn\" data-loading-text=\"评论中\" onclick=postComment("+bookId+") href=\"javascript:void(0)\">评论</a></div></div>";
	                result+="</td></tr>";
				  }
				  $("tr#"+bookId).after(result);   
	       		  $("#slide").slideDown("slow");
				  count = j+1;
				  $('#'+bookId+" td:eq(0) a").html("<i class=\"icon-comment\"></i>&nbsp;"+count);

	            },     
	            error : function() {
	              $('#'+bookId+" td:eq(0) a").html("<i class=\"icon-comment\"></i>&nbsp;"+count);
	              alert("查看评论失败:请刷新页面后重试。"); 
	            }
	       });
		};

		
		function delComment(commentId,bookId){
			if(confirm('确认删除评论')){
				$.ajax({
					type:"GET",
					url:"${ctx}/ebook/comment/delete/"+commentId,
				});
				$('#comment'+commentId).remove();
				var count = parseInt($.trim($('#'+bookId+" td:eq(0) a").text())) - 1;
				$('#'+bookId+" td:eq(0) a").html("<i class=\"icon-comment\"></i>&nbsp;"+count);
			}
			
		};
		
		function postComment(bookId){
			$("#commentBtn").button('loading');
	        var detail = $.trim($("#commentContent").val()); 
	        if(!detail){
	        	alert("评论不能为空");
	        	$("#commentBtn").button('reset');
	        	return;
	        }
	        var bookComment = {'book.id':bookId,'content':detail};
	        $.ajax({  
	            type:"POST",  
	            url:"${ctx}/ebook/comment/create",  
	            data:bookComment,  
	            success:function(data){  
	            	if(data != -1){
					if($('.ptable').hasClass('blank')){
					$('.ptable').empty();
					$('.ptable').removeClass('blank');
					}
	 				$('#commentContent').val('');
					$('.ptable').append("<div id=\"comment"+data+"\" class=\"pline\"><span class=\"color\"><shiro:principal property="name"/>：</span>"+detail+" <a onclick=\"delComment("+data+","+bookId+")\" href=\"javascript:void(0)\" class=\"pull-right\"><i class=\"icon-trash\"></i></a></div>");
					var count = parseInt($.trim($('#'+bookId+" td:eq(0) a").text())) + 1;
					$('#'+bookId+" td:eq(0) a").html("<i class=\"icon-comment\"></i>&nbsp;"+count);
	            	}else{
	            	alert("评论失败:请刷新页面后重试。");  
	            	}
	            },  
	            error:function(e) {  
	                alert("评论失败："+e);  
	            }  
	        });
	        $("#commentBtn").button('reset');
		};
	    
		function showBorrowHis(bookId){
			var loadingImg = "<img src=\"${ctx}/static/images/load.gif\"/>";
			var count = parseInt($.trim($('#'+bookId+" td:eq(5) a").text()))
			var preId = $("tr.borrowHis").prev().attr('id');
			$("tr.comment").remove();
			$("tr.borrowHis").remove();
			if(preId == bookId){
				return;
			}
		    var selected = $("tr#"+bookId).offset().top;
			scrollOffset(selected);
			$('#'+bookId+" td:eq(5) a").html(loadingImg);
	        var result = "";
	        jQuery.ajax( {     
	            type : 'GET',     
	            contentType : 'application/json',     
	            url : '${ctx}/book/history/'+bookId+"?ver="+ Math.random(),     
	            dataType : 'json',     
	            success : function(data) {
	              result = "";
	              var j=-1;
	              if (data) {
	            	result+="<tr class=\"borrowHis\"><td colspan=\"7\">";
	            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div style=\"margin-bottom: 0px\" class=\"ptable\">";
	            	
	                $.each(data, function(i, item) {
	               	  j=i;
	               	  if(item.returnDate){
	                    result+="<div id=\"bookBorrow"+item.id+"\" class=\"pline\"><span class=\"color\">"+item.user.name+" </span>于"+item.borrowDate+"借阅此书，并在"+item.returnDate+"归还。";
	               	  }else{
	               		result+="<div id=\"bookBorrow"+item.id+"\" class=\"pline\"><span class=\"color\">"+item.user.name+" </span>于"+item.borrowDate+"借阅此书，"+"<span class=\"color\">尚未归还。</span>";  
	               	  }
	                  result+="</div>"
	                });
	                
	                result+="</td></tr>";
	              }
				  if(j==-1){
					result="";
	            	result+="<tr class=\"borrowHis\"><td colspan=\"7\">";
	            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div style=\"margin-bottom: 0px\"  class=\"ptable blank\">";
	                result+="<div class=\"pline\"><span class=\"color\">暂无人借阅</span></div>";          	
	                result+="</td></tr>";
				  }
				  $("tr#"+bookId).after(result);   
	       		  $("#slide").slideDown("slow");
				  count = j+1;
				  $('#'+bookId+" td:eq(5) a").html(count);

	            },     
	            error : function() {
	              $('#'+bookId+" td:eq(5) a").html(count);
	              alert("查看评论失败:请刷新页面后重试。"); 
	            }
	       });
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
				
	<div class="content">
	   <div class="container">
      	<div class="row">
         <div class="span12">
 				<div class="hero">
                   <!-- Title. Don't forget the <span> tag -->
                   <h3><span>书籍列表</span></h3>
                </div>
            
            <div class="row">
               <div class="span9">
	
	
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th><a href="${ctx}/book?sortType=commentcount" >书名</a></th><th style="width:52px">作者</th><th style="width:94px">出版社</th><th style="width:52px"><a href="${ctx}/book?sortType=publicationdate" >出版时间</a></th><th style="width:40px">捐书人</th><th style="width:40px"><a href="${ctx}/book?sortType=borrowcount" >借阅量</a></th><th style="width:75px">库存 / 馆藏</th></tr></thead>
			<tbody>
			<c:forEach items="${bookList.content}" var="book">
				<tr id="${book.id}">
					<td>${book.name} &nbsp;&nbsp;<a href="javascript:void(0)" onclick=showComment(${book.id})><i class="icon-comment"></i> ${book.commentCount}</a></td>
					<td>${book.author}</td>
					<td>${book.press}</td>
					<td>
						<fmt:formatDate value="${book.publicationDate}" pattern="yyyy-MM" />
					</td>
					<td>${book.contributor}</td>
					<td><c:if test="${book.borrowCount!=0}"><a href="javascript:void(0)" onclick=showBorrowHis(${book.id})></c:if>${book.borrowCount}</a></td>
					<td>
					<span class="color">${book.numInstock}</span> / ${book.numAll}
					<button id="borrowButton" class="hidden btn pull-right" onclick=updateBook(${book.id}) >借</button>
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
                                 <form id="searchform" action="${ctx}/book" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-small" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>
                              <div class="widget">
                                     <h4>New Book&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      <a data-toggle="modal" href="#myModal" class="btn">我要捐书</a>
                                      </h4>
                                      
                                      
          <!-- modal content -->
          <div id="myModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>New book</h3>
            </div>
            
                                      <!-- new book form-->
                                      <form id="inputForm" action="${ctx}/book/new" method="post" class="form-horizontal">
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

                                        </div>  
                                        <div class="modal-footer">
                                          <div class="form-actions">
							              <a href="#" class="btn" data-dismiss="modal" >后悔</a>
							              <button type="submit" class="btn btn-primary">捐!!!</button>
                                          </div>
							           	</div>
                                          
                                      </form>
            
            
            
          </div>
          <!-- modal end -->  
                                   
                              
                              
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


         <!-- modal content -->
          <div id="borrowBookModal" class="modal hide fade">
            <div class="modal-header">
              <button class="close" data-dismiss="modal">&times;</button>
              <h3>请仔细核对书籍信息</h3>
            </div>
            
                                      <!-- update book form-->
                                      <form id="borrowBookForm" action="${ctx}/book/borrow" method="post" class="form-horizontal">
                                          <div class="modal-body">
                                          <input type="text" id="bookId" name="book.id" class="hidden"/>
                                          <div class="control-group">
                                            <label class="control-label" for="name">书名</label>
                                            <div class="controls">
                                              <input type="text" id="name" name="name" class="input-large" disabled/>
                                              </div>
                                          </div>   
                                          <div class="control-group">
                                            <label class="control-label" for="author">作者</label>
                                            <div class="controls">
                                              <input type="text" id="author" name="author" class="input-large required" minlength="1" maxlength="50" disabled/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="press">出版社</label>
                                            <div class="controls">
                                              <input type="text" id="press" name="press" class="input-large required" minlength="1" maxlength="50" disabled/>
                                            </div>
                                          </div>
                                          <div class="control-group">
                                            <label class="control-label" for="publicationDate">出版时间</label>
                                            <div class="controls">
                                              <input type="text" id="publicationDate" name="publicationDate"  class="input-large isDate" disabled/>
                                            </div>
                                          </div>

                                        </div>  
                                        <div class="modal-footer">
                                          <div class="form-actions">
							              <a href="#" class="btn" data-dismiss="modal" >取消</a>
							              <button type="submit" class="btn btn-primary">借书</button>
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

<script type="text/javascript">
$(document).ready(function(){     
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
