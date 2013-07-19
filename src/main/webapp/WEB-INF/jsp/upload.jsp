<%@ include file="/WEB-INF/jsp/init.jsp"%>



<div id="containerDirac">
	<div id="presentationDirac">Upload Proxy</div>
	<div id="contentDirac">
	
		<liferay-ui:error key="error-dowloading-proxy"
			message="error-dowloading-proxy" />
		<liferay-ui:error key="upload-error"
			message="upload-error" />
			
		<portlet:actionURL var="uploadCertUrl">
			<portlet:param name="myaction" value="uploadCert" />
		</portlet:actionURL>
		
		<aui:form name="newCert" action="${uploadCertUrl }" commandName="uploadCert" enctype="multipart/form-data">
			<aui:input name="certificate" type="file" label="Import Certificate (.p12 or pfx format)"/>
			<aui:input name="password" type="password" label="Import certificate password"/>
			<aui:button-row>
				<aui:button type="submit" value="Upload"/>
			</aui:button-row>
		</aui:form>
		
	</div>
</div>