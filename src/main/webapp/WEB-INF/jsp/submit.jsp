<%@ include file="/WEB-INF/jsp/init.jsp"%>

<script type="text/javascript" src="https://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>


	

<script type="text/javascript">

	var map = {};
	<c:forEach var="vo" items="${vos }">
		map['${vo.vo}'] = '${voListMatch[vo.vo]}';
	</c:forEach>
	
	var count = 0;
	function deleteFile(divName){
		$("#"+divName).remove();
		count = count - 1;
		if(count == 0){
			$("#inputSanboxDiv").hide();
		}
	}
	
	$('#addedFile_${count }').remove();
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
		$("#executableDiv .aui-field-element").html("<input id=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executable\" class=\"aui-field-input aui-field-input-text\" type=\"text\" value=\"/bin/ls\" name=\"_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_executable\">  or <a href=\"#executableDiv\" onClick=\"uploadExecutable(); $('#argumentsDiv input').val('');\">Upload your executable</a>");
	}
	
	function appendExecutable(){
		$("#executableDiv .aui-field-element").append("  or <a href=\"#executableDiv\" onClick=\"uploadExecutable(); $('#argumentsDiv input').val('');\">Upload your executable</a>");
	}
	
	function appendInputSandbox(){
		$("#inputSanboxDiv .aui-field-element").append(" <a href=\"#inputSanboxDiv\" onClick=\"$('#inputSanboxDiv').hide(); deleteAll(); count = -1;\"><img src=\"<%=request.getContextPath()%>/images/NewDelete.png\" width=\"14\" height=\"14\" /></a><div id=\"addFile\"> </div>");
	}
	
	function changeMoreHelpVisibility(divId, linkText){
		if ($('#'+divId).css('display') == 'none') {
			$('#'+divId).show();
			linkText.text('Less');
		}else{
			$('#'+divId).hide();
			linkText.text('More');
		}
	}
	
	function changeCheckbox(input, share, saveOnly){
		if(input.attr('checked')=='checked'){
			$("#"+share).removeAttr("disabled");
			$("#"+saveOnly).removeAttr("disabled");
			$('#submitButton').attr('value','Save & Submit');
			$('#checks').show('slow');
		}else{
			$("#"+share).attr("disabled", true);
			$("#"+share).removeAttr("checked");
			$("#"+saveOnly).attr("disabled", true);
			$("#"+saveOnly).removeAttr("checked");
			$('#submitButton').attr('value','Submit');
			$('#checks').hide('slow');
		}
	}
	
	function changeTemplate(){
		if ($('.templates').css('display') == 'none') {
			$('.templates').show('slow');
			$('.jdlDiv').hide('slow');
		}else{
			$('.templates').hide('slow');
			$('.jdlDiv').show('slow');
			$("#saveAsTemplate").attr('checked', true);
			$("#saveOnly").attr('checked', true);
			changeCheckbox($('#saveAsTemplate'), 'shareTemplate', 'saveOnly');
			changeSubmitButton($('#saveOnly'))
		}
	}
	
	function changeSubmitButton(el){
		if(el.attr('checked')=='checked'){
			$('#submitButton').attr('value','Save');
		}else{
			$('#submitButton').attr('value','Save & Submit');
		}
	}
	
	var list = new Array();
	
	/**
	 * Function that show the delete button if some virtual machine are selected, or hide the button if none.
	 * @param jobId - The virtual machine identifier selected.
	 */
	function viewOrHideOperationButton(jobId) {
		var i = 0;
		var newlist = new Array();
		var isPresent = false;
		for (i = 0; i < list.length; i++) {
			if (list[i] != jobId) {
				newlist.push(list[i]);
			} else {
				isPresent = true;
			}
		}
	
		if (isPresent == false)
			list.push(jobId);
		else
			list = newlist;
	
		if (list.length == 0) {
			$(".operationButton").hide("slow");
		} else {
			$(".operationButton").show("slow");
		}
	}
	
	function setAll(element){
		var val = element.attr('checked');
		if(val == "checked"){
			$(".operationCheckbox").attr('checked', true);
			$(".operationButton").show("slow");
		}else{
			$(".operationCheckbox").attr('checked', false);
			$(".operationButton").hide("slow");
		}
		
	}
	
	function changeSites(){
		$("#selectSite").empty();
		
		var vo = $("#selectVO").val();
		var list = map[vo].split(';');
		
		list.forEach(function(entry) {
		    $("#selectSite").append("<option value=\"LCG." + entry + ".it\">" + entry + "</option>");
		});
		selectSite();
	}
	
	function resetSite(){
		$("#selectSite ").val('LCG.ANY.it');
		var html = "<strong>Site Selected:</strong><br/>ANY";
		$("#displaySite").html(html);
		
	}
	
	function updateSite(){
		
		//get values from #selectSite
		var site = $("#selectSite ").val() || [];
		var htmlString = "<strong>Site Selected:</strong><br/>";
		
		//htmlString = htmlString.join(", ");
		
		//alert(site);
		
		if(site.length==0){
			htmlString = htmlString + "ANY";
		}
		
		//update values on #displaySite
		
		var html = htmlString+site
		html = html.replace(/,/g, '<br />');
		
		if(html.indexOf("ANY") > -1){
			resetSite();
		}else{
			$("#displaySite").html(html);
		}
	}
	
	function selectSite(){
		
		var sites = new Array();
		
		<c:forEach var="item" items="${jdl.site }">
			sites.push("${item}");
		</c:forEach>
		
		$("#selectSite ").val(sites);
		updateSite();
	}
	
	$(document).ready(function() {
		appendExecutable();
		$('#template_table').dataTable({
	        "paging":   false,
	        "ordering": false,
	        "info":     false
	    });
		//appendInputSandbox();
		});
