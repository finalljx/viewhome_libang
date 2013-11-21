<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html" encoding="GBK" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//a"/>
	</xsl:template>

	<xsl:template match="a">
		<li>
			<xsl:if test="contains(@href, 'changeChild')">
				<div style="width:100%;height:5"></div>
				<a href="javascript:void(0)">  <strong><span id="{substring-before(@id, ';')}C">-</span></strong>&#160;&#160;  </a>
				<a href="javascript:void(0)" onclick="viewPerson('{substring-before(@id, ';')}')">
					<xsl:value-of select="text()"/> 
				</a>
				<hr/>
				<div style="width:100%;height:5"></div>
				<div id="{substring-before(@id, ';')}" style="padding-left:15px;"></div>
			</xsl:if>
			<xsl:if test="not(contains(@href, 'changeChild'))">
				<div style="width:100%;height:5"></div>
				<a href="javascript:void(0)" onclick="getOrg('{substring-before(@id, ';')}')"> <strong><span id="{substring-before(@id, ';')}C">+</span></strong>&#160;&#160;  </a>
				<a href="javascript:void(0)" onclick="viewPerson('{substring-before(@id, ';')}')">
					<xsl:value-of select="text()"/> 
				</a>
				<hr/>
				<div style="width:100%;height:5"></div>
				<div id="{substring-before(@id, ';')}" style="padding-left:15px;"></div>
			</xsl:if>
		</li>
	</xsl:template>
</xsl:stylesheet>
