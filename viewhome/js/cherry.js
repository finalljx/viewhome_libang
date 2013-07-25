var scriptUrl=""
if (window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i) || window.navigator.userAgent.match(/iPod/i)) {
	scriptUrl="http://10.0.100.105/view/js/cherry_ios.js";
} else if (window.navigator.userAgent.match(/android/i)) {
	scriptUrl="http://10.0.100.105/view/js/cherry_android.js";
} else{
scriptUrl="http://10.0.100.105/view/js/cherry_ios.js";
}


$.ajax({
		type: "get", 
		url: scriptUrl, 
		dataType: "script", 
		cache:false,
		async:false
})			