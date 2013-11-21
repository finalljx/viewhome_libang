<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="contains(//input[@name='StMsgDB']/@value, 'DigiFlowMeetingRoomMng.nsf')">
				<xsl:text>/view/digi/meettingroom/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgDB"]/@value, "\", "/")' />
				<xsl:text>/0/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgParentId"]/@value,"\","/")' />
				<xsl:text>?opendocument&amp;login</xsl:text>
			</xsl:when>
			<xsl:when test="contains(//input[@name='StMsgDB']/@value, 'DigiFlowCarMng.nsf')">
				<xsl:text>/view/digi/carmanager/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgDB"]/@value, "\", "/")' />
				<xsl:text>/0/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgParentId"]/@value,"\","/")' />
				<xsl:text>?opendocument&amp;login</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>/view/digi/messagecontent/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgDB"]/@value, "\", "/")' />
				<xsl:text>/0/</xsl:text>
				<xsl:value-of select='translate(//input[@name="StMsgParentId"]/@value,"\","/")' />
				<xsl:text>?opendocument&amp;login</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
