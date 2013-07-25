<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="/">
		<html>
			<head>							
				<link rel="stylesheet"  href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />
				
				<script src="/view/jqueryMobile/jquery.js"></script>
				<script src="/view/jqueryMobile/jquery.mobile-1.2.0.js"></script>
				<script src="/view/js/hori.js"></script>
				<script>
				
					var npage = 1;
					var ncount = 20;
					function fetch(){
						$.hori.showLoading();
						
						npage = npage+1;
						var url = "/view/oa/imageNewsSubList/Produce/DigiFlowMobile.nsf/agGetViewData?openagent&amp;login&amp;0.7714136636026634&amp;server=OA/LOVOL&amp;dbpath=Application/DigiFlowInfoPublish.nsf&amp;view=vwInfoByDateForMobile_new&amp;thclass=&amp;page="+npage+"&amp;count="+ncount;
						$.ajax({
							type: "get", url: url,
							success: function(response){
								//$.mobile.hidePageLoadingMsg();
								$("#more").remove();
								$("ul").append(response);
								$("ul").listview('refresh');
								$.hori.hideLoading();
							},
							error:function(response){
								//$.mobile.hidePageLoadingMsg();
								$.hori.hideLoading();
								alert("错误:"+response.responseText);
							}
						});
					}

					function goin(user,unid){
					
						var url = "/view/oa/imageNewsContent/Produce/DigiFlowMobile.nsf/showform?openform&amp;login&amp;apptype=news&amp;appserver=OA/LOVOL&amp;appdbpath=Application/DigiFlowInfoPublish.nsf&amp;appdocunid="+unid;																	
						$.hori.loadPage(url);
					}
					new cherry.bridge.NativeOperation("case","setProperty",["title","新闻列表"]).dispatch();
					cherry.bridge.flushOperations();
				</script>
			</head>
			<body>
				<div id="list" data-role="page" class="type-home">
					<div data-role="content" align="center">

						<ul data-role="listview" data-inset="true">
							<xsl:apply-templates select="//viewentry" />
							<xsl:if test="count(//viewentry)=0">
								<li><a>无内容</a></li>
							</xsl:if>
							<xsl:if test="count(//viewentry)!=0">
								<li id="more">
									<a href="javascript:void(0);" onclick="fetch();" data-icon="none" data-iconpos="none">
										<div style="width:100%;" align="center"><h3>载入更多</h3></div>
									</a>
								</li>
							</xsl:if>
			
						</ul>
						<br/>
						<br/>
						<br/>
					</div><!-- /content -->
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="viewentry">
		<li>
			<a href="javascript:void(0);" onclick="goin('{//userid/text()}','{@unid}');" data-icon="arrow-r" data-iconpos="right">
				<xsl:if test="contains(entrydata[2]/.,'CDATA[')">
					<h3><xsl:value-of select="substring-before(substring-after(entrydata[2]/.,'CDATA['), ']]')"/></h3>
					<p>
						时间:<font color="#0080FF"><xsl:value-of select="substring-before(substring-after(entrydata[1]/.,'CDATA['), ']')"/></font>
					</p>
				</xsl:if>
				<xsl:if test="not(contains(entrydata[2]/.,'CDATA['))">
					<h3><xsl:value-of select="entrydata[2]/."/></h3>
					<p>
						时间:<font color="#0080FF"><xsl:value-of select="entrydata[1]/."/></font>
					</p>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
