<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:output method="html" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<!-- <xsl:value-of select="//viewentries/@toplevelentries"/>  -->
		 <xsl:value-of select="//msg/@num1"/> 
	</xsl:template>
	
</xsl:stylesheet>