</script>

<div id="containerDirac">
	<div id="presentationDirac">My Jobs</div>
	<div id="contentDirac">
	
		<liferay-ui:success key="save-successufully"
			message="save-successufully" />
		<liferay-ui:success key="shared-successufully"
			message="shared-successufully" />
		<liferay-ui:success key="unshared-successufully"
			message="unshared-successufully" />
		<liferay-ui:success key="deleting-template-successufully"
			message="deleting-template-successufully" />
	
		<liferay-ui:error key="submit-error"
			message="submit-error" />
		<liferay-ui:error key="check-jdl"
			message="check-jdl" />	
		<liferay-ui:error key="deleting-template-error"
			message="deleting-template-error" />
		<liferay-ui:error key="save-error"
			message="save-error" />
		<liferay-ui:error key="shared-error"
			message="shared-error" />
		<liferay-ui:error key="operation-error"
			message="operation-error" />
			
		<portlet:actionURL var="submitUrl">
			<portlet:param name="myaction" value="submitJob" />
		</portlet:actionURL>
		<portlet:actionURL var="goHome">
			<portlet:param name="myaction" value="goHome"></portlet:param>
			<portlet:param name="settedPath" value="${jdl.path }"></portlet:param>
		</portlet:actionURL>
		
		<jsp:useBean id="vos"
				type="java.util.List<it.italiangrid.portal.dbapi.domain.Vo>"
				scope="request" />
		<jsp:useBean id="templateList"
				type="java.util.List<it.italiangrid.portal.dirac.model.Template>"
				scope="request" />	
		
		<c:if test="${jdl.path == '' }">
			<aui:form>
			<aui:button-row>
			<div class="jdlDiv">
				<aui:button type="button" value="Use Template" onClick="changeTemplate();"/>
			</div>
			</aui:button-row>
			</aui:form>
		</c:if>
		
		<div class="templates tempaltesCss">
			<portlet:actionURL var="operationMultipleTemplateUrl">
				<portlet:param name="myaction" value="operationMultipleTemplate"/>
			</portlet:actionURL>
			
			<form id="multipleTemplateForm" name="opMultForm" action="${operationMultipleTemplateUrl}" method="POST">
			
				<div class="operationButton" style="display: none;">
					<aui:button-row>
						
					<aui:button type="submit" value="Delete"
						onClick="return confirm('Are you sure you want to delete these tempaltes?');" />
					<aui:button type="button" value="Share" onClick="$('#operation').val('share'); $('#multipleTemplateForm').submit();"/>
					<aui:button type="button" value="Private" onClick="$('#operation').val('unshare'); $('#multipleTemplateForm').submit();"/>
					</aui:button-row>
				</div>
			
			
				<input id="operation" type="hidden" name="operation" value="delete"/>
				
				<table id="template_table" class="taglib-search-iterator">
				
					<thead>
						<tr  class="portlet-section-header results-header">
							<th class="col-1 first sorting">Sel <input type='checkbox' onclick='setAll($(this));'/></th>
							<th class="col-2 sorting">Name</th>
							<th class="col-3 sorting center">Type</th>
							<th class="col-4 sorting center">Owner</th>
							<th class="col-5 last sorting">Action</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="template" items="${templateList }" > 
							<tr class="results-row portlet-section-alternate-hover effect">
								<td class="center">
									<c:if test="${template.owner == user.userId}">
										<input class="operationCheckbox" name="templateList" type="checkbox"
											value="${template.path }"
											onchange="viewOrHideOperationButton('${template.path }');"></input>
									</c:if>
								</td>
								<td>${template.name }</td>
								<td  class="center">${template.type }</td>
								<td  class="center">
									<c:if test="${template.owner == user.userId}">
										<span class="ownerYes">Yes</span>
									</c:if>
									<c:if test="${template.owner != user.userId}">
										<span class="ownerNo">No</span>
									</c:if>
								</td>
								<td style="text-align: right;">
									<liferay-ui:icon-menu>
								
										<portlet:renderURL var="useTemplateURL">
											<portlet:param name="myaction" value="showSubmitJob"/>
											<portlet:param name="path" value="${template.path }"/>
										</portlet:renderURL>
										<liferay-ui:icon image="edit" message="Edit" url="${useTemplateURL}" />
										
										<c:if test="${template.owner == user.userId}">
											<c:if test="${template.type == 'Private' }">
												<portlet:actionURL var="shareTemplateURL">
													<portlet:param name="myaction" value="shareTemplate"/>
													<portlet:param name="path" value="${template.path }"/>
												</portlet:actionURL>
												<liferay-ui:icon image="links" message="Share" url="${shareTemplateURL}" />
											</c:if>
											<c:if test="${template.type == 'Shared' }">
												<portlet:actionURL var="unshareTemplateURL">
													<portlet:param name="myaction" value="unshareTemplate"/>
													<portlet:param name="path" value="${template.path }"/>
												</portlet:actionURL>
												<liferay-ui:icon image="page" message="Private" url="${unshareTemplateURL}" />
											</c:if>
											<portlet:actionURL  var="deleteTemplateURL">
												<portlet:param name="myaction" value="deleteTemplate"/>
												<portlet:param name="path" value="${template.path }"/>
											</portlet:actionURL>
											<liferay-ui:icon-delete url="${deleteTemplateURL}" />
										</c:if>
									
									</liferay-ui:icon-menu>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				
				</table>
				
				<c:if test="${fn:length(templateList) > 15 }">
					<div class="operationButton" style="display: none;">
						<aui:button-row>
							
							<aui:button type="submit" value="Delete"
								onClick="return confirm('Are you sure you want to delete these tempaltes?');" />
							<aui:button type="button" value="Share" onClick="$('#operation').val('share'); $('#multipleJobForm').submit();"/>
							<aui:button type="button" value="Private" onClick="$('#operation').val('unshare'); $('#multipleJobForm').submit();"/>
						</aui:button-row>
					</div>
				</c:if>
			</form>
			
			<aui:form name="back" action="${goHome }">
			<aui:button-row>
			<aui:button type="button" value="Create New Template" onClick="changeTemplate();"/>
			<aui:button type="submit" value="Job List"/>
			</aui:button-row>
			</aui:form>
		</div>	
		<div  class="jdlDiv">
		<aui:form name="newJdl" action="${submitUrl }" commandName="jdl" enctype="multipart/form-data">
			<div id="myJdl">
				<aui:fieldset label="JDL">
					<aui:input type="text" label="Job Name" name="jobName" value="${jdl.jobName }"/>
					<div id="executableDiv">
						<aui:input type="text" id="executable" label="Executable" name="executable" value="${jdl.executable }"/>
					</div>
					<div id="argumentsDiv">
						<aui:input type="textarea" cols="80" rows ="5" label="Arguments" name="arguments" value="${jdl.arguments }"/>
					</div>
					<c:if test="${fn:length(vos)>1 }">
					<label for="selectVO"><strong>VO</strong></label><br/>
					<select id="selectVO" name="vo" onchange="changeSites();">
					
						<c:forEach var="vo" items="${vos }">
							<c:if test="${vo.vo == defaultVo }">
								<option selected="true" value="${vo.vo }">${vo.vo } (Default)</option>
							</c:if>
							<c:if test="${vo.vo != defaultVo }">
								<option value="${vo.vo }">${vo.vo }</option>
							</c:if>
						</c:forEach>
					
					</select>
					</c:if>
					<c:if test="${fn:length(vos)==1 }">
						<aui:input type="hidden" name="vo" value="${vos[0].vo }"/>
					</c:if>
					
					<aui:input type="hidden" name="myProxyServer" value="${jdl.myProxyServer }"/>
					<aui:input type="hidden" name="settedPath" value="${jdl.path }"/>
					
					<div id="stdOutputDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Standard Output" name="stdOutput" value="${jdl.stdOutput }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#stdOutputDiv').hide(); $('#stdoutadd').show(); $('#stdoutremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div id="stdErrorDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Standard Error" name="stdError" value="${jdl.stdError }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#stdErrorDiv').hide(); $('#stderradd').show(); $('#stderrremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div id="parametersDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Parameters" name="parameters" value="${jdl.parameters }" />
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#parametersDiv').hide(); $('#parametersadd').show();  $('#parametersremove').hide(); $('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parametersDiv input').val(''); $('#parameterStartDiv input').val(''); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
						<div class="help" style="float: left; width: 100%;">
							<strong>Help:</strong> Parameters can be a list or a number. <a href="#moreHelpParameters" onclick="changeMoreHelpVisibility('moreHelpParameters', $(this));">More</a>
							<div id="moreHelpParameters" class="moreHelp" style="width: 80%;">
								<ul>
									<li>A list of strings or numbers separate by ";". eg. 1;2;3</li>
									<li>An integer (eg. 100), in this case the attributes <a href="#parameterStartDiv" onclick="$('#parameterStartDiv').show(); setTimeout( function() { $('#parameterStartDiv input').focus(); }, 200 ); $('#parameterStartremove').show(); $('#parameterStartadd').hide();">Parameter Start</a> (eg. 20) and <a href="#parameterStartDiv" onclick="$('#parameterStepDiv').show(); setTimeout( function() { $('#parameterStepDiv input').focus(); }, 200 ); $('#parameterStepremove').show(); $('#parameterStepadd').hide();">Parameter Step</a> (eg. 2) must be defined as integers to create the list of job parameters.</li>
								</ul>
								The other JDL attributes can contain "%s" placeholder. For each generated job this placeholder will be replaced by one of the values in the Parameters list. (eg. Job Name = "%s_parametric";) <br/>
								<a href="https://github.com/DIRACGrid/DIRAC/wiki/JobManagementAdvanced" target="_blank">Dirac Wiki</a>
							</div>
						</div>
						
						
					</div>
					
					<div id="parameterStartDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Parameter Start" name="parameterStart" value="${jdl.parameterStart }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStartDiv input').val(''); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>

					<div id="parameterStepDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Parameter Step" name="parameterStep" value="${jdl.parameterStep }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStartDiv input').val(''); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					
					<div id="cpuNumberDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="CPU Number (MPI)" name="cpuNumber" value="${jdl.cpuNumber }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#cpuNumberDiv').hide(); $('#cpuadd').show(); $('#cpuremove').hide(); $('#cpuNumberDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					
					<div id="hostNumberDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Host Number (MPI)" name="hostNumber" value="${jdl.hostNumber }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#hostNumberDiv').hide(); $('#hostadd').show(); $('#hostremove').hide(); $('#hostNumberDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					
					<div id="wholeNodesDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="Whole Nodes (MPI)" name="wholeNodes" value="${jdl.wholeNodes }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#wholeNodesDiv').hide(); $('#wholeadd').show(); $('#wholeremove').hide(); $('#wholeNodesDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
						<div class="help">
							<strong>Help:</strong> True or False. 
						</div>
					</div>
					
					<div id="smpGranularityDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="text" label="SMP Granularity (MPI)" name="smpGranularity" value="${jdl.smpGranularity }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#smpGranularityDiv').hide(); $('#smpadd').show(); $('#smpremove').hide(); $('#smpGranularityDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
					
					<div id="requirementsDiv" style="display: none;">
						
						<div style="float: left;">
							<aui:input type="textarea" cols="80" rows ="5" label="Requirements" name="requirements" value="${jdl.requirements }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#requirementsDiv').hide(); $('#requirementsadd').show(); $('#requirementsremove').hide(); $('#requirementsDiv textarea').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
						<div class="help">
							<strong>Example:</strong> (other.GlueHostMainMemoryRAMSize>1024)&&(GlueCEStateFreeCPUs>2)<br/>
							Do not specify a target CE or queue, but use the <a href="#siteDiv" onclick="$('#sitesDiv').show(); setTimeout( function() { $('#sitesDiv input').focus(); }, 200 ); $('#sitesremove').show(); $('#sitesadd').hide();">Site</a> field.
						</div>
					</div>
					
					<div id="sitesDiv" style="display: none; margin-top: 10px;">
						
						<div style="float: left;">
							<label for="selectSite"><strong>Site</strong></label><br/>
							<select id="selectSite" name="site" multiple onchange="updateSite()">
						
							<c:set var="sitesList" value="${fn:split(voListMatch[defaultVo], ';') }"/>
							<c:forEach var="site" items="${sitesList }">
								<option value="LCG.${site }.it">${site }</option>
							</c:forEach>
						
							</select>
						</div>
						
						<div id="displaySite" style="float: left; margin-top: 15px; padding: 5px; margin-left: 4px; min-width:50px; border: dotted 1px grey; "></div>
						<div style="float: left; margin-top: 20px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#sitesDiv').hide(); $('#sitesadd').show(); $('#sitesremove').hide(); resetSite();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
					</div>
								
					<div id="outputSandboxDiv" style="display: none;">
						<div style="float: left;">
							<aui:input type="text" label="Output Sandbox" name="outputSandboxRequest" value="${jdl.outputSandboxRequest }"/>
						</div>
						<div style="float: left; margin-top: 32px; margin-left: 4px;">
							<a href="#addFile" onclick="$('#outputSandboxDiv').hide(); $('#outadd').show(); $('#outremove').hide(); $('#outputSandboxDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a>
						</div>
						<div style="clear: both;"></div>
						<div class="help">
							<strong>Help:</strong> Separate with <strong>";"</strong> for multiple files. 
						</div>
					</div>
					
					<div id="inputSanboxDiv" style="display: none;">
						<label style="margin-top: 10px;" id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> Input SandBox </label>
						<div class="help">
							<strong>Help:</strong> If the file name contains white spaces, these will be replaced with '_'.
						</div>
						<c:set var="count" value="0"/>
						
						<c:forTokens items="${jdl.inputSandbox }" delims="," var="input">
							<c:forTokens items="${input }" delims="/" var="last">
								<c:set var="fileName" value="${last }"/>
							</c:forTokens>
							<c:if test="${fn:replace(fn:replace(fileName, ']', ''), '[', '')!=jdl.executable }">
								<div id="addedFile_${count }"><input id="uploadedFile_${count }" type="input" name="uploadedFile_${count }" value="${fn:replace(fn:replace(fileName, ']', ''), '[', '') }"  readonly> <a href="#addFile" onclick="deleteFile('addedFile_${count }');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /></a></div>
								<c:set var="count" value="${count + 1 }"/>
							</c:if>
						</c:forTokens>
						<script type="text/javascript">
							
							count=${count};
							if(count>0){
								$("#inputSanboxDiv").show();
							}
						</script>
						
					</div>
				</aui:fieldset>
				
				
			</div>
			<div id="addMenu">
				<aui:fieldset label="Add or Remove fields">
					<div>
					<a id="stdoutadd" href="#stdOutputDiv" onclick="$('#stdOutputDiv').show(); setTimeout( function() { $('#stdOutputDiv input').focus(); }, 200 ); $('#stdoutremove').show(); $('#stdoutadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Output</a>
					<a id="stdoutremove" style="display: none;" href="#stdOutputDiv" onclick="$('#stdOutputDiv').hide(); $('#stdoutadd').show(); $('#stdoutremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Output</a>
					</div>
					<div>
					<a id="stderradd" href="#stdErrorDiv" onclick="$('#stdErrorDiv').show(); setTimeout( function() { $('#stdErrorDiv input').focus(); }, 200 ); $('#stderrremove').show(); $('#stderradd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Error</a>
					<a id="stderrremove" style="display: none;" href="#stdErrorDiv" onclick="$('#stdErrorDiv').hide(); $('#stderradd').show(); $('#stderrremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Error</a>
					</div>
					<div>
					<a id="outadd" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').show(); setTimeout( function() { $('#outputSandboxDiv input').focus(); }, 200 ); $('#outremove').show(); $('#outadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Output Sandbox</a>
					<a id="outremove" style="display: none;" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').hide(); $('#outadd').show(); $('#outremove').hide(); $('#outputSandboxDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Output Sandbox</a>
					</div>
					<div>
					<a href="#inputSanboxDiv" onclick="addFile();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Input Sandbox</a>
					</div>	
					<hr/>
					<div style="display: none;">
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> MPI </label>
					<div>
					<a id="cpuadd" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').show(); setTimeout( function() { $('#cpuNumberDiv input').focus(); }, 200 ); $('#cpuremove').show(); $('#cpuadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> CPU Number</a>
					<a id="cpuremove" style="display: none;" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').hide(); $('#cpuadd').show(); $('#cpuremove').hide(); $('#cpuNumberDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> CPU Number</a>
					</div>
					<div>
					<a id="hostadd" href="#hostNumberDiv" onclick="$('#hostNumberDiv').show(); setTimeout( function() { $('#hostNumberDiv input').focus(); }, 200 ); $('#hostremove').show(); $('#hostadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Host Number</a>
					<a id="hostremove" style="display: none;" href="#hostNumberDiv" onclick="$('#hostNumberDiv').hide(); $('#hostadd').show(); $('#hostremove').hide(); $('#hostNumberDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Host Number</a>
					</div>
					<div>
					<a id="wholeadd" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').show(); setTimeout( function() { $('#wholeNodesDiv input').focus(); }, 200 ); $('#wholeremove').show(); $('#wholeadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Whole Nodes</a>
					<a id="wholeremove" style="display: none;" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').hide(); $('#wholeadd').show(); $('#wholeremove').hide(); $('#wholeNodesDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Whole Nodes</a>
					</div>
					<div>
					<a id="smpadd" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').show(); setTimeout( function() { $('#smpGranularityDiv input').focus(); }, 200 ); $('#smpremove').show(); $('#smpadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> SMP Granularity</a>
					<a id="smpremove" style="display: none;" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').hide(); $('#smpadd').show(); $('#smpremove').hide(); $('#smpGranularityDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> SMP Granularity</a>
					</div>
					<hr/>
					</div>
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> PARAMETRIC </label>
					<div>
					<a id="parametersadd" href="#parametersDiv" onclick="$('#parametersDiv').show(); $('#parametersremove').show(); $('#parametersadd').hide(); setTimeout( function() { $('#parametersDiv input').focus(); }, 200 );"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameters</a>
					<a id="parametersremove" style="display: none;" href="#parametersDiv" onclick="$('#parametersDiv').hide(); $('#parametersadd').show();  $('#parametersremove').hide(); $('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parametersDiv input').val(''); $('#parameterStartDiv input').val(''); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameters</a>
					</div>
					<div>
					<a id="parameterStartadd" href="#parameterStartDiv" onclick="$('#parametersDiv').show(); $('#parametersremove').show(); $('#parametersadd').hide(); $('#parameterStepDiv').show(); $('#parameterStepremove').show(); $('#parameterStepadd').hide(); $('#parameterStartDiv').show(); setTimeout( function() { $('#parameterStartDiv input').focus(); }, 200 ); $('#parameterStartremove').show(); $('#parameterStartadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameter Start</a>
					<a id="parameterStartremove" style="display: none;" href="#parameterStartDiv" onclick="$('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStartDiv input').val(''); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameter Start</a>
					</div>
					<div>
					<a id="parameterStepadd" href="#parameterStepDiv" onclick="$('#parametersDiv').show(); $('#parametersremove').show(); $('#parametersadd').hide(); $('#parameterStartDiv').show(); $('#parameterStartremove').show(); $('#parameterStartadd').hide(); $('#parameterStepDiv').show(); setTimeout( function() { $('#parameterStepDiv input').focus(); }, 200 ); $('#parameterStepremove').show(); $('#parameterStepadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameter Step</a>
					<a id="parameterStepremove" style="display: none;" href="#parameterStepDiv" onclick="$('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide(); $('#parameterStartDiv input').val(''); $('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide(); $('#parameterStepDiv input').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameter Step</a>
					</div>
					<hr/>
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> REQUIREMENTS </label>
					<div>
					<a id="requirementsadd" href="#requirementsDiv" onclick="$('#requirementsDiv').show(); setTimeout( function() { $('#requirementsDiv input').focus(); }, 200 ); $('#requirementsremove').show(); $('#requirementsadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Requirements</a>
					<a id="requirementsremove" style="display: none;" href="#requirementsDiv" onclick="$('#requirementsDiv').hide(); $('#requirementsadd').show(); $('#requirementsremove').hide(); $('#requirementsDiv textarea').val('');"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Requirements</a>
					</div>
					<div>
					<a id="sitesadd" href="#sitesDiv" onclick="$('#sitesDiv').show(); setTimeout( function() { $('#sitesDiv input').focus(); }, 200 ); $('#sitesremove').show(); $('#sitesadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Sites</a>
					<a id="sitesremove" style="display: none;" href="#sitesDiv" onclick="$('#sitesDiv').hide(); $('#sitesadd').show(); $('#sitesremove').hide(); resetSite();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Sites</a>
					</div>
				</aui:fieldset>	
			</div>
			<div id="reset"></div>
			<input id="saveAsTemplate" name="saveAsTemplate" type="checkbox" onClick="changeCheckbox($(this), 'shareTemplate', 'saveOnly');"/> <Strong>Save As Template</Strong><br/>
			<div id="checks" style="margin: 0 0 0 15px; display: none;">
			<input id="saveOnly" name="saveOnly" type="checkbox"  disabled="disabled" onClick="changeSubmitButton($(this));"/> <Strong>Don't Submit Now</Strong><br/>
			<input id="shareTemplate" name="shareTemplate" type="checkbox"  disabled="disabled"/> <Strong>Share Template</Strong>
			</div>
			<aui:button-row>
			<aui:button id="submitButton" type="submit" value="Submit"/>
			<aui:button type="button" value="Job List" onClick="${goHome }"/>
			</aui:button-row>
		</aui:form>
		</div>
	</div>
