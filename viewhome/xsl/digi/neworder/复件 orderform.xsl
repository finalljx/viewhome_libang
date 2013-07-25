<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>

				<script>
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("发货申请");
					});
				</script>
				
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				
				<script>
					<![CDATA[
					function submit(value){
						//alert($('#mobileNewForm').serialize())
						var jsonData = $("#mobileNewForm").form2json();
						//alert(jsonData);
						
						var question = window.confirm("确定提交吗?"); 
						if(question){
							$.mobile.showPageLoadingMsg();
							
							var url = "/view/oa/request/Application/OrderDelivery.nsf/m_mobileNewSaveAgent?openagent&login";
							var data = "data-xml="+encodeURI(jsonData);
							//alert(data)
							$.ajax({
								type: "post", url: url, data:data,
								success: function(response){
								
									var result = response;
									//alert(result);
									$.mobile.hidePageLoadingMsg();
									alert(result);									
									$.hori.backPage(1);
								},
								error:function(response){
									$.mobile.hidePageLoadingMsg();
									alert("错误:"+response.responseText);
								}
							});
						}
					}
					
					function paramString2obj (serializedParams) {     
				    	var obj={};

    					function evalThem (str) {
							var attributeName = str.split("=")[0];
							var attributeValue = str.split("=")[1];
							if(!attributeValue){
								return ;
							}
							 
							var array = attributeName.split(".");
							for (var i = 1; i < array.length; i++) {
								var tmpArray = Array();
								tmpArray.push("obj");
								for (var j = 0; j < i; j++) {
									tmpArray.push(array[j]);
								};
								var evalString = tmpArray.join(".");
								// alert(evalString);
								if(!eval(evalString)){
									eval(evalString+"={};");               
								}
							};
						 
							eval("obj."+attributeName+"='"+attributeValue+"';");
							 
						};
					 
						var properties = serializedParams.split("&");
						for (var i = 0; i < properties.length; i++) {
							evalThem(properties[i]);
						};
					 
						return obj;
					}
					function reserialize(objs) 
					{ 
						var parmString = $(objs).serialize(); 
						var parmArray = parmString.split("&"); 
						var parmStringNew=""; 
						$.each(parmArray,function(index,data){ 
							var li_pos = data.indexOf("=");  
							if(li_pos >0){ 
								var name = data.substring(0,li_pos); 
								var value = escape(decodeURIComponent(data.substr(li_pos+1))); 
								//alert(value)
								var parm = name+"="+value; 
								parmStringNew = parmStringNew=="" ? parm : parmStringNew + '&' + parm; 
							} 
						}); 
						return parmStringNew; 
					} 				 

					$.fn.form2json = function(){
						//var serializedParams = this.serialize();
						var serializedParams = reserialize(this);
						var obj = paramString2obj(serializedParams);
						return JSON.stringify(obj);
					}	
					]]>
				</script>
						
			</head>
			<body>
				<div data-role="page" class="type-interior">
					<div data-role="content" align="center">
						
						<ul data-role="listview">
							<li data-role="list-divider">
								<div data-role="controlgroup" data-type="horizontal" align="right">
									<button type="button" style="padding:0 30 0 30;" onclick="submit(this.value);" value="submit" data-rel="dialog">提交</button>
								</div>
							</li>
						</ul>
						
						<div data-role="content">
							<div class="content-primary">
								<form action="#" method="get" id="mobileNewForm">
								<ul data-role="listview" data-inset="true" data-theme="d" class="ui-listview ui-listview-inset ui-corner-all ui-shadow">
										
									
										<li data-role="list-divider" style="text-align:center">订单发货申请</li>
									
									<xsl:for-each select="//form/items">
										
											<xsl:for-each select="./item[hidden!='true']">
											<li>
											
												<div class="ui-grid-a">
												<xsl:if test="not(itemtitle='')">
													<div class="ui-block-a" style="width:30%;text-align:right"><label><xsl:value-of select="itemtitle"/></label></div>
												</xsl:if>
												
												<xsl:if test="type='text'">
													<div class="ui-block-b" style="width:70%;text-align:left"><label><xsl:value-of select="value"/></label></div>
												</xsl:if>
												
												<xsl:if test="type='input'">
													<div class="ui-block-b" style="width:70%;text-align:left"><input type="text" name="{id}" id="{id}" value="{value}" ></input></div>
												</xsl:if>
												
												<xsl:if test="type='select'">	
												<div class="ui-block-b" style="width:70%;text-align:left">												
													<select name="{id}" id="{id}" data-theme="a" data-icon="gear" data-native-menu="true">													
														<option value=""></option>
														<xsl:for-each select="./options/selectoption">
															<option value="{value}"><xsl:value-of select="text"/></option>									
														</xsl:for-each>
													</select>
												</div>
												</xsl:if>
												</div>
												</li>
											</xsl:for-each>
										
									</xsl:for-each>
</ul>
									
									<div data-role="fieldcontain" style="display:none">
										<xsl:for-each select="./item[hidden='true']">
											<input type="text" name="{id}" id="{id}" value="{value}" ></input>
										</xsl:for-each>
									</div>											
								</form>
							</div>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
