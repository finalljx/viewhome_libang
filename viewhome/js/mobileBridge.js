/*
  页面 跳转 依赖 cherry.js
  para:targetUrl 目标url
  componetXmlUrl:可选 默认组件为  web 容器 路径：view/resources/Resources/PureWeb.scene.xml
 
*/

//调用native的 loading页面

var isdebug = true;

function showLoading(){
	if(isdebug){
		return;
	}
	var loading=new cherry.bridge.NativeOperation("application","showLoadingSheet",[]);
	loading.dispatch();
	cherry.bridge.flushOperations();
}

//隐藏native的 loading页面

function hiddenLoading(){
	if(isdebug){
		return;
	}
	var hiddenLoading=new cherry.bridge.NativeOperation("application","hideLoadingSheet",[]);
	hiddenLoading.dispatch();
	cherry.bridge.flushOperations();
}

function $.hori.loadPage(targetUrl,componetXmlUrl){
	if(isdebug){
		window.location.href = targetUrl;
		return;
	}
	var serverUrl=document.location.protocol+"//"+document.location.host;
	
	if(typeof(componetXmlUrl)=="undefined"){
			componetXmlUrl=serverUrl+"/view/Resources/PureWeb.scene.xml";
			
	}else{
		componetXmlUrl=serverUrl+componetXmlUrl
	}
	if(targetUrl==""){
		alert("targetUrl参数不能为空");
	}
	targetUrl=serverUrl+targetUrl
	//alert("targetUrl="+targetUrl);
	//alert("componetXmlUrl="+componetXmlUrl);
	
	var pushScene = new cherry.bridge.NativeOperation("application", "pushScene", [componetXmlUrl,targetUrl]);
	pushScene.dispatch();
	cherry.bridge.flushOperations();
	return pushScene;
		
}
/*
 页面 跳转  多用于返回上一页
 依赖 cherry.js
  para:targetUrl 目标url
  componetXmlUrl:可选 默认组件为  web 容器 路径：view/resources/Resources/PureWeb.scene.xml
*/
function changePageBackWithBridge(forceRefresh){

	//window.go(-1);
	//return;

	if(typeof(forceRefresh)=="undefined" || parseInt(forceRefresh,10)==0){

		var refreshFlag="0";
	} else{
		var refreshFlag="1";
	}
	var popScene = new cherry.bridge.NativeOperation("application", "popScene", [refreshFlag]);

	popScene.dispatch();

	cherry.bridge.flushOperations();

	return popScene;
}

/*
	get page url parameter example:http://www.aa.com&name=xx

	getRequestParameter("name")
*/
 function getRequestParameter(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)","i"),
	r = window.location.search.substr(1).match(reg);
	return (r!=null)?  unescape(r[2]) : null;
}
/*
new cherry.bridge.NativeOperation("case","setProperty",["title","内容"]).dispatch();
cherry.bridge.flushOperations();
*/