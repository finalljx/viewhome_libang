<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="/">
		<html>
			<head>
											
				<link rel="stylesheet"  href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />
				
				<script src="/view/jqueryMobile/jquery.js"></script>
				<script src="/view/jqueryMobile/jquery.cookie.js"></script>
				
				<script src="/view/mobileBridge.js"></script>
				<script src="/view/jqueryMobile/jquery.mobile-1.2.0.js"></script><script src="/view/js/cherry.js"></script>
				<style>
					a:link{text-decoration:none}
					a:hover{text-decoration:none}
					a:visited{text-decoration:none}
				</style>
				<script>
					var setNavigationTitle=new cherry.bridge.NativeOperation("case","setProperty",["title","人员基本信息"]);
					setNavigationTitle.dispatch();
					cherry.bridge.flushOperations();
				</script>
			</head>
			<body>
				<div id="list" data-role="page" class="type-home">
					<div data-role="content" align="center">
						<script>
							function changepage(url){
								//$.mobile.changePage(url, {changeHash:true, type: "post"});
								$.hori.loadPage(url);
							}
						</script>
						<ul data-role="listview" data-inset="true">
						    <li data-role="list-divider">人员基本信息</li>
							<li>
								<font><xsl:text>IT Code：</xsl:text> <xsl:value-of select="//table[@id='tbl2']/tbody/tr[1]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>用户名：</xsl:text>  <xsl:value-of select="//table[@id='tbl2']/tbody/tr[2]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>部门名称：</xsl:text> <xsl:value-of select="//table[@id='tbl2']/tbody/tr[4]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>用户简称：</xsl:text>  <xsl:value-of select="//table[@id='tbl2']/tbody/tr[6]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>生 日：</xsl:text>  <xsl:value-of select="//table[@id='tbl2']/tbody/tr[7]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>性 别： </xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[8]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>办公电话：</xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[9]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>传真：</xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[10]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>移动电话：</xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[11]/td[2]/."/></font>
							</li>
							<li>
								<a href="mailto:{//table[@id='tbl2']/tbody/tr[12]/td[2]/.}" target="_blank" data-role="none">
								<font><xsl:text>邮 箱：</xsl:text></font><xsl:value-of select="//table[@id='tbl2']/tbody/tr[12]/td[2]/."/>
								</a>
							</li>
							<li>
								<font><xsl:text>MSN：</xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[13]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>QQ： </xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[14]/td[2]/."/></font>
							</li>
							<li>
								<font><xsl:text>微博：</xsl:text><xsl:value-of select="//table[@id='tbl2']/tbody/tr[15]/td[2]/."/></font>
							</li>
						</ul>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
