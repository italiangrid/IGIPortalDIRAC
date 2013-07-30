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
	
	(function ($) {

		/**********************************
		* CUSTOMIZE THE DEFAULT SETTINGS
		* Ex:
		* var _settings = {
		* 	id: 'modal',
		* 	src: function(sender){
		*		return jQuery(sender).attr('href');
		*	},
		* 	width: 800,
		* 	height: 600
		* }
		**********************************/
		var _settings3 = {
			width: 800, // Use this value if not set in CSS or HTML
			height: 600, // Use this value if not set in CSS or HTML
			overlayOpacity: .85, // Use this value if not set in CSS or HTML
			id: 'modal',
			fadeInSpeed: 0,
			fadeOutSpeed: 0
		};

		/**********************************
		* DO NOT CUSTOMIZE BELOW THIS LINE
		**********************************/
		$.modal3 = function (options) {
			return _modal3(this, options);
		};
		$.modal3.open = function () {
			_modal3.open();
		};
		$.modal3.close = function () {
			_modal3.close();
		};
		$.fn.modal3 = function (options) {
			return _modal3(this, options);
		};
		_modal3 = function (sender, params) {
			this.options = {
				parent: null,
				overlayOpacity: null,
				id: null,
				content: null,
				width: null,
				height: null,
				message: false,
				modalClassName: null,
				imageClassName: null,
				closeClassName: null,
				overlayClassName: null,
				src: null,
				redirect: null
			};
			this.options = $.extend({}, options, _defaults3);
			this.options = $.extend({}, options, _settings3);
			this.options = $.extend({}, options, params);
			this.close = function () {
				jQuery('.' + options.modalClassName + ', .' + options.overlayClassName).fadeOut(_settings3.fadeOutSpeed, function () { jQuery(this).unbind().remove(); });
			};
			this.open = function () {
				if (typeof options.src == 'function') {
					options.src = options.src(sender);
				} else {
					options.src = options.src || _defaults3.src(sender);
				}

				var fileExt = /^.+\.((jpg)|(gif)|(jpeg)|(png)|(jpg))$/i;
				var contentHTML = '';
				if (fileExt.test(options.src)) {
					contentHTML = '<div class="' + options.imageClassName + '"><img src="' + options.src + '"/></div>';

				} else {
					contentHTML = '<iframe width="' + options.width + '" height="' + options.height + '" frameborder="0" scrolling="yes" allowtransparency="true" src="' + options.src + '"></iframe>';
				}
				options.content = options.content || contentHTML;

				if (jQuery('.' + options.modalClassName).length && jQuery('.' + options.overlayClassName).length) {
					jQuery('.' + options.modalClassName).html(options.content);
				} else {
					$overlay = jQuery((_isIE63()) ? '<iframe src="BLOCKED SCRIPT\'<html></html>\';" scrolling="yes" frameborder="0" class="' + options.overlayClassName + '"></iframe><div class="' + options.overlayClassName + '"></div>' : '<div class="' + options.overlayClassName + '"></div>');
					$overlay.hide().appendTo(options.parent);

					$modal = jQuery('<div id="' + options.id + '" class="' + options.modalClassName + '" style="width:' + options.width + 'px; height:' + options.height + 'px; margin-top:-' + (options.height / 2) + 'px; margin-left:-' + (options.width / 2) + 'px;">' + options.content + '</div>');
					$modal.hide().appendTo(options.parent);

					$close = jQuery('<a class="' + options.closeClassName + '"></a>');
					$close.appendTo($modal);

					var overlayOpacity = _getOpacity3($overlay.not('iframe')) || options.overlayOpacity;
					$overlay.fadeTo(0, 0).show().not('iframe').fadeTo(_settings3.fadeInSpeed, overlayOpacity);
					$modal.fadeIn(_settings3.fadeInSpeed);
					
					//alert(options.message)
					if(options.message==false){
					//$close.click(function () { jQuery.modal().close(); location.href='https://halfback.cnaf.infn.it/casshib/shib/app4/login?service=https%3A%2F%2Fgridlab04.cnaf.infn.it%2Fc%2Fportal%2Flogin%3Fp_l_id%3D10671';});
					$close.click(function () { jQuery.modal().close(); location.href='https://halfback.cnaf.infn.it/casshib/shib/app1/login?service=https%3A%2F%2Fflyback.cnaf.infn.it%2Fc%2Fportal%2Flogin%3Fp_l_id%3D10669';});
					}else{
						if(options.redirect!=null){
							$close.click(function () { location.href=options.redirect; });
							$overlay.click(function () { location.href=options.redirect; });
						}else{
							$close.click(function () { jQuery.modal().close()});
							$overlay.click(function () { jQuery.modal().close(); });
						}
					}
					
				}
			};
			return this;
		};
		_isIE63 = function () {
			if (document.all && document.getElementById) {
				if (document.compatMode && !window.XMLHttpRequest) {
					return true;
				}
			}
			return false;
		};
		_getOpacity3 = function (sender) {
			$sender = jQuery(sender);
			opacity = $sender.css('opacity');
			filter = $sender.css('filter');

			if (filter.indexOf("opacity=") >= 0) {
				return parseFloat(filter.match(/opacity=([^)]*)/)[1]) / 100;
			}
			else if (opacity != '') {
				return opacity;
			}
			return '';
		};
		_defaults3 = {
			parent: 'body',
			overlayOpacity: 85,
			id: 'modal',
			content: null,
			width: 800,
			height: 600,
			modalClassName: 'modal-window',
			imageClassName: 'modal-image',
			closeClassName: 'close-window',
			overlayClassName: 'modal-overlay',
			src: function (sender) {
				return jQuery(sender).attr('href');
			},
			redirect: null
		};
	})(jQuery);
