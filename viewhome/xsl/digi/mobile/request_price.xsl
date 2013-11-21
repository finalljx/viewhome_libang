<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<xsl:if test="contains(translate(//result,'TRUE','true'),'true')">
			 {"isok":"true","info":"<xsl:value-of select="//info/."></xsl:value-of>"}
		</xsl:if>
		<xsl:if  test="contains(translate(//result,'FASLE','false'),'false')">
			 {"isok":false,"info":"<xsl:value-of select="//info/."></xsl:value-of>"}
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
