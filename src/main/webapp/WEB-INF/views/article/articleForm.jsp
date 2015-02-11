<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>


<html>
<head>
	<script type="text/javascript">window.UEDITOR_HOME_URL = "${ctx}/static/ueditor/";</script>
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/ueditor/editor_config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/ueditor/editor_all.js"></script>
<script>
	$(document).ready(function() {
		$("#inputForm").validate();
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
			<div class="hero">
                      <!-- Title. Don't forget the <span> tag -->
				<c:if test="${action == 'create'}">
					<h3><span>发表文章</span></h3>
				</c:if>
				<c:if test="${action == 'update'}">
					<h3><span>修改文章</span></h3>
				</c:if>					
            </div>
      <div class="row">
         <div class="span12">
			<form id="inputForm" action="${ctx}/article/${action}" method="post" class="form-horizontal">
				<input type="hidden" name="id" value="${article.id}"/>
				<fieldset>
					<div class="control-group">
						<label for="title" class="control-label">标题:</label>
						<div class="controls">
							<input type="text" id="title" name="title" value="${article.title}" class="input-large required" maxlength="30"/>
						</div>
					</div>
					<shiro:user>
					<shiro:hasRole name="admin">
					<div class="control-group">
						<label for="catalog" class="control-label">分类:</label>
						<div class="controls">
							<form:select path="article.catalog.id" items="${allCatalog}"  itemValue="id" itemLabel="name"/>
						</div>
					</div>
					</shiro:hasRole>
					<shiro:hasRole name="user">
						<input type="hidden" name="catalog.id" value="-1"/>
					</shiro:hasRole>
					</shiro:user>
					
					<div class="control-group">
						<label for="editor" class="control-label">内容:</label>
						<div class="controls">
						<c:if test="${action == 'create'}">
							<script  id="editor" name="content" type="text/plain"></script>
						</c:if>
						<c:if test="${action == 'update'}">
							<script  id="editor" name="content" type="text/plain">${article.content}</script>
						</c:if>
						</div>				
					</div>
					<div class="form-actions">
						<input id="submit_btn" class="btn" type="submit" value="发表"/>&nbsp;
						<input id="cancel_btn" class="btn" type="button" value="返回" onclick="history.back()"/>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
         </div>
      </div>
   </div>
</div>   

<!-- Content ends --> 
<script type="text/javascript">
    //实例化编辑器
    window.UEDITOR_CONFIG.initialContent="";
    window.UEDITOR_CONFIG.initialFrameWidth="100%px";  //初始化编辑器宽度,默认1000
    window.UEDITOR_CONFIG.initialFrameHeight=250;  //初始化编辑器高度,默认320

    var ue = UE.getEditor('editor');
    ue.addListener('ready',function(){
        this.focus()
    });
</script>

</body>

</html>