</script>

<style type="text/css">

	.modal-overlay {
		position: fixed;
		top: 0;
		right: 0;
		bottom: 0;
		left: 0;
		height: 100%;
		width: 100%;
		margin: 0;
		padding: 0;
		background: url(/IGIPortalDIRAC-0.0.1/images/overlay2.png) repeat;
		opacity: .85;
		filter: alpha(opacity=85);
		z-index: 101;
	}
	.modal-window {
		position: fixed;
		top: 50%;
		left: 50%;
		margin: 0;
		padding: 0;
		z-index: 102;
		background: #fff;
		border: solid 8px #000;
		-moz-border-radius: 8px;
		-webkit-border-radius: 8px;
	}
	.close-window {
		position: absolute;
		width: 47px;
		height: 47px;
		right: -23px;
		top: -23px;
		background: transparent url(/IGIPortalDIRAC-0.0.1/images/close-button2.png) no-repeat scroll right top;
		text-indent: -99999px;
		overflow: hidden;
		cursor: pointer;
	}


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
		<liferay-ui:error key="check-jdl"
			message="check-jdl" />	
			
		<portlet:actionURL var="submitUrl">
			<portlet:param name="myaction" value="submitJob" />
		</portlet:actionURL>
		
		<jsp:useBean id="vos"
				type="java.util.List<it.italiangrid.portal.dbapi.domain.Vo>"
				scope="request" />
		
		<br/><br/>showUploadCert: <c:out value="${showUploadCert}"/><br/><br/>
		
	
		
		
		<aui:form name="newJdl" action="${submitUrl }" commandName="jdl" enctype="multipart/form-data">
			<div id="myJdl">
				<aui:fieldset label="JDL">
					<aui:input type="text" label="Job Name" name="jobName" value="${jdl.jobName }"/>
					<div id="executableDiv">
						<aui:input type="text" id="executable" label="Executable" name="executable" value="${jdl.executable }"/>
					</div>
					<aui:input type="text" label="Arguments" name="arguments" value="${jdl.arguments }"/>
					<label for="selectVO"><strong>VO</strong></label><br/>
					<select id="selectVO" name="vo">
					
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
					<div id="parametersDiv" style="display: none;">
						<aui:input type="text" label="Parameters" name="parameters" value="${jdl.parameters }" />
					</div>
					<div id="parameterStartDiv" style="display: none;">
						<aui:input type="text" label="Parameter Start" name="parameterStart" value="${jdl.parameterStart }"/>
					</div>
					<div id="parameterStepDiv" style="display: none;">
						<aui:input type="text" label="Parameter Step" name="parameterStep" value="${jdl.parameterStep }"/>
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
					<a id="stdoutadd" href="#stdOutputDiv" onclick="$('#stdOutputDiv').show(); setTimeout( function() { $('#stdOutputDiv input').focus(); }, 500 ); $('#stdoutremove').show(); $('#stdoutadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Output</a>
					<a id="stdoutremove" style="display: none;" href="#stdOutputDiv" onclick="$('#stdOutputDiv').hide(); $('#stdoutadd').show(); $('#stdoutremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Output</a>
					</div>
					<div>
					<a id="stderradd" href="#stdErrorDiv" onclick="$('#stdErrorDiv').show(); setTimeout( function() { $('#stdErrorDiv input').focus(); }, 500 ); $('#stderrremove').show(); $('#stderradd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Standard Error</a>
					<a id="stderrremove" style="display: none;" href="#stdErrorDiv" onclick="$('#stdErrorDiv').hide(); $('#stderradd').show(); $('#stderrremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Standard Error</a>
					</div>
					<div>
					<a id="outadd" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').show(); setTimeout( function() { $('#outputSandboxDiv input').focus(); }, 500 ); $('#outremove').show(); $('#outadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Output Sandbox</a>
					<a id="outremove" style="display: none;" href="#outputSandboxDiv" onclick="$('#outputSandboxDiv').hide(); $('#outadd').show(); $('#outremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Output Sandbox</a>
					</div>
					<div>
					<a href="#inputSanboxDiv" onclick="addFile();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Input Sandbox</a>
					</div>	
					<hr/>
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> MPI </label>
					<div>
					<a id="cpuadd" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').show(); setTimeout( function() { $('#cpuNumberDiv input').focus(); }, 500 ); $('#cpuremove').show(); $('#cpuadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> CPU Number</a>
					<a id="cpuremove" style="display: none;" href="#cpuNumberDiv" onclick="$('#cpuNumberDiv').hide(); $('#cpuadd').show(); $('#cpuremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> CPU Number</a>
					</div>
					<div>
					<a id="hostadd" href="#hostNumberDiv" onclick="$('#hostNumberDiv').show(); setTimeout( function() { $('#hostNumberDiv input').focus(); }, 500 ); $('#hostremove').show(); $('#hostadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Host Number</a>
					<a id="hostremove" style="display: none;" href="#hostNumberDiv" onclick="$('#hostNumberDiv').hide(); $('#hostadd').show(); $('#hostremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Host Number</a>
					</div>
					<div>
					<a id="wholeadd" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').show(); setTimeout( function() { $('#wholeNodesDiv input').focus(); }, 500 ); $('#wholeremove').show(); $('#wholeadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Whole Nodes</a>
					<a id="wholeremove" style="display: none;" href="#wholeNodesDiv" onclick="$('#wholeNodesDiv').hide(); $('#wholeadd').show(); $('#wholeremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Whole Nodes</a>
					</div>
					<div>
					<a id="smpadd" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').show(); setTimeout( function() { $('#smpGranularityDiv input').focus(); }, 500 ); $('#smpremove').show(); $('#smpadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> SMP Granularity</a>
					<a id="smpremove" style="display: none;" href="#smpGranularityDiv" onclick="$('#smpGranularityDiv').hide(); $('#smpadd').show(); $('#smpremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> SMP Granularity</a>
					</div>
					<hr/>
					<label id="aui_3_4_0_1_1045" class="aui-field-label" for="_IGIPortalDIRAC_WAR_IGIPortalDIRAC001_INSTANCE_mpwer7lWR8f9_inputSandbox"> PARAMETRIC </label>
					<div>
					<a id="parametersadd" href="#parametersDiv" onclick="$('#parametersDiv').show(); $('#parametersremove').show(); $('#parametersadd').hide(); alert('Provide a number or a list \'semicolon\' separated.\nUse \'%s\' where you want your parameter is placed.'); setTimeout( function() { $('#parametersDiv input').focus(); }, 500 );"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameters</a>
					<a id="parametersremove" style="display: none;" href="#parametersDiv" onclick="$('#parametersDiv').hide(); $('#parametersadd').show(); $('#parametersremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameters</a>
					</div>
					<div>
					<a id="parameterStartadd" href="#parameterStartDiv" onclick="$('#parameterStartDiv').show(); setTimeout( function() { $('#parameterStartDiv input').focus(); }, 500 ); $('#parameterStartremove').show(); $('#parameterStartadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameter Start</a>
					<a id="parameterStartremove" style="display: none;" href="#parameterStartDiv" onclick="$('#parameterStartDiv').hide(); $('#parameterStartadd').show(); $('#parameterStartremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameter Start</a>
					</div>
					<div>
					<a id="parameterStepadd" href="#parameterStepDiv" onclick="$('#parameterStepDiv').show(); setTimeout( function() { $('#parameterStepDiv input').focus(); }, 500 ); $('#parameterStepremove').show(); $('#parameterStepadd').hide();"><img src="<%=request.getContextPath()%>/images/NewAdd.png" width="14" height="14" /> Parameter Step</a>
					<a id="parameterStepremove" style="display: none;" href="#parameterStepDiv" onclick="$('#parameterStepDiv').hide(); $('#parameterStepadd').show(); $('#parameterStepremove').hide();"><img src="<%=request.getContextPath()%>/images/NewDelete.png" width="14" height="14" /> Parameter Step</a>
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