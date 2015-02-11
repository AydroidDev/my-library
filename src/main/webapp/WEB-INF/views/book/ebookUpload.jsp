<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<title>图书管理</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/uploadify/uploadify.css">
    <script type="text/javascript" src="${ctx}/static/uploadify/jquery.uploadify-3.1.min.js?f=<%=System.currentTimeMillis()%>"></script>
    <script type="text/javascript">
    $(document).ready(function(){
        uploadify();
    });
    var idName="";
    function uploadify(){
        $("#file_upload").uploadify({  
            'height'        : 27,   
            'width'         : 80,    
            'buttonText'    : '上传',  
            'swf'           : '${ctx}'+'/static/uploadify/uploadify.swf?ver=' + Math.random(),  
            'uploader'      : '${ctx}'+'/uploadEbook;jsessionid='+$("#sessionUID").val(),  
            'auto'          : false, 
            'fileSizeLimit' : '51200KB', 
            'fileTypeExts'  : '*.pdf;*.doc;*.docx; *.zip; *.rar; *.mobi; *.epub', 
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
    }
    </script>

</head>

<body>
	<!-- Content starts -->
<div class="content">
   <div class="container">
      <div class="row">
         <div class="span12">
 				<div class="hero">
                   <!-- Title. Don't forget the <span> tag -->
                   <h3><span>电子书上传</span></h3>
                </div>
<div class="sidebar span6">
<div class="widget">
<input id='sessionUID' value='<%=session.getId()%>' type="hidden"/>
    <table id="nhc01_infoGrid2"></table>
    <div id="nhc01_editInfoDiv2" style="padding: 5px; width: 370px;">
    <table class="divTable">
    <tr>
    <td>书名:</td>
    <td>
    <input id="tempFileName" readonly="readonly" style="width:320px;_width:320px; " />
    </td>
    </tr>
    <tr>
    <td>列表:</td>
    <td>
    <input type="file" name="uploadify" id="file_upload" /><hr>  
    <a class="button" onclick="startUpload();" href="javascript:void(0);">开始上传</a>   
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
                              




</body>
</html>
