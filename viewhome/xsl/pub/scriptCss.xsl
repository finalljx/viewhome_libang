<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="/">
		<html>
			<head>
				<link rel="stylesheet" href="/view/jqueryMobile/jquery.mobile-1.2.0.css" />
				<link rel="stylesheet" href="/view/jqueryMobile/jquery.mobile-1.2.0-sugon.css" /> 
				<script src="/view/jqueryMobile/jquery.js"></script>				
				<script src="/view/jqueryMobile/jquery.mobile-1.2.0.min.js"></script>
				<script src="/view/js/hori.js"></script>
				<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=1"/>
				<xsl:if test="//form[@action='/names.nsf?Login'] or //statuscode/.='401'">
					<script type="text/javascript">
						$(document).ready(function(){
							alert("会话过期，请重新登录");
							var serverUrl = "";
							var componentURL = serverUrl+"/view/Resources/Login.scene.xml";
							$.hori.loadPage(serverUrl+"/view/Resources/login.html",componentURL);
							return;

						});
					</script>
				</xsl:if>
				
			</head>
		</html>
	</xsl:template>
</xsl:stylesheet>