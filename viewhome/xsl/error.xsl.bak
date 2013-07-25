<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head></head>
			<body>
				<div data-role="page" class="type-home">
					<div data-role="header">
						<a data-icon="home" data-role="button" href="/bridge/home.html">返回</a>
						<h1>系统错误</h1>
					</div><!-- /header -->
				
					<div data-role="content" align="center">
						<ul data-role="listview" data-inset="true">
							<li data-role="list-divider"></li>
							<li href="">
								错误原因：<xsl:value-of select="//body/text()"/>

							</li>
							<li data-role="list-divider"></li>
						</ul>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
