<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<link rel="stylesheet"  href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />
				
				<style>
					pre {
						white-space: pre-wrap;
						white-space: -moz-pre-wrap;
						white-space: -pre-wrap;
						white-space: -o-pre-wrap;
						word-wrap: break-word;
					}
					
					.ui-li-desc{
						white-space:normal;;
					}
				</style>
				<script src="/view/jqueryMobile/jquery.js"></script>
				<script src="/view/jqueryMobile/jquery.mobile-1.2.0.js"></script>

				<script src="/view/js/hori.js"></script>

				<script>
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("内容");

					});
				</script>
			</head>
			<body>
				<div id="notice" data-role="page">
					<div data-role="content" align="center">
						<script type="text/javascript">
							function viewfile(url){
								//alert(url);
								$.hori.loadPage(url, "/view/Resources/AttachView.xml");
							}
						</script>
						<div align="center" style="width:100%"><strong><xsl:value-of select="//title/text()"/></strong></div>
						<div data-role="collapsible-set" data-theme="c" data-content-theme="d">
							<ul data-role="listview" data-inset="true">
								<li>
									<div style="width:100%;word-wrap:word;text-align:left;" align="left">
										<pre>
											<xsl:copy-of select="//textarea[@id='FCK_EditorValue']//p" />
											
											
											<xsl:if test="//textarea[@id='FCK_EditorValue']/p[1]/@style">
												<xsl:copy-of select="//textarea[@id='FCK_EditorValue']//p" />
											</xsl:if>
											
											<xsl:if test="not(//textarea[@id='FCK_EditorValue']/p[1]/@style)">
												<xsl:value-of select="//textarea[@id='FCK_EditorValue']//p" />
											</xsl:if>
											
										</pre>
									</div>
									
									<div>
										<xsl:apply-templates select="//img[@src='/icons/fileatt.gif']/.." mode="file"/>
									</div>
								</li>
							</ul>
						</div>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="a" mode="file">
		<xsl:if test="@href='#'">
			<a href="javascript:void(0)" onclick="viewfile('/view/oa/file/{substring(substring-before(substring-after(@onclick,'('),')'), 2)}');"  data-role="button"><xsl:value-of select="."/></a>
		</xsl:if>
	</xsl:template>

	
	
	<!-- 表单批量格式化模版 -->
	<!-- variable of $mini and $aliasname at mdp.xsl -->
	<xsl:template match="table" mode="c1">
		<xsl:apply-templates mode="c2"/>
	</xsl:template>

	<xsl:template match="tbody" mode="c2">
		<xsl:apply-templates mode="c2"/>
	</xsl:template>

	<xsl:template match="tr" mode="c2">
		<xsl:if test="position()=1 or position()=2">
			<!--<div style="width:100%" align="center">
				<xsl:value-of select=".//q/." />
			</div>-->
		</xsl:if>
		<xsl:if test="not(position()=1 or position()=2)">
			<div style="width:100%" align="left">
				<xsl:attribute name="align">
					<xsl:if test="not(position()=2 or position()=4)">left</xsl:if>
				</xsl:attribute>
				<xsl:apply-templates mode="c3"/>
			</div>
		</xsl:if>
		<hr/>
	</xsl:template>

	<xsl:template match="td" mode="c3">
		<xsl:if test="not(@style) or not(contains(@style, 'display:none'))">
			<!-- 发文红色字体特殊处理 -->
			<xsl:choose>
				<xsl:when test="@class='DF_GTable_LTD_Style'">
					<span style="width:38%;display:inline-block;text-align:right"><font color="red"><xsl:value-of select="."/></font></span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="c4"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@class='DF_GTable_RTD_Style'">
				<br/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()" mode="c4">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="q" mode="c4">
		<xsl:apply-templates mode="c4"/>
	</xsl:template>
	<xsl:template match="b" mode="c4">
		<xsl:if test="normalize-space(.)!=''">
			<strong><xsl:apply-templates mode="c4"/></strong>
		</xsl:if>
	</xsl:template>
	<xsl:template match="center" mode="c4">
		<span width="100%" align="center" mode="c4">
			<xsl:apply-templates mode="c4"/>
		</span>
	</xsl:template>
	<xsl:template match="font" mode="c4">
		<font>
			<xsl:apply-templates mode="c4"/>
		</font>
	</xsl:template>
	<xsl:template match="input" mode="c4">
		<xsl:value-of select="@value"/>
	</xsl:template>
	<xsl:template match="select" mode="c4">
		<xsl:if test="starts-with(@name, 'fld')">
			<xsl:value-of select="option[@selected='selected']/text()"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="textarea" mode="c4">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="hr" mode="c4">
		<hr size="{@size}">
			<xsl:attribute name="color">
				<xsl:call-template name="color">
					<xsl:with-param name="name"><xsl:value-of select="@color" /></xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</hr>
	</xsl:template>
	<xsl:template match="div" mode="c4">
		<xsl:apply-templates mode="c4" />
	</xsl:template>
	<xsl:template match="img" mode="c4">
	</xsl:template>
	<xsl:template name="color">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="@color='red'">
				<xsl:text>#FF0000</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#FF0000</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
