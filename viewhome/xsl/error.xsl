<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
			</head>
			<body>
				<div id="notice" data-role="page">
					<div data-role="content" align="center">
						灰常遗憾，模板出错了，烦请您老查看日志
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
