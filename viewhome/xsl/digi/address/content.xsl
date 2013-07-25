<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	<xsl:variable name="start"><xsl:value-of select="//input[@name='start']/@value"/></xsl:variable>
	<xsl:variable name="count"><xsl:value-of select="//input[@name='count']/@value"/></xsl:variable>
	<xsl:variable name="total"><xsl:value-of select="//input[@name='total']/@value"/></xsl:variable>
	<xsl:variable name="currentPage"><xsl:value-of select="floor($start div $count)+1"/></xsl:variable>
	<xsl:variable name="totalPage"><xsl:value-of select="floor(($total - 1) div $count)+1"/></xsl:variable>
	<xsl:variable name="nextStart"><xsl:value-of select="($currentPage * $count) + 1"/></xsl:variable>
	<xsl:variable name="preStart"><xsl:value-of select="$nextStart - $count - $count"/></xsl:variable>

	<xsl:template match="/">
		<html>
			<head>
				<xsl:apply-imports/>					
				
				
				
				<style>
					a:link{text-decoration:none}
					a:hover{text-decoration:none}
					a:visited{text-decoration:none}
				</style>
				<script>					
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("讯录");

					});
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
						    <li data-role="list-divider">通讯录</li>
							<xsl:apply-templates select="//div[@name='person']" />
							<xsl:if test="count(//div[@name='person'])=1">
								<li><a>无内容</a></li>
							</xsl:if>
						</ul>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="div">
	
		<xsl:variable name="name" select="substring-before(text(), '^')"/>
		<xsl:if test="position()!=1">
			<li>
				<a href="javascript:void(0)" onclick="changepage('/view/digi/addressdetail/Produce/DigiFlowOrgSysMng.nsf/SearUserInfoForm?openform&amp;ITCode={$name}')"><xsl:value-of select="substring-before(substring-after(text(), '^'), '^')"/></a>
			</li>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>



