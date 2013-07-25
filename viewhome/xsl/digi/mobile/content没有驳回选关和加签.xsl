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
	
				<!-- 在ready时将动态表格HTML写入指定区域 -->
				<script>
					var dxTblhtml = "";
					$(document).bind("pageinit", function(){
						//alert($("#DhtmlxJsonData").val());
						//alert(dxTblhtml)
						if(dxTblhtml){
							$("#div_DTblHtml").html( dxTblhtml ).trigger('create');
						}
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
							
							function submit(value){
								var appdbpath = $("#appdbpath").val();
								
								var question = window.confirm("确定提交吗?"); 
								if(question){
									var appserver = $("#appserver").val();
									
									var appdocunid = $("#appdocunid").val();
									var CurUserITCode = $("#CurUserITCode").val();
									CurUserITCode = encodeURI(escape(CurUserITCode));
									var FlowMindInfo = $("#FlowMindInfo").val();
									if(FlowMindInfo=="" || FlowMindInfo==null || FlowMindInfo==" "){
										if(value=='submit'){
											FlowMindInfo = "同意！";
										}else{
											FlowMindInfo = "不同意！";
										}
									}
									FlowMindInfo = encodeURI(escape(FlowMindInfo));
									
									var soap = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><SOAP-ENV:Body><m:bb_dd_GetDataByView xmlns:m='http://sxg.bbdd.org' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><db_ServerName xsi:type='xsd:string'>"+appserver+"</db_ServerName><db_DbPath xsi:type='xsd:string'>"+appdbpath+"</db_DbPath><db_DocUID xsi:type='xsd:string'>"+appdocunid+"</db_DocUID><db_UpdInfo xsi:type='xsd:string'></db_UpdInfo><db_OptPsnID xsi:type='xsd:string'>"+CurUserITCode+"</db_OptPsnID><db_TempAuthors xsi:type='xsd:string'></db_TempAuthors><db_MsgTitle xsi:type='xsd:string'></db_MsgTitle><db_ToNodeId xsi:type='xsd:string'></db_ToNodeId><db_Mind xsi:type='xsd:string'>"+FlowMindInfo+"</db_Mind><db_OptType xsi:type='xsd:string'>"+value+"</db_OptType></m:bb_dd_GetDataByView></SOAP-ENV:Body></SOAP-ENV:Envelope>";
									
									$.mobile.showPageLoadingMsg();
									var url = "/view/oa/request/Produce/ProInd.nsf/THFlowBackTraceAgent?openagent&login";
									var data = "data-xml="+soap;
									$.ajax({
										type: "post", url: url, data:data,
										success: function(response){
											var result = response;
											var soap = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:DefaultNamespace"><soapenv:Header/><soapenv:Body><urn:GETUSERSTR soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SERNAME xsi:type="xsd:string">oa.lovol.com.cn</SERNAME><DBPATH xsi:type="xsd:string">'+appdbpath+'</DBPATH><UNID xsi:type="xsd:string">'+appdocunid+'</UNID></urn:GETUSERSTR></soapenv:Body></soapenv:Envelope>';
											var url = "/view/oa/wb/Produce/DigiFlowMobileJCHome.nsf/WebMsg?wsdl";
											var data = "data-xml="+soap;
											$.ajax({
												type: "post", url: url, data:data,
												success: function(res){
													$.mobile.hidePageLoadingMsg();
													alert(result);
													setTimeout("$.hori.backPage(1)",2000);
													
												},
												error:function(response){
													$.mobile.hidePageLoadingMsg();
													alert(result);
													setTimeout("$.hori.backPage(1)",1000);
													
												}
											});
											
										},
										error:function(response){
											$.mobile.hidePageLoadingMsg();
											alert("错误:"+response.responseText);
										}
									});
								}
							}
							
						]]>
						</script>
						
						<!-- 支持的JSON格式如下，分head和data两部分，data中要对应head中的dataid -->
						<!-- {head: [{'title':'部门','dataid':'deptName'},{'title':'费用','dataid':'bmoney'},{'title':'申请人','dataid':'deptLeader'}],data: [{'id':1,'deptName':'公安业务部','deptCode':'BM_ZFSYB_GAYWB','bmoney':'444','deptLeader':'田龙岗(田龙岗)'}]} -->
						<script id="_dxTbl" type="text/html">
						<![CDATA[
							<% for (var i = 0; i < data.length; i ++) { %>
								<div data-role="collapsible" data-theme="a" data-content-theme="d">
									<h3>第<%= i+1 %>行</h3>
									<ul data-role="listview" data-inset="true" data-theme="d">
										<% for (var j = 0; j < head.length; j ++) { %>
											<li ><%= head[j].title %> ：<%= data[i][head[j].dataid] %></li>
										<% } %>
									</ul>
								</div>
							<% } %>
						]]>
						</script>
				
						<xsl:if test="(//div[@name='Fck_HTML']//fieldentry)">
							<div class="ui-grid-b" style="margin-bottom:-1.5em;">
								<div class="ui-block-a">
								</div>
								<div class="ui-block-b"><xsl:if test="//a[contains(@href, 'submit')]">
									<button type="button" data-theme="f" onclick="submit(this.value);" value="submit" data-rel="dialog">提交</button>
								</xsl:if></div>
								<div class="ui-block-c"><xsl:if test="//a[contains(@href, 'reject')]">
									<button type="button" data-theme="f" onclick="submit(this.value);" value="reject" data-rel="dialog">驳回</button>
								</xsl:if></div>
							</div>
						</xsl:if>
						
						<div data-role="content">
							<xsl:if test="not(//div[@name='Fck_HTML']//fieldentry)">
								<ul data-role="listview" data-inset="true" data-theme="f">
									<li data-role="list-divider"><xsl:value-of select="//title/text()" /></li>							
									<li>
										<font color="red" size="4">应用单据被删除或未进行移动审批配置，请联系管理员。</font>														
									</li>
								</ul>
							</xsl:if>
							
							<xsl:if test="(//div[@name='Fck_HTML']//fieldentry)">								
								<ul data-role="listview" data-inset="true" data-theme="d" class="ui-listview ui-listview-inset ui-corner-all ui-shadow" style="word-wrap:break-word">
									<li data-role="list-divider"><xsl:value-of select="//title/text()" /></li>
								
									<xsl:apply-templates select="//div[@name='Fck_HTML']//fieldentry"/>	
								</ul>
								
								<ul data-role="listview" data-inset="true" data-theme="f">
									<li data-role="list-divider" >审批意见</li>
									<li data-theme="d">
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
					<!--			
								<xsl:if test="normalize-space(//*[@name='Fck_HTML']/.)!='' and normalize-space(//*[@name='Fck_HTML']/.)!='临时作者字段：'">
									<li data-role="list-divider">正文内容</li>
									<li>
										<xsl:value-of select="//*[@name='Fck_HTML']/."/>
									</li>
								</xsl:if>
					-->				
					
								<ul data-role="listview" data-inset="true" data-theme="d">
									<li data-role="list-divider">附件信息</li>
									<xsl:if test="//input[@name='AttachInfo']/@value =''">
									<li>
										无附件
									</li>	
									</xsl:if>
									<xsl:if test="//input[@name='AttachInfo']/@value !=''">
										<xsl:call-template name="file">
											<xsl:with-param name="info" select="translate(//input[@name='AttachInfo']/@value, ' ', '')"/>
										</xsl:call-template>
									</xsl:if>
								</ul>

								<ul data-role="listview" data-inset="true" data-theme="d">								
									<li data-role="list-divider">当前环节信息</li>
									<li>
										环节名称：<xsl:value-of select="//input[@name='TFCurNodeName']/@value" />
										<hr/>
										环节处理人：<xsl:value-of select="//input[@name='TFCurNodeAuthors']/@value" />
													 <xsl:value-of select="//input[@id='TFCurNodeOneDo']/@value" />
									</li>
									<li data-role="list-divider">流转意见</li>
									<li>
										<pre style="word-wrap:break-word">
											<xsl:if test="//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo">
												<xsl:apply-templates select="//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo/mindinfo" />
											</xsl:if>
											<xsl:if test="not(//textarea[@name='ThisFlowMindInfoLog']/flowmindinfo)">
												
											</xsl:if>
											
											<xsl:apply-templates select="//fieldentry[@id='ThisFlowMindInfoLog']" mode="mind"/>
										</pre>
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


	<!-- 处理 流转意见 -->
	<xsl:template match="mindinfo">
	
		处理人<b>:</b><xsl:value-of select="translate(@approver, '&quot;', '')"/>
		<br/>
		审批时间<b>:</b><xsl:value-of select="@approvetime"/>
		<br/>

		审批环节<b>:</b>
		<xsl:value-of select="@flownodename"/>
			<xsl:if test="@optnameinfo !=''">
				(<xsl:value-of select="@optnameinfo"/>)
			</xsl:if>
		
		<br/>
		审批意见<b>:</b><xsl:value-of select="text()"/>
		<br/>

		<hr/>		
	</xsl:template>

	<!-- 处理 附件（目前前仅支持单个附件） -->	
	<xsl:template name="file">
		<xsl:param name="info" />
		<li>
			<xsl:choose>
			<xsl:when test="contains($info, ';')">
				<a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{substring-before($info, ';')}');"  data-role="button"><xsl:value-of select="substring-before($info, ';')"/></a>
				<xsl:call-template name="file">
					<xsl:with-param name="info" select="substring-after($info, ';')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<a href="javascript:void(0)" onclick="viewfile('/view/oa/file/Produce/DigiFlowMobile.nsf/0/{//input[@name='AttachDocUnid']/@value}/$file/{$info}');"  data-role="button"><xsl:value-of select="$info"/></a>
			</xsl:otherwise>
		</xsl:choose>
		</li>
	</xsl:template>
	
	<!-- 处理 基本信息 -->
	<xsl:template match="fieldentry">
		<xsl:if test="not(@id='MTTABLE') and not(@id='ThisFlowMindInfoLog')">
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
		
		<xsl:if test="@id='MTTABLE'">
			<ul data-role="listview" data-inset="true" data-theme="d">
				<li data-role="list-divider"><xsl:value-of select="@title" /></li>			
				<li><xsl:apply-templates select="//div[@name='Fck_HTML']//table[@id='tblListC']" mode="t1"/></li>
			</ul>
		</xsl:if>
					
		<!-- 此处动态生成表格，ID为"DynTbl_XXX"，OA会自动获取XXX的值写到下面的input中 -->					
		<xsl:if test="contains(@id, 'DynTbl_')">
			<input type="hidden" id="{@id}" name="{@id}" value="{value/.}" />			
			
			<xsl:if test="($appdbpath='Application/cachetApp.nsf') and ($appformname='NewappFrom') ">			
				<li data-role="list-divider">文件明细</li>
				<li id="div_DTblHtml">无数据</li>
				
				<script>
					<![CDATA[
						var innerData = $("#DynTbl_RtfTableData_json").val();						
						if($.trim(innerData)==""){
							innerData=[{}];
						}
						
						var jsondata = '{"head": [{"title":"文件名称","dataid":"column1"},{"title":"公章类型","dataid":"column2"},{"title":"公章所在地","dataid":"column3"},{"title":"公章管理员","dataid":"column4"},{"title":"份数","dataid":"column5"},{"title":"邮寄地址","dataid":"column6"},{"title":"备注","dataid":"column7"}],"data": ';
						jsondata = jsondata + innerData +'}';
						
						var jsonObj = $.parseJSON(jsondata);
						
						dxTblhtml = template.render("_dxTbl", jsonObj);
						
						
						//$("#div_DTblHtml").html( dxTblhtml ).trigger('create');
						
					]]>
				</script>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>

	<xsl:template match="fieldentry" mode="mind">
		<xsl:apply-templates  mode="mind"/>
	</xsl:template>
	
	<xsl:template match="value" mode="mind" >
		<xsl:copy-of select="." />
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
