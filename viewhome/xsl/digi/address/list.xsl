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
					*{font-size:18px}
					a:link{text-decoration:none;color:black;}
					a:hover{text-decoration:none;color:black;}
					a:visited{text-decoration:none;color:black;}
				</style>
				<script>					
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("通讯录");

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
							function getOrg(value){
								if($("#"+value+"C").html().indexOf("-")!=-1){
									$("#"+value).html("");
									$("#"+value+"C").html("+");
									return;
								}
								var url = "/view/oa/addresssuborg/Produce/DigiFlowOrgSysMng.nsf/OrgTreeForAddressAgent?openagent";
								var data = "data-xml="+value+";;;<xsl:value-of select='//userid/text()'/>";
								$.mobile.showPageLoadingMsg();
								$.ajax({
									type: "post", url: url, data:data,
									success: function(response){
										$.mobile.hidePageLoadingMsg();
										$("#"+value).html(response);
										$("#"+value+"C").html("-");
									},
									error:function(response){
										$.mobile.hidePageLoadingMsg();
										alert("错误:"+response.responseText);
									}
								});
							}
							function viewPerson(value){
								var url = "/view/digi/addressperson/Produce/DigiFlowContactsLovol.nsf/GetDeptPsnForAddressAgent?openagent";
								var data = "&amp;data-method=post&amp;data-xml=deptid~1~"+value+"~22~ComOrg~";
								$.hori.loadPage(url+data);
							}
						</script>
						<ul data-role="listview" data-inset="true">
						    <li data-role="list-divider">通讯录</li> 
							<li>
								<div style="width:100%;height:5"></div>
								<span><a href="javascript:void(0)" onclick="getOrg('D00011')">  <strong><span id="D00011C">+</span></strong>&#160;&#160;  福田雷沃重工</a></span>
								<hr/>
								<div id='D00011' style="padding-left:15px;"></div>
								<span><a href="javascript:void(0)" onclick="getOrg('D00012')">  <strong><span id="D00012C">+</span></strong>&#160;&#160;  福田汽车</a></span>
								<hr/>
								<div id='D00012' style="padding-left:15px;"></div>
								<span><a href="javascript:void(0)" onclick="viewPerson('D00013')">  <strong><span id="D00013C">-</span></strong>&#160;&#160;  欧洲农业装备技术中心</a></span>
								<div id='D00013' style="padding-left:15px;"></div>
								<div style="width:100%;height:5"></div>
							</li>
						</ul>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
