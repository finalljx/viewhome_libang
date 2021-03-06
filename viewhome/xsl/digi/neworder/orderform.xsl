<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="/xsl/pub/scriptCss.xsl" />	
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
		<html lang="zh_cn">
			<head>							
				<xsl:apply-imports/>
				<link href="/view/css/mobiscroll-2.1.full.min.css" rel="stylesheet" type="text/css" />
				 <script src="/view/js/mobiscroll-2.1.full.min.js" type="text/javascript"></script>
				<script src="/view/js/i18n/mobiscroll.core-zh.js" type="text/javascript"></script>   
			    <script src="/view/js/i18n/mobiscroll.datetime-zh.js" type="text/javascript"></script>
    
				<script>
					$(document).ready(function(){
						var hori=$.hori;
						/*设置标题*/
						hori.setHeaderTitle("发货申请");
						$('#StOrderDate').val('').scroller('destroy').scroller($.extend({ 
							preset: 'date', dateOrder: 'yymmdd' }, {
                    		theme: "Default",
                    		mode: "scroller",
                    		lang: "zh",
                    		display: "modal",
                    		animate: "pop"

                		}));
						$("#StOrderNumSaved").bind("change",function(e){
							var s=$("#orderJsonInfo").val();
							var jobj=$.parseJSON(s);
							var num=$(this).val();
							if($.trim(num)!=""){
								num=num.toUpperCase();
								$("#popupCloseLeft p").text(jobj[num]);
								$("#popupCloseLeft").popup("open",{positionTo:"origin"});
							}
						
						});
					});
					
				</script>
				
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				
				<script>
					<![CDATA[
					function submit(value){
						//alert($('#mobileNewForm').serialize())
						if(!validateForm()){
							return 
						}
						var jsonData = $("#mobileNewForm").form2json();
						//alert(jsonData);
						
						var question = window.confirm("确定提交吗?"); 
						if(question){
							$.mobile.showPageLoadingMsg();
							
							var url = "/view/oa/request_orderdelivery/Application/OrderDelivery.nsf/m_mobileNewSaveAgent?openagent&login";
							var data = "data-xml="+encodeURI(jsonData);
							
							$.ajax({
								type: "post", url: url, data:data,
								success: function(response){
									
									var result = $.parseJSON(response);	
									alert(result.info);	
									$.mobile.hidePageLoadingMsg();
									if(result.isok){									
										$.hori.backPage(1);
									}	
								},
								error:function(response){									
									var rtext="";
									if(response.statusText=="timeout"){
										rtext=$.hori.timeOutAlertStr;
									}else{
										rtext="错误:"+response.responseText
									}									
									$.mobile.hidePageLoadingMsg();							
							        alert(rtext);	
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
					function validateForm(){
						var validateFlag=true;
						var vobj=[{"selector":"#StMoneyBack","alertInfo":"请填写汇款情况"},{"selector":"#StOrderDate","alertInfo":"请选择发货日期"},{"selector":"#StOrderNumSaved","alertInfo":"请选择订单编号"}];
						//var vobj=$.parseJSON(validateField);
						for(var i=0;i<vobj.length;i++){
							if($(vobj[i].selector) && $.trim($(vobj[i].selector).val())==""){
								$("#popupCloseLeft p").text(vobj[i].alertInfo);
								$("#popupCloseLeft").popup("open",{positionTo:"origin"});
								validateFlag=false;
								break;
							}
						}
						return validateFlag;
					}
					]]>
				</script>
						
			</head>
			<body>
				<div data-role="page" class="type-interior">
					<div data-role="content" align="center">
						
						<xsl:if test="count(//form/items/item)&lt;=0">
							<div data-role="content">
								<ul data-role="listview" data-inset="true" data-theme="d">
									<li data-role="list-divider">订单发货申请</li>							
									<li>
										<font color="red" size="4">系统没有找到符合发货条件的销售订单。</font>														
									</li>
								</ul>
							</div>
						</xsl:if>
						
						<xsl:if test="count(//form/items/item)&gt;0">
							
							
							<div class="ui-grid-b" style="margin-bottom:-1.5em;">
								<div class="ui-block-a">
								</div>
								<div class="ui-block-b">
									
								</div>
								<div class="ui-block-c">
									<button type="button" data-theme="f" onclick="submit(this.value);" value="submit" data-rel="dialog">提交</button>
								</div>
							</div>
							<div data-role="content">
								<div class="content-primary">
									<form action="#" method="get" id="mobileNewForm">
									<ul data-role="listview" data-inset="true" data-theme="d" class="ui-listview ui-listview-inset ui-corner-all ui-shadow">
											
										<li data-role="list-divider" style="text-align:center"><font color="white">订单发货申请</font></li>
									
										<xsl:for-each select="//form/items">
											<xsl:for-each select="./item[hidden!='true']">
											<li>
												<div class="ui-grid-a">
													<xsl:if test="not(itemtitle='')">
														<div class="ui-block-a" style="width:40%;text-align:right"><label style="line-height:2em"><xsl:value-of select="itemtitle"/></label></div>
													</xsl:if>
													
													<xsl:if test="type='text'">
														<div class="ui-block-b" style="width:60%;text-align:left;font-weight:normal"><label style="line-height:2em"><xsl:value-of select="value"/></label></div>
													</xsl:if>
													
													<xsl:if test="type='input'">
														<div class="ui-block-b" style="width:60%;text-align:left;font-weight:normal"><input type="text" name="{id}" id="{id}" value="{value}" ></input></div>
													</xsl:if>
													
													<xsl:if test="type='select'">	
													<div class="ui-block-b"  style="width:60%;text-align:left;font-weight:normal">												
														<select name="{id}" id="{id}" data-theme="f" data-inline="true" data-native-menu="true">													
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
										<xsl:for-each select="//item[hidden='true']">
											<input type="text" name="{id}" id="{id}" value="{value}" ></input>
										</xsl:for-each>
									</div>											
									</form>
									<div data-role="popup" id="popupCloseLeft" class="ui-content" style="max-width:280px" data-position-to="origin">
										<a href="#" data-rel="back" data-role="button" data-theme="a" data-icon="delete" data-iconpos="notext" class="ui-btn-left">Close</a>
										<p></p>
									</div>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
