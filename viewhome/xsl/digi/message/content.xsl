<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	
	<xsl:variable name="appdbpath"><xsl:value-of select="//input[@name='appdbpath']/@value"/></xsl:variable>
	<xsl:variable name="appformname"><xsl:value-of select="//input[@name='appformname']/@value"/></xsl:variable>
	
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
				
				<script src="/view/js/template.js"></script>

				<script>
					
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("单据");

					});		
					function viewfile(url){
						$.hori.loadPage(url, "/view/Resources/AttachView.xml");
					}
				</script>
				
				
			</head>
			<body>
				<div id="notice" data-role="page">
					<div data-role="content" align="center">
		
						<strong><xsl:value-of select="//title/text()"/></strong>
						<ul data-role="listview" data-inset="true" data-theme="d">
							<li data-role="list-divider">基本信息</li>
							<li>
								<xsl:if test="//textarea[@name='Fck_HTML']/p">
									<div style="width:100%;word-break:break-all;text-align:center;" align="center">
									
										
									</div>
									<br/>
									<div style="width:100%;text-align:left" align="left">
										
										<xsl:apply-templates select="//textarea[@name='Fck_HTML']/p[1]"/>
										
									</div>

								</xsl:if>
								<xsl:if test="//textarea[@name='RtfFieldConfig']/mobilefieldconfig//fieldentry">
										
									<xsl:apply-templates select="//textarea[@name='RtfFieldConfig']/mobilefieldconfig/fieldentries/fieldentry"/>
								</xsl:if>
								<xsl:if test="contains(//title/.,'手机办公平台')">										
									<font color="red">应用单据被删除或未进行移动审批配置，请联系管理员。</font>
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
							<li data-role="list-divider">当前环节信息</li>
							<li>
								环节名称：<xsl:value-of select="//input[@name='TFCurNodeName']/@value" />
								<hr/>
								环节处理人：<xsl:value-of select="//input[@name='TFCurNodeAuthors']/@value" />
											<xsl:if test="//input[@name='TFCurNodeAuthors']/@value !=''">
												<xsl:value-of select="//input[@id='TFCurNodeOneDo']/@value" />
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
	<xsl:variable name="sub">rtfmobile<xsl:value-of select="@name"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="@type='table'">				
					<div style='text-align:center;'><xsl:value-of select="@title" /></div>
					<div style='padding-left:10px;'><xsl:apply-templates select="//textarea[@name=$sub]" mode="bx"/></div>
				</xsl:when>
				<xsl:when test="@id='MTTABLE'">
					<li data-role="list-divider"><xsl:value-of select="@title" /></li>
					<li><xsl:apply-templates select="//span/textarea//table[@id='tblListC']" mode="t1"/></li>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="contains(@type, 'checkbox')">
						<xsl:if test="not(value/.='')">			
							<xsl:value-of select="@title" />
							<b>：</b>												
							<xsl:value-of select="value/."/>												
							<br/><hr/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(contains(@type, 'checkbox'))">
								
							<xsl:value-of select="@title" />
							<b>：</b>												
							<xsl:value-of select="value/."/>												
							<br/><hr/>
						
					</xsl:if>
				</xsl:otherwise>

			</xsl:choose>	



	</xsl:template>




	<!-- 处理 附件 -->
	

	<xsl:template name="files">
		<xsl:param name="names"/>

		<xsl:if test="contains($names,';')">	
			<li><a href="javascript:void(0)" onclick="viewfile('/view/oamobile/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{substring-before($names, '(')}');" data-role="button"><xsl:value-of select="substring-before($names, '(')"/></a></li>
			<xsl:call-template name="files">
				<xsl:with-param name="names" select="translate(substring-after($names, '; '), ' ', ' ')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($names,'(')">	
			<li><a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{substring-before($names, '(')}');" data-role="button"><xsl:value-of select="substring-before($names, '(')"/></a></li>
			
		</xsl:if>
		<xsl:if test="not(contains($names, ';'))">
			<xsl:if test="not(contains($names,'('))">	
				<li><a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{$names}');" data-role="button"><xsl:value-of select="$names"/></a></li>
			</xsl:if>
		</xsl:if>		
	</xsl:template>

     <!-- 处理 流转意见 -->
	<xsl:template match="mindinfo">
		

					处理人<b>:</b><xsl:value-of select="@approver"/>
					<br/>
					审批时间<b>:</b><xsl:value-of select="@approvetime"/>
					
					<br/>
					审批意见<b>:</b><xsl:value-of select="text()"/>
					<br/>

		<hr/>
		
	</xsl:template>

	<xsl:template match="pre">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="br">
		<br/><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
	</xsl:template>

	<xsl:template match="p">
		<br/><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:apply-templates />
		<br/>
	</xsl:template>

	<!-- 处理 基本信息table -->
	<xsl:template match="table" mode="t1" >	
		<xsl:apply-templates  mode="t1"/>	
	</xsl:template>	
	
	<xsl:template match="tbody" mode="t1" >	
		<xsl:apply-templates  mode="t1"/>	
	</xsl:template>

	 <xsl:template match="tr" mode="t1" >
		<xsl:variable name="num" select="position()"/>

		  <xsl:if test="$num!=1">
			<li><xsl:apply-templates  mode="t1"/></li>
		 </xsl:if>
	</xsl:template>

	 <xsl:template match="td" mode="t1" >	
		<xsl:variable name="n" select="position()"/>
		<xsl:value-of select="../../tr[1]/td[$n]"/>:
		<xsl:value-of select="text()"/>
		<br/>
	</xsl:template>



	<!-- 差旅报销表格展示 -->
	<xsl:template match="textarea" mode="bx" >	
		<xsl:if test="position()=1">		
		<xsl:apply-templates  mode="bx"/>	
		</xsl:if>
	</xsl:template>	

	<xsl:template match="table" mode="bx" >	
		<xsl:apply-templates  mode="bx"/>	
	</xsl:template>	
	
	<xsl:template match="tbody" mode="bx" >	
		<xsl:apply-templates  mode="bx"/>	
	</xsl:template>

	 <xsl:template match="tr" mode="bx" >
		<xsl:variable name="num" select="position()"/>

		  <xsl:if test="$num!=1">
			<xsl:apply-templates  mode="bx"/><hr/>
		 </xsl:if>
	</xsl:template>

	 <xsl:template match="td" mode="bx" >
		<xsl:variable name="n" select="position()"/>
		<xsl:value-of select="translate(../../tr[1]/td[$n],'*','')"/>:
		<xsl:apply-templates  mode="bx"/>
		<br/>
	</xsl:template>
	
	<xsl:template match="input" mode="bx">
		<xsl:value-of select="translate(@value,'?readOnly','')"/>
	</xsl:template>



	 <xsl:template match="textarea" mode="c1" >	
		<xsl:apply-templates mode="c1"/>
	</xsl:template>
	 <xsl:template match="p" mode="c1" >	
		<xsl:apply-templates mode="c1"/>
	</xsl:template>
	 <xsl:template match="span" mode="c1" >	
		<xsl:apply-templates mode="c1"/>
	</xsl:template>
	<xsl:template match="br" mode="c1" >	
		<br/>
	</xsl:template>
	<xsl:template match="text()" mode="c1">
		<xsl:value-of select="."/>
	</xsl:template>
</xsl:stylesheet>