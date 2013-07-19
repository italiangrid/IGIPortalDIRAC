<%@ include file="/WEB-INF/jsp/init.jsp"%>
<script language="JavaScript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript">
	var count = 0;
	function deleteFile(divName){
		$("#"+divName).remove();
		count = count - 1;
		if(count == 0){
			$("#inputSanboxDiv").hide();
		}
	}
	function addFile(){
		$("#inputSanboxDiv").show();
		$("#inputSanboxDiv").append("<div id=\"addFile_"+count+"\"><input id=\"uploadFile_"+count+"\" class=\"multi\" type=\"file\" name=\"uploadFile_"+count+"\"> <a href=\"#addFile\" onclick=\"deleteFile('addFile_"+count+"');\"><img src=\"<%=request.getContextPath()%>/images/NewDelete.png\" width=\"14\" height=\"14\" /></a></div>");
		count = count + 1;
	}
	function deleteAll(){
		var i;
		for(i=0; i<=count; i++){
			$("#addFile_"+i).remove();
		}
	}
	function uploadExecutable(){
		$("#executableDiv .aui-field-element").html("<input type=\"file\" value=\"\" name=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executableFile\" id=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executableFile\" class=\"aui-field-input aui-field-input-text\">  or <a href=\"#executableDiv\" onClick=\"specifyExecutable();\">Specify your executable</a>");	
	}
	function specifyExecutable(){
		$("#executableDiv .aui-field-element").html("<input id=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executable\" class=\"aui-field-input aui-field-input-text\" type=\"text\" value=\"/bin/ls\" name=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executable\">  or <a href=\"#executableDiv\" onClick=\"uploadExecutable();\">Upload your executable</a>");
	}
	
	function appendExecutable(){
		$("#executableDiv .aui-field-element").append("  or <a href=\"#executableDiv\" onClick=\"uploadExecutable();\">Upload your executable</a>");
	}
	
	function appendInputSandbox(){
		$("#inputSanboxDiv .aui-field-element").append(" <a href=\"#inputSanboxDiv\" onClick=\"$('#inputSanboxDiv').hide(); deleteAll(); count = -1;\"><img src=\"<%=request.getContextPath()%>/images/NewDelete.png\" width=\"14\" height=\"14\" /></a><div id=\"addFile\"> </div>");
	}
	$(document).ready(function() {
		appendExecutable();
		//appendInputSandbox();
		});
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
	#reset {
		clear: both;
	}
	#myJdl{
		margin: 10px;
		padding: 10px;
		border: 1px solid gold;
		background-color: LightYellow; 
		float: left;
		width: 58%;
	}
	
	#myJdl input{
		width: 240px;
	}
	
	#addMenù{
	margin: 10px;
		padding: 10px;
		border: 1px solid green;
		background-color: LightGreen;
		float: right;
		width: 28%;
	}
	
	#addMenù div{
		margin: 5px 0;
		font-weight: bold;
	}
	
	
</style>

