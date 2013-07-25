<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
				<script>
					<![CDATA[
											
					function viewfile(url){
						$.hori.loadPage(url, "/view/Resources/AttachView.xml");
					}
					new cherry.bridge.NativeOperation("case","setProperty",["title","公文管理"]).dispatch();
					cherry.bridge.flushOperations();
					]]>
				</script>
			</head>
			<body>
				<div id="notice" data-role="page">
					<div data-role="content" align="center">
		
						<strong><xsl:value-of select="//title/text()"/></strong>
						<ul data-role="listview" data-inset="true" data-theme="d">
							<li data-role="list-divider">基本信息</li>
							<li>
									<xsl:if test="//textarea[@name='RtfFieldConfig']/mobilefieldconfig//fieldentry">
										<xsl:apply-templates select="//textarea[@name='RtfFieldConfig']/mobilefieldconfig/fieldentries/fieldentry"/>
									</xsl:if>
									<xsl:if test="not(//textarea[@name='RtfFieldConfig']/mobilefieldconfig//fieldentry)">
										<font color="red">应用单据被删除，请联系管理员。</font>
									</xsl:if>									
							</li>
							<li data-role="list-divider">附件信息</li>
							<li>
								<xsl:if test="//input[@name='AttachInfo']/@value =''">
									无附件
								</xsl:if>
								<xsl:if test="//input[@name='AttachInfo']/@value !=''">

									<xsl:call-template name="files">
										<xsl:with-param name="names" select="//input[@name='AttachInfo']/@value"/>
									</xsl:call-template>
								</xsl:if>
							</li>				
							
							<li data-role="list-divider">流转意见</li>
							<li>
								<xsl:if test="//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo/mindinfo">
									<xsl:apply-templates select="//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo/mindinfo" />
								</xsl:if>
								<xsl:if test="not(//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo/mindinfo)">
									暂无审批意见
								</xsl:if>
							</li>
							
						</ul>
						<xsl:apply-templates select="//input[@type='hidden']" mode="hidden"/>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	     
	<!-- 处理 基本信息 -->
	<xsl:template match="fieldentry">	
	
		<xsl:if test="not(@id='MTTABLE')">
							
					<xsl:value-of select="@title" />
					<b>：</b>												
					<xsl:value-of select="value/."/>
					<xsl:if test="contains(text/., '|')">
						<xsl:value-of select="substring-before(text/., '|')"/>
					</xsl:if>
					<xsl:if test="not(contains(text/., '|'))">
						<xsl:value-of select="text/."/>
					</xsl:if>								
			
			<br/><hr/>
			</xsl:if>
			<xsl:if test="@id='MTTABLE'">
				<li data-role="list-divider"><xsl:value-of select="@title" /></li>
				
				<li><xsl:apply-templates select="//div[@name='Fck_HTML']//table[@id='tblListC']" mode="t1"/></li>
			</xsl:if>		
	</xsl:template>



	<!-- 处理 附件 -->	
	<xsl:template name="files">
		<xsl:param name="names"/>

		<xsl:if test="contains($names,';')">	
			<li><a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{substring-before($names, ';')}');" data-role="button"><xsl:value-of select="substring-before($names, ';')"/></a></li>
			<xsl:call-template name="files">
				<xsl:with-param name="names" select="translate(substring-after($names, ';'), ' ', '')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(contains($names, ';'))">
			<li><a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{$names}');" data-role="button"><xsl:value-of select="$names"/></a></li>
		</xsl:if>		
	</xsl:template>

     <!-- 处理 流转意见 -->
	<xsl:template match="mindinfo">
		

					处理人<b>:</b><xsl:value-of select="@approver"/>
					<br/>
					审批时间<b>:</b><xsl:value-of select="@approvetime"/>
					<br/>

					审批环节<b>:</b>
					<xsl:value-of select="@flownodename"/>
					<xsl:if test="@optnameinfo !=''">
						<xsl:if test="contains(@optnameinfo, 'flownodename=')">
							(<xsl:value-of select="substring-after(@optnameinfo, 'flownodename=')"/>)
						</xsl:if>
						<xsl:if test="not(contains(@optnameinfo, 'flownodename='))">
							(<xsl:value-of select="@optnameinfo"/>)
						</xsl:if>
					</xsl:if>
					
					<br/>
					审批意见<b>:</b><xsl:value-of select="text()"/>
					<br/>

		<hr/>
		
		
	</xsl:template>

	 
	 

</xsl:stylesheet>
