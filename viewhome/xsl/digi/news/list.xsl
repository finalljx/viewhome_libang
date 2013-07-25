<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
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
				<link rel="stylesheet"  href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />
				
				<script src="/view/jqueryMobile/jquery.js"></script>
				<script src="/view/jqueryMobile/jquery.mobile-1.2.0.js"></script>
				<script src="/view/js/hori.js"></script>

				<script>
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("新闻列表");

					});
				</script>
			</head>
			<body>
				<div id="list" data-role="page" class="type-home">
					<div data-role="content" align="center">
						<script>
							function changepage(url){
								$.hori.loadPage(url);
							}
						</script>
						<ul data-role="listview" data-inset="true">
							<xsl:apply-templates select="//viewentry" />
							<xsl:if test="count(//viewentry)=0">
								<li><a>无内容</a></li>
							</xsl:if>
						</ul>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="viewentry">
		<li>
			<a href="javascript:void(0)" onclick="changepage('/view/oa/newscontent/Application/DigiFlowInfoPublish.nsf/InfoByDateView_2/{@unid}?OpenDocument&amp;login');" data-icon="arrow-r" data-iconpos="right">
				<xsl:if test="contains(entrydata[5]/.,'CDATA[')">
					<h3><xsl:value-of select="substring-before(substring-after(entrydata[5]/.,'CDATA['), ']]')"/></h3>
					<p>
						发布时间:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[2]/.,'CDATA['), ']')"/></font>
						重要程度	:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[4]/.,'CDATA['), ']')"/></font>
						所属栏目:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[6]/.,'CDATA['), ']')"/></font>
						起草人:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[7]/.,'CDATA['), ']')"/></font>
						起草部门:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[8]/.,'CDATA['), ']')"/></font>
					</p>
				</xsl:if>
				<xsl:if test="not(contains(entrydata[5]/.,'CDATA['))">
					<h3><xsl:value-of select="entrydata[5]/."/></h3>
					<p>
						发布时间:<font color="#0080FF"><xsl:value-of select="entrydata[2]/."/></font>
						重要程度	:<font color="#0080FF"><xsl:value-of select="entrydata[4]/."/></font>
						所属栏目:<font color="#0080FF"><xsl:value-of select="entrydata[6]/."/></font>
						起草人:<font color="#0080FF"><xsl:value-of select="entrydata[7]/."/></font>
						起草部门:<font color="#0080FF"><xsl:value-of select="entrydata[8]/."/></font>
					</p>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
