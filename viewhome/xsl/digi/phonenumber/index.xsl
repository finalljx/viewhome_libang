<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
				<script src="/view/jqueryMobile/jquery.cookie.js"></script>	
				<script>
					<![CDATA[
					
					
					function submit(){
						var username = $("#phonenumber").val();
						if($.trim(username)==""){
							alert('请输入关键字 ');
							return ;
						}
						var oaServerName=$.cookie("oaServerName");
						
						username = encodeURI(escape(username));
						//$.mobile.showPageLoadingMsg();
						$.hori.showLoading();
						var url = "/view/oa/phonenumberrequest/Produce/WeboaConfig.nsf/telSearchForm?openform&svrName="+oaServerName+"&queryStr="+username+"&dbFile=Produce/DigiFlowOrgPsnMng.nsf&showField=UserDeptPhone";
						
						$.ajax({
							type: "post", url: url,
							success: function(response){
								//$.mobile.hidePageLoadingMsg();
								$.hori.hideLoading();
								$("#viewValue").html(response);
								$("#viewValue ul").listview();
								$("#viewValue ul").listview();    
							},
							error:function(response){
								//$.mobile.hidePageLoadingMsg();
								$.hori.hideLoading();
								alert("错误:"+response.responseText);
							}
						});
					}
					]]>
				</script>
				

				<script>
					<![CDATA[

					cherry.bridge.registerEvent("case", "navButtonTouchUp", function(oper) {
						submit();
					});
					]]>
				</script>
			</head>
			<body>
				<div id="list" data-role="page" class="type-home">
					<div data-role="content" align="center">
						<button name="aa" onclick="submit()">aa</button>
						<div align="center" >
							<input type="text" id="phonenumber" name="phonenumber" value="" />
						</div>
						<div id="viewValue" >
							<ul data-role="listview" data-inset="true" >
								<li data-role="list-divider" data-theme="f"></li>
								<li>无数据</li>
							</ul>
						</div>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="tr">
		<li href="">
			<a href="/bridge/oa/noticecontent{td[4]/a/@href}" data-icon="arrow-r" data-iconpos="right">
				<h3><xsl:value-of select="td[4]/."/></h3>
				<p>时间:<xsl:value-of select="td[3]/."/></p>
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