</div>

<script type="text/javascript">

	if("${jdl.stdOutput }"!="StdOut"){
		$("#stdOutputDiv").show();
		$('#stdoutremove').show();
		$('#stdoutadd').hide();
	}
	
	if("${jdl.stdError }"!="StdErr"){
		$("#stdErrorDiv").show();
		$('#stderrremove').show();
		$('#stderrremove').hide();
	}

	if("${jdl.parameters }"!=""){
		$("#parametersDiv").show();
		$('#parametersremove').show();
		$('#parametersadd').hide();
	}

	if("${jdl.parameterStart }"!=""){
		$("#parameterStartDiv").show();
		$('#parameterStartremove').show();
		$('#parameterStartadd').hide();
	}

	if("${jdl.parameterStep }"!=""){
		$("#parameterStepDiv").show();
		$('#parameterStepremove').show();
		$('#parameterStepadd').hide();
	}

	if("${jdl.cpuNumber }"!=""){
		$("#cpuNumberDiv").show();
		$('#cpuremove').show();
		$('#cpuadd').hide();
	}

	if("${jdl.hostNumber }"!=""){
		$("#hostNumberDiv").show();
		$('#hostremove').show();
		$('#hostadd').hide();
	}

	if("${jdl.wholeNodes }"!=""){
		$("#wholeNodesDiv").show();
		$('#wholeremove').show();
		$('#wholeadd').hide();
	}

	if("${jdl.smpGranularity }"!=""){
		$("#smpGranularityDiv").show();
		$('#smpremove').show(); 
		$('#smpadd').hide();
	}

	if("${jdl.requirements }"!=""){
		$("#requirementsDiv").show();
		$('#requirementsremove').show();
		$('#requirementsadd').hide();
	}

	if("${jdl.site.size() > 0}" == "true"){
		if(!("${jdl.site.size() == 1}" == "true" && "${jdl.site[0] }" == "LCG.ANY.it")){
			selectSite();
			$("#sitesDiv").show();
			$('#sitesremove').show(); 
			$('#sitesadd').hide();
		}
	}
	if("${jdl.outputSandboxRequest }"!=""){
		$("#outputSandboxDiv").show();
		$('#outremove').show(); 
		$('#outadd').hide();
	}
	
	if("${viewTemplate}"=='true'){
		$('.templates').show();
	}else{
		$('.jdlDiv').show();
	}
	
</script>


<c:if test="${showUploadCert==true}">
	<liferay-portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>" var="popUpUrl">
		<portlet:param name="myaction" value="showUploadCert" />
	</liferay-portlet:renderURL>
	
	<liferay-portlet:renderURL var="homeUrl">
		<portlet:param name="myaction" value="showHome" />
	</liferay-portlet:renderURL>

	<div style="display:none">
		<form id="submitThis" action="javascript:$(this).modal3({width:800, height:400, message:true, redirect:'${homeUrl}', src: '${popUpUrl}'}).open(); return false;"></form>
	</div>

	<script>
		$(this).modal3({width:800, height:400, message:true, redirect:'${homeUrl}', src: '${popUpUrl}'}).open();
	</script>
</c:if>