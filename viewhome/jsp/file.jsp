<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="cc.movein.mda.system.control.Query"%>
<html lang="zh_cn">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=3;"/>
		

		<meta name="format-detection" content="telephone=no" />
		<script src="/view/jqueryMobile/jquery.js"></script>
		<script src="/view/js/hori.js?tag=201211136"></script>
		
	</head>
	<body style="margin:0px;padding:0px;">
		<div data-role="page" style="margin:0px;padding:0px;">
			<div data-role="content" style="margin:0px;padding:0px;">
				<%
				Query q = Query.getInstance(request);
				String path = q.getContent();
				path = path.replace("\\", "/");
				String type = q.getContentType();
				boolean ispage = false;
				if(type.indexOf("image")!=-1){
					path="/view"+path;
					%>
					<div align="center" style="margin:0;padding:0;">
						<img id="imgcontent"/>
					</div>
					<%
				}else if(type.indexOf(".png")!=-1 || type.indexOf(".jpg")!=-1){
					path="/view"+path;
					%>
					<div align="center" style="margin:0;padding:0;">
						<img id="imgcontent"/>
					</div>
					<%
				}else if(type.indexOf("text/")!=-1){
					
					%>
					<div align="left" style="margin:0;padding:0;">
						<pre><%
						if(path.indexOf("<data-params>")==-1){
							out.println(path);
						}else{
							out.println(path.substring(0, path.indexOf("<data-params>")));
						}
						%></pre>
					</div>
					<%
				}else if(type.indexOf("application/vnd")!=-1 || type.indexOf("application/pdf")!=-1 || type.indexOf("application/msword")!=-1 || type.indexOf("application/octet-stream")!=-1 || type.indexOf("application/vnd.ms-powerpoint")!=-1){
					ispage = true;
					path = q.getRequest().getRequestURI() + "?data-page=1";
					%>
					<div align="center">
						<div id="imgtitle" align="center" style="background-color:#FFFFFF;display:none;"></div>
						<img id="imgcontent" />
					</div>
					<%
				}
				%>
				<script>
					try{

						var initwidth = document.body.clientWidth;
						var loaded = true;
							var isshowed = true;
							var currentPage = 1;
							var total = <%=q.getPageSize() %>;
							var path = "<%=q.getRequest().getRequestURI() %>";
						$(document).ready(function(){
							var hori=$.hori;
							
							cherry.bridge.registerEvent("previousButton", "touchUp", function(oper) {
								prewpage();
							});
							
							cherry.bridge.registerEvent("nextButton", "touchUp", function(oper) {
								nextpage();
							});
							
							
							hori.setHeaderTitle("第"+currentPage+"页/共" + total + "页");
							$("#imgtitle").html("第"+currentPage+"页/共" + total + "页");
								
							
								var path = "<%=path %>";
								if(path.indexOf("?")!=-1){
									path = path + "&data-random=" + Math.random();
								}else{
									path = path + "?data-random=" + Math.random();
								}
								if($("#imgcontent")){
									$("#imgcontent").attr("src", path);
									$("#imgcontent").attr("width", initwidth);
								}
								showHideButtons();
							});
					}catch(e){
						alert(e.message);
					}
					

					

					function showHideButtons() {
						// alert("showHideButtons run ")
						if (currentPage > 1) {
							showButton("previousButton");
						} else {
							hideButton("previousButton");
						}
						if (currentPage < total) {
							

							showButton("nextButton");
						} else {
							hideButton("nextButton");
						}
					}
					
					
					function changeimg(){
						try{

							$("#imgcontent").attr("width", initwidth);
							$.hori.showLoading();
							loaded = false;
							
							$.hori.setHeaderTitle("第"+currentPage+"页/共" + total + "页");

							
							showHideButtons();
							var random = parseInt(Math.random()*1000+1)
							if(path.indexOf('?')==-1){
								$("#imgcontent").attr("src", path + "?data-page=" + currentPage+"&data-cache=false&data-random=" + random).one('load',function(){
								$.hori.hideLoading();loaded=true;});
							}else{
								$("#imgcontent").attr("src", path + "&data-page=" + currentPage+"&data-cache=false&data-random=" + random).one('load',function(){$.hori.hideLoading();loaded=true;});
							}
						}catch(e){
							alert(e.message);
						}
					}
					function prewpage(){
						if(currentPage > 1 && loaded==true){
							currentPage = currentPage - 1;
							changeimg();
						}
					}
					function nextpage(){
						if(currentPage < total && loaded==true){
							currentPage = currentPage + 1;
							changeimg();
						}
					}
					function hideButton(xmlButtonName){
						// alert("hide --"+xmlButtonName);
						new cherry.NativeOperation(xmlButtonName,"setProperty",["hidden","1"]).dispatch();
						cherry.flushOperations();
					}
					function showButton(xmlButtonName){
						new cherry.bridge.NativeOperation(xmlButtonName,"setProperty",["hidden","0"]).dispatch();
						cherry.bridge.flushOperations();
					}
				</script>
			</div><!-- /content -->
		</div>
	</body>
</html>