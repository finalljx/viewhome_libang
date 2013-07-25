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
				</script>
	
				
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
			</head>
			<body>
				<div id="notice" data-role="page">
					
					<div data-role="content" align="center">
						<script>
							<![CDATA[
												
							function viewfile(url){
								$.hori.loadPage(url, "/view/Resources/AttachView.xml");
							}							
							
							//特价订单审批提交
							function submit_price(value){
								
								var question = window.confirm("确定提交吗?"); 
								if(question){
									var appserver = $("#appserver").val();
									var appdbpath = $("#appdbpath").val();
									var appdocunid = $("#appdocunid").val();
									var CurUserITCode = $("#CurUserITCode").val();
									
									//CurUserITCode = CurUserITCode);
									
									var FlowMindInfo = $("#FlowMindInfo").val();
									if(FlowMindInfo=="" || FlowMindInfo==null || FlowMindInfo==" "){
										if(value=='submit'){
											FlowMindInfo = "同意！";
										}else{
											FlowMindInfo = "不同意！";
										}
									}
									//FlowMindInfo = encodeURI(FlowMindInfo);
									
									$.mobile.showPageLoadingMsg();
									var url = "/view/oa/request_price/ANCSOA/oajf.nsf/FlowBackTraceAgent?openagent&login";
									var data = {"unid":appdocunid,"mindInfo":FlowMindInfo,"result":value,"itcode":CurUserITCode};
									$.ajax({
										type: "post", url: url, data:data,
										success: function(response){
											
											var result = $.parseJSON(response);									
											$.mobile.hidePageLoadingMsg();
											alert(result.info);
											if(result.isok){									
												setTimeout("$.hori.backPage(1)",1000);
											}												
										},
										error:function(response){
											var rtext="";
											if(response.statusText=="timeout"){
												rtext=$.hori.timeOutAlertStr;
											}else{
												rtext="错误" +response.responseText
											}
											
												$.mobile.hidePageLoadingMsg();
												alert(rtext);
											}
									});
								}
							}
						]]>
						</script>
						
						
				
						<xsl:if test="(//div[@name='Fck_HTML']//fieldentry)">
						
							<div class="ui-grid-b" style="margin-bottom:-4.0em;">
								<div class="ui-block-a">
								</div>
								<div class="ui-block-b"><xsl:if test="//a[contains(@href, 'submit')]">
									<button type="button" data-theme="f" onclick="submit_price(this.value);" value="submit" data-rel="dialog">提交</button>
								</xsl:if></div>
								<div class="ui-block-c"><xsl:if test="//a[contains(@href, 'reject')]">
									<button type="button" data-theme="f" onclick="submit_price(this.value);" value="reject" data-rel="dialog">驳回</button>
								</xsl:if></div>
							</div>
						</xsl:if>
						
						<div data-role="content">
							<xsl:if test="not(//div[@name='Fck_HTML']//fieldentry)">
								<ul data-role="listview" data-inset="true" data-theme="d">
									<li data-role="list-divider"><xsl:value-of select="//title/text()" /></li>							
									<li>
										<font color="red" size="4">应用单据被删除或未进行移动审批配置，请联系管理员。</font>														
									</li>
								</ul>
							</xsl:if>
							
							<xsl:if test="(//div[@name='Fck_HTML']//fieldentry)">								
								<ul data-role="listview" data-inset="true" data-theme="d" class="ui-listview ui-listview-inset ui-corner-all ui-shadow" style="margin-top:70px">
									<li data-role="list-divider"><xsl:value-of select="//title/text()" /></li>
								
									<xsl:apply-templates select="//div[@name='Fck_HTML']//fieldentry"/>	
								</ul>
								
								<ul data-role="listview" data-inset="true" data-theme="d">
									<li data-role="list-divider">审批意见</li>
									<li>
										<xsl:if test="//textarea[@name='FlowMindInfo']">
											<table style="border:0;padding:0;margin:0;" width="100%" border="0">
												<tr style="width:100%">
													<td style="width:50%" align="left">
														<span><strong>您的意见:</strong></span>
													</td>
													<td style="width:50%" align="left">
														<select onChange='$("#FlowMindInfo").val($("#FlowMindInfo").val()+this.value);' data-theme="a" data-icon="gear" data-native-menu="true">
															<option selected="selected">常用语</option>
															<option value="同意！">同意！</option>
															<option value="不同意！">不同意！</option>
														</select>
													</td>
												</tr>
												<tr style="width:100%">
													<td colspan="2" style="width:100%" align="center">
														<textarea id="FlowMindInfo" name="FlowMindInfo"></textarea>
													</td>
												</tr>
											</table>
										</xsl:if>
									</li>
								</ul>

							</xsl:if>						
						</div>
						<xsl:apply-templates select="//input[@type='hidden']" mode="hidden"/>
					</div><!-- /content -->
				</div>			
			</body>
		</html>
	</xsl:template>


	

	
	
	<!-- 处理 基本信息 -->
	<xsl:template match="fieldentry">
		<xsl:if test="not(@id='MTTABLE')">
			<xsl:if test="contains(@type, 'checkbox')">
				<xsl:if test="not(value/.='')">
					<li>
					<xsl:value-of select="@title" />
					<b>：</b>												
					<xsl:value-of select="value/."/>
					</li>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(contains(@type, 'checkbox'))">						
				<xsl:if test="not(contains(@id, 'DynTbl_'))">
					<li>
					<xsl:value-of select="@title" />
					<b>：</b>												
					<xsl:value-of select="value/."/>
					</li>
				</xsl:if>	
			</xsl:if>
		</xsl:if>		
					
	
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
	
	<xsl:template match="input" mode="hidden">
		<input type="hidden" id="{@name}" name="{@name}" value="{@value}" />
	</xsl:template>
	
	<xsl:template match="tr" mode="option">
		<div style="width;100%" align="left"><xsl:value-of select="td[4]/."/></div>
		<div style="width;100%" align="right">
			<xsl:value-of select="td[1]/."/><br/>
			<xsl:value-of select="td[2]/."/><br/>
			<xsl:value-of select="td[3]/."/><br/>
		</div>
		<hr/>
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
		<div style="width:100%" align="left">
			<xsl:attribute name="align">
				<xsl:if test="not(position()=1 or position()=3)">left</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates mode="c3"/>
		</div>
		<hr color="gray"/>
	</xsl:template>

	<xsl:template match="td" mode="c3">
		<xsl:if test=".!=''">
			<xsl:if test="not(@style) or not(contains(@style, 'display:none'))">
				<!-- 发文红色字体特殊处理 -->
				<xsl:choose>
					<xsl:when test="position()=1">
						<span style="width:38%;display:inline-block;text-align:right"><font color="red"><xsl:value-of select="."/>
							<xsl:if test="not(contains(., ':'))">:</xsl:if>
						</font></span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="c4"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="position()=2">
					<br/>
				</xsl:if>
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
