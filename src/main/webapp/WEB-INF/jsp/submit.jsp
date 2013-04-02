<%@ include file="/WEB-INF/jsp/init.jsp"%>
<script language="JavaScript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript">
	var count = 0;
	function deleteFile(divName){
		$("#"+divName).remove();
	}
	function addFile(element){
		element.attr('onclick','').unbind('click');
		$("#addFile").append("<div id=\"addFile_"+count+"\"><input id=\"uploadFile_"+count+"\" class=\"multi\" type=\"file\" onclick=\"addFile($(this));\" name=\"uploadFile_"+count+"\"><a href=\"#addFile\" onclick=\"deleteFile('addFile_"+count+"');\">Delete</a></div>");
		count = count + 1;
	}
</script>

<style type="text/css">
	#containerDirac {
		box-shadow: 10px 10px 5px #888;
		background-color: #e4e4e4;
		border: 1px;
		border-style: solid;
		border-color: #c1c1c1;
		border-radius: 5px;
		padding: 5px;
		margin-right: 9px;
	}
	
	#presentationDirac  {
		color: black;
		font-size: 120%;
		font-weight: bold;
		border-bottom: 1px solid #CCCCCC;
		width: 90%;
		margin-bottom: 15px;
		padding: 10px 0 0 10px;
	}
	
	#contentDirac  {
		margin-top: 15px;
	}
</style>

<div id="containerDirac">
	<div id="presentationDirac">My Jobs</div>
	<div id="contentDirac">
		<portlet:actionURL var="submitUrl">
			<portlet:param name="myaction" value="submitJob" />
		</portlet:actionURL>
		
		<aui:form name="newJdl" action="${submitUrl }" commandName="jdl" enctype="multipart/form-data">
		
			<aui:input type="text" label="Job Name" name="jobName" value="${jdl.jobName }"/>
			<aui:input type="text" label="Executable" name="executable" value="${jdl.executable }"/>
			<aui:input type="text" label="Arguments" name="arguments" value="${jdl.arguments }"/>
			<aui:input type="text" label="Standard Output" name="stdOutput" value="${jdl.stdOutput }"/>
			<aui:input type="text" label="Standard Error" name="stdError" value="${jdl.stdError }"/>
			<aui:input type="text" label="Output Sandbox" name="outputSandboxRequest" value="${jdl.outputSandboxRequest }"/>
			
			<aui:input type="file" label="Input Sandbox" id="uploadFile" name="uploadFile"  onclick="addFile($(this));"/>
			<a href="#addFile" onclick="addFile($('#uploadFile'));">Add file</a>
			
			<div id="addFile">
				
			</div>
			
			
		
			<aui:button type="submit" value="Submit"/>
		</aui:form>
	</div>
</div>