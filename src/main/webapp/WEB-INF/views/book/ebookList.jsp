<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>-电子书</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/uploadify/uploadify.css">
    <script type="text/javascript" src="${ctx}/static/uploadify/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript">
    $(document).ready(function(){
            setTimeout(function(){
        		uploadify();
            },10);
    });
    var idName="";
    function uploadify(){
        $("#file_upload").uploadify({  
            'height'        : 27,   
            'width'         : 80,    
            'buttonText'    : '上传',  
            'swf'           : '${ctx}'+'/static/uploadify/uploadify.swf',  
            'uploader'      : '${ctx}'+'/uploadEbook;jsessionid='+$("#sessionUID").val(),  
            'auto'          : false, 
            'fileSizeLimit' : '51200KB', 
            'fileTypeExts'  : '*.pdf;*.doc;*.docx; *.zip; *.rar; *.mobi; *.chm; *.epub', 
            'cancelImg' :  '${ctx}'+'/static/uploadify/uploadify-cancel.png',
           // 'uploadLimit' : 3, 
           // 'formData'      : {'userName':'','content':''},
           //'removeCompleted' : true,
           //'removeTimeout' : 8,
            'successTimeout' : 300,
            'onUploadStart' : function(file) {
            },  
            'onUploadSuccess':function(file, data, response){  
//                alert('The file ' + file.name + ' was successfully uploaded with a response of ' + response + ':' + data);
                $("#tempFileName").val(file.name);
                $("#"+idName).val(data);
               // if (data.indexOf("ERROR")==0) {
               // 	alert('The file ' + file.name + ' uploaded error. Cause ' + data.substring(5));
               // }
            },  
            'onUploadComplete':function(){  
               // $('#importLispDialog').window('close');  
            },
            
            // Triggered when a file upload returns an error
            'onUploadError' : function(file, errorCode, errorMsg) {
                // Load the swfupload settings
                var settings = this.settings;

                // Set the error string
                var errorString = 'Error';
                switch(errorCode) {
                    case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
                    	if(errorMsg==403){
                    	errorString = '禁止匿名用户上传';
                    	alert(errorString);
                    	}else if(errorMsg==400){
                    	errorString = '《'+file.name+'》已经存在';
                    	alert(errorString);
                    	}else{
                        errorString = 'HTTP Error (' + errorMsg + ')';
                    	}
                        break;
                    case SWFUpload.UPLOAD_ERROR.MISSING_UPLOAD_URL:
                        errorString = 'Missing Upload URL';
                        break;
                    case SWFUpload.UPLOAD_ERROR.IO_ERROR:
                        errorString = 'IO Error';
                        break;
                    case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
                        errorString = 'Security Error';
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                        alert('The upload limit has been reached (' + errorMsg + ').');
                        errorString = 'Exceeds Upload Limit';
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
                        errorString = 'Failed';
                        break;
                    case SWFUpload.UPLOAD_ERROR.SPECIFIED_FILE_ID_NOT_FOUND:
                        break;
                    case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
                        errorString = 'Validation Error';
                        break;
                    case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
                        errorString = 'Cancelled';
                        this.queueData.queueSize   -= file.size;
                        this.queueData.queueLength -= 1;
                        if (file.status == SWFUpload.FILE_STATUS.IN_PROGRESS || $.inArray(file.id, this.queueData.uploadQueue) >= 0) {
                            this.queueData.uploadSize -= file.size;
                        }
                        // Trigger the onCancel event
                        if (settings.onCancel) settings.onCancel.call(this, file);
                        delete this.queueData.files[file.id];
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
                        errorString = 'Stopped';
                        break;
                }
            }
        });  
    }
    function startUpload(name){  
                idName=name;    
             $('#file_upload').uploadify('upload','*');  
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
            	result+="<tr class=\"comment\"><td colspan=\"5\">";
            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div class=\"ptable\">";
            	
                $.each(data, function(i, comment) {
               	  j=i;
                  result+="<div id=\"comment"+comment.id+"\" class=\"pline\"><span class=\"color\">"+comment.user.name+"：</span>"+comment.content;
                  if(comment.user.id==<shiro:principal property="id"/> || <shiro:principal property="id"/>==-1){
                  result+=" <a onclick=\"delComment("+comment.id+","+bookId+")\" href=\"javascript:void(0)\" class=\"pull-right\"><i class=\"icon-trash\"></i></a>";
                  }
                  result+="</div>"
                });
                
                result+="</div><textarea style=\"height: 46px; width: 428px;\" class=\"input-xlarge required\" name=\"content\" id=\"commentContent\" rows=\"1\"></textarea> <div class=\"button pull-right\" ><a class=\"btn\" id=\"commentBtn\" data-loading-text=\"评论中\" onclick=postComment("+bookId+") href=\"javascript:void(0)\">评论</a></div></div>";
                result+="</td></tr>";
              }
			  if(j==-1){
				result="";
            	result+="<tr class=\"comment\"><td colspan=\"5\">";
            	result+="<div  id=\"slide\" class=\"pdetails\" style=\"margin-top: 2px;margin-bottom: 5px; display:none;\"><div class=\"ptable blank\">";
                result+="<div class=\"pline\"><span class=\"color\">暂无评论，快抢沙发！</span></div>";          	
                result+="</div><textarea style=\"height: 46px; width: 428px;\" class=\"input-xlarge required\" name=\"content\" id=\"commentContent\" rows=\"1\"></textarea> <div class=\"button pull-right\" ><a class=\"btn\" id=\"commentBtn\" data-loading-text=\"评论中\" onclick=postComment("+bookId+") href=\"javascript:void(0)\">评论</a></div></div>";
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
            	alert("评论失败:请重新刷新页面。");  
            	}
            },  
            error:function(e) {  
                alert("评论失败："+e);  
            }  
        });
        $("#commentBtn").button('reset');
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
                   <h3><span>电子书列表</span></h3>
                </div>
            
            <div class="row">
               <div class="span8">
	
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th><a href="${ctx}/ebook?sortType=commentcount" >书名</a></th><th style="width:70px"><a href="${ctx}/ebook" >上传时间</a></th><th style="width:40px">上传人</th><th style="width:42px"><a href="${ctx}/ebook?sortType=downloadcount" >下载量</a></th><th style="width:20px"></th></tr></thead>
		<tbody>
		<c:forEach items="${bookList.content}" var="book">
			<tr id="${book.id}">
				<td>${book.name} &nbsp;&nbsp;<a href="javascript:void(0)" onclick=showComment(${book.id})><i class="icon-comment"></i> ${book.commentCount}</a></td>
				<td>
					<fmt:formatDate value="${book.uploadTime}" pattern="yyyy-MM-dd" />
				</td>
				<td><a href="${ctx}/console/about?id=${book.user.id}">${book.user.name}</a></td>
				<td>${book.downloadCount}</td>
				<td><a href="${ctx}/ebook/download/${book.id}" target="_blank"><i class="icon-download-alt"></i></a></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	    <tags:paging page="${bookList}" paginationSize="5"/>
	        <div class="clearfix"></div>
	 
		 	</div>
		 	
                        <div class="span4">
                           <div class="sidebar">
                              <!-- Widget -->
                              <div class="widget">
                                 <h4>Search</h4>
                                 <form id="searchform" action="${ctx}/ebook" class="form-search">
                                    <input type="text" name="search_LIKE_name" class="input-medium" value="${param.search_LIKE_name}">
                                    <button type="submit" class="btn">Search</button>
                                 </form>
                              </div>
							  <div id="excerpt-right" class="widget">
                                 <h4>书摘</h4>
                                 <p class="loading">loading...</p>
                              </div>
                           
                              <div class="widget">
<input id='sessionUID' value='<%=session.getId()%>' type="hidden"/>
    <table id="nhc01_infoGrid2"></table>
    <div id="nhc01_editInfoDiv2" style="padding: 5px; width: 235px; ">
    <table class="divTable">
    <tr>
    <td>书名:</td>
    <td>
    <input id="tempFileName" readonly="readonly" style="width:160px;_width:160px; " />
    </td>
    </tr>
    <tr>
    <td>列表:</td>
    <td>
    <input type="file" name="uploadify" id="file_upload" /><hr>  
    <a class="button" onclick="startUpload();" href="javascript:void(0);">开始上传</a>&nbsp;&nbsp;
    <a class="button" href="javascript:$('#file_upload').uploadify('cancel', '*')">取消所有上传</a>   
    </td>
    </tr>  
    </table>
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