<div id="containerDirac">
	<div id="presentationDirac">My Jobs</div>
	<div id="contentDirac">
	
		<liferay-ui:error key="submit-error"
			message="submit-error" />
		<portlet:actionURL var="submitUrl">
			<portlet:param name="myaction" value="submitJob" />
		</portlet:actionURL>
		
		<jsp:useBean id="vos"
				type="java.util.List<it.italiangrid.portal.dbapi.domain.Vo>"
				scope="request" />
		
		
		
		<aui:form name="newJdl" action="${submitUrl }" commandName="jdl" enctype="multipart/form-data">
			<div id="myJdl">
				<aui:fieldset label="JDL">
					<aui:input type="text" label="Job Name" name="jobName" value="${jdl.jobName }"/>
					<div id="executableDiv">
						<aui:input type="text" id="executable" label="Executable" name="executable" value="${jdl.executable }"/>
					</div>
					<aui:input type="text" label="Arguments" name="arguments" value="${jdl.arguments }"/>
					
					<select name="vo">
					
						<c:forEach var="vo" items="${vos }">
							<c:if test="${vo.vo == defaultVo }">
								<option selected="true" value="${vo.vo }">${vo.vo } (Default)</option>
							</c:if>
							<c:if test="${vo.vo != defaultVo }">
								<option value="${vo.vo }">${vo.vo }</option>
							</c:if>
						</c:forEach>
					
					</select>
					
					<div id="stdOutputDiv" style="display: none;">
						<aui:input type="text" label="Standard Output" name="stdOutput" value="${jdl.stdOutput }"/>
					</div>
					<div id="stdErrorDiv" style="display: none;">
						<aui:input type="text" label="Standard Error" name="stdError" value="${jdl.stdError }"/>
					</div>
					<div id="cpuNumberDiv" style="display: none;">
						<aui:input type="text" label="CPU Number (MPI)" name="cpuNumber" value="${jdl.cpuNumber }"/>
					</div>
					<div id="hostNumberDiv" style="display: none;">
						<aui:input type="text" label="Host Number (MPI)" name="hostNumber" value="${jdl.hostNumber }"/>
					</div>
					<div id="wholeNodesDiv" style="display: none;">
						<aui:input type="text" label="Whole Nodes (MPI)" name="wholeNodes" value="${jdl.wholeNodes }"/>
					</div>
					<div id="smpGranularityDiv" style="display: none;">
						<aui:input type="text" label="SMP Granularity (MPI)" name="smpGranularity" value="${jdl.smpGranularity }"/>
					</div>
					<div id="outputSandboxDiv" style="display: none;">
						<aui:input type="text" label="Output Sandbox (For multiple files separate with ';')" name="outputSandboxRequest" value="${jdl.outputSandboxRequest }"/>
					</div>
					<div id="inputSanboxDiv" style="display: none;">
						<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> Input SandBox </label>
					</div>
				</aui:fieldset>
			</div>
			<div id="addMenù">
				<aui:fieldset label="Add or Remove fields">
					<div>
					<a id="stdoutadd" href="#stdOutputDiv" onclick="$('#stdOutputDiv').show(); $('#stdoutremove').show(); $('#stdoutadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Output</a>
					<a id="stdoutremove" style="display: none;" href="#stdOutputDiv" onclick="$('#stdOutputDiv').hide(); $('#stdoutadd').show(); $('#stdoutremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Output</a>
					</div>
					<div>
					<a id="stderradd" href="#stdErrorDiv" onclick="$('#stdErrorDiv').show(); $('#stderrremove').show(); $('#stderradd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Error</a>
					<a id="stderrremove" style="display: none;" href="#stdErrorDiv" onclick="$('#stdErrorDiv').hide(); $('#stderradd').show(); $('#stderrremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Error</a>
					</div>
					<div>
					<a id="outadd" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').show(); $('#outremove').show(); $('#outadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Output Sandbox</a>
					<a id="outremove" style="display: none;" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').hide(); $('#outadd').show(); $('#outremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Output Sandbox</a>
					</div>
					<div>
					<a href="#inputSanboxDiv" onclick="addFile();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Input Sandbox</a>
					</div>	
					<hr/>
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> MPI </label>
					<div>
					<a id="cpuadd" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').show(); $('#cpuremove').show(); $('#cpuadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> CPU Number</a>
					<a id="cpuremove" style="display: none;" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').hide(); $('#cpuadd').show(); $('#cpuremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> CPU Number</a>
					</div>
					<div>
					<a id="hostadd" href="#hostNumberDiv" onclick="$('#hostNumberDiv').show(); $('#hostremove').show(); $('#hostadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Host Number</a>
					<a id="hostremove" style="display: none;" href="#hostNumberDiv" onclick="$('#hostNumberDiv').hide(); $('#hostadd').show(); $('#hostremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Host Number</a>
					</div>
					<div>
					<a id="wholeadd" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').show(); $('#wholeremove').show(); $('#wholeadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Whole Nodes</a>
					<a id="wholeremove" style="display: none;" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').hide(); $('#wholeadd').show(); $('#wholeremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Whole Nodes</a>
					</div>
					<div>
					<a id="smpadd" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').show(); $('#smpremove').show(); $('#smpadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> SMP Granularity</a>
					<a id="smpremove" style="display: none;" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').hide(); $('#smpadd').show(); $('#smpremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> SMP Granularity</a>
					</div>
				</aui:fieldset>	
			</div>
			<div id="reset"></div>
			<aui:button-row>
			<aui:button type="submit" value="Submit"/>
			<portlet:actionURL var="goHome">
				<portlet:param name="myaction" value="goHome"></portlet:param>
			</portlet:actionURL>
			<aui:button type="button" value="Back" onClick="${goHome }"/>
			</aui:button-row>
		</aui:form>
	</div>
</div>