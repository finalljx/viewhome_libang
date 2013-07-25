/*
							 * 该方法走WebService版流程后台驱动
							 * author：YiYing
							 */
							function FlowBackTraceForWS(optType){
								
								var serverName	= document.all("appserver").value;							//应用所在服务器
								
								var dbPath		= document.all("appdbpath").value;							//应用数据库路径	
								var docUNID		= document.all("appdocunid").value;							//应用文档UNID
								var updFields	= document.all("stupdfields").value;						//需要更新的域字符串
								var optPsnID	= document.all("CurUserITCode").value;						//当前处理人ITCode
								//var optPsnName	= document.all("CurUserNameCN").value;					//当前处理人中文名
								var tempAuthors = document.all("TFTempAuthors").value;						//高级操作时选择的环节处理人
								var toNodeId	= document.all("FlowGotoNodeID").value;						//指定流程流转到某个环节的环节ID
								var psnMind		= document.getElementsByName("FlowMindInfo")[0].value;		//审批意见
								var msgTitle	= document.all("msgtitle").value;							//消息标题
								var selectPsn 	= document.all("SelectPsnEN").value;						//指定的下一环节处理人
								var sTitle 		= document.all("applyname").value;							//应用名称
								//var otherInfo	= document.all("otherInfo").value;							//其它扩展信息
								
								psnMind		= psnMind.replace(/&/gi,"&amp;");
								psnMind		= psnMind.replace(/</gi,"&lt;");
								psnMind		= psnMind.replace(/>/gi,"&gt;");
								updFields	= updFields.replace(/&/gi,"&amp;");
								updFields	= updFields.replace(/</gi,"&lt;");
								updFields	= updFields.replace(/>/gi,"&gt;");
								
								var dataArr = [];
								dataArr.push("<db_ServerName>"+serverName+"</db_ServerName>");
								dataArr.push("<db_DbPath>"+dbPath+"</db_DbPath>");
								dataArr.push("<db_DocUID>"+docUNID+"</db_DocUID>");
								dataArr.push("<db_UpdInfo><![CDATA["+updFields+"]]></db_UpdInfo>");
								dataArr.push("<db_OptPsnID>"+optPsnID+"</db_OptPsnID>");
								dataArr.push("<db_TempAuthors>"+tempAuthors+"</db_TempAuthors>");
								dataArr.push("<db_ToNodeId>"+toNodeId+"</db_ToNodeId>");
								dataArr.push("<db_Mind><![CDATA["+psnMind+"]]></db_Mind>");
								dataArr.push("<db_MsgTitle>"+msgTitle+"</db_MsgTitle>");
								dataArr.push("<db_SelectPsn>"+selectPsn+"</db_SelectPsn>");
								dataArr.push("<db_OptType>"+optType+"</db_OptType>");
								var dataXML	= "<allData>"+dataArr.join("")+"</allData>";
								
								/*
								var soap = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><SOAP-ENV:Body><m:bb_dd_GetDataByView xmlns:m='http://sxg.bbdd.org' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><db_ServerName xsi:type='xsd:string'>"+serverName+"</db_ServerName><db_DbPath xsi:type='xsd:string'>"+dbPath+"</db_DbPath><db_DocUID xsi:type='xsd:string'>"+docUNID+"</db_DocUID><db_UpdInfo xsi:type='xsd:string'></db_UpdInfo><db_OptPsnID xsi:type='xsd:string'>"+optPsnID+"</db_OptPsnID><db_TempAuthors xsi:type='xsd:string'></db_TempAuthors><db_MsgTitle xsi:type='xsd:string'></db_MsgTitle><db_ToNodeId xsi:type='xsd:string'>"+toNodeId+"</db_ToNodeId><db_Mind xsi:type='xsd:string'>"+psnMind+"</db_Mind><db_OptType xsi:type='xsd:string'>"+optType+"</db_OptType></m:bb_dd_GetDataByView></SOAP-ENV:Body></SOAP-ENV:Envelope>";
								var dataXML = "data-xml="+soap;*/
								
								//弹出窗口的背景层，控制显示透明度
								try{
									$.alerts.overlayOpacity=0.4;
									$.alerts._overlay('show');
								}catch(e){}
								if(document.getElementById("UseFlowWSName").value==""){
									alert("ws代理名为空不可调用流程后台驱动");
								}
								
								$.ajax({
							
									type:"POST",
								//流程后台驱动代理定位到手机审批首页库中		
								url:"/view/oamobile/request/Produce/DigiFlowMobileHome.nsf/"+document.getElementById("UseFlowWSName").value+"?openagent&login&data-result=text&data-encoding=utf-8",
									data:encodeURI(dataXML),
									async:true,
									success:function(responseTxt){ 
												
												var Obj = JSON.parse(responseTxt);
												
												//移除遮罩
												try{
													$("#popup_overlay").remove();
												}catch(e){}
												var sInfo = Obj.textinfo;
												
												//提交/退回成功
												if(Obj.flag=="1"){
													
													if (sInfo.indexOf("提交成功")!=-1){
														if(Obj.newnodename!=""){
															sInfo = "流程流向"+Obj.newnodename+"环节!";
														}
														if(Obj.newauthors!=""){
															sInfo += "\n接下来由"+Obj.newauthors+"处理！";
														}
													}
													//根据操作栏显示的内容进行提示
													if (sInfo.indexOf("退回成功")!=-1){
														
														sInfo = document.getElementById("fontReturn").innerText+"成功！"
													}

												}
												//如果下一环节无环节处理人则提醒选择环节处理人，并打开选人接口
												var noNodeAuthors = "";
												if(Obj.flag=="noNodeAuthors"){
													sInfo = Obj.newnodename+"环节处理人为空，请选择环节处理人！";
													$("#tabSelectPsnID").show();
													$("#SelectPsnCN").css("background","yellow");
													noNodeAuthors = "yes";
												}
												
												//flag为0时为异常错误
												if(Obj.flag=="0"){
													sInfo = Obj.textinfo
												}
												
												$.mobile.hidePageLoadingMsg();
												alert(sInfo);
												setTimeout("$.hori.backPage(1)",2000);
												
										   },
									error:function(e){
											   $.mobile.hidePageLoadingMsg();
											   jAlert("后台审批操作失败！", sTitle);
										   }
								});
							}