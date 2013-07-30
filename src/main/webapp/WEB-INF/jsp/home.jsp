<%@ include file="/WEB-INF/jsp/init.jsp"%>

<script type="text/javascript">

	var list = new Array();
	
	/**
	 * Function that show the delete button if some virtual machine are selected, or hide the button if none.
	 * @param jobId - The virtual machine identifier selected.
	 */
	function viewOrHideDeleteButton(jobId) {
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
			$(".deleteButton").hide("slow");
		} else {
			$(".deleteButton").show("slow");
		}
	}
	
	$(document).ready(function() {
		alert(${isAllJobsTerminate});
		alert(${isAllJobsTerminate}==false);
		if(${isAllJobsTerminate}==false){
			setTimeout(function(){
				location.href='https://flyback.cnaf.infn.it/dirac';
		    }, 20000);
		}
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
				src: null
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
						$close.click(function () { window.location.href='https://flyback.cnaf.infn.it/dirac'; });
						$overlay.click(function () { window.location.href='https://flyback.cnaf.infn.it/dirac'; });
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
			}
		};
	})(jQuery);
	
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
	.status {
		height: 15px;
		width: 15px;
		border: 1px solid black;
		float: left;
		margin-right: 10px;
	}
	
	#statusValue {
		float: left;
	}
	
	#failedStatus {
		background-color: red;
	}
	
	#doneStatus {
		background-color: green;
	}
	
	#receivedStatus {
		background-color: grey;
	}
	
	#waitingStatus {
		background-color: orange;
	}
	
	#runningStatus {
		background-color: blue;
	}
	
	#deletedStatus {
		background-color: darkgrey;
	}
	
	#reset {
		clear: both;
	}
	
	.rightAlign{
		float: right;
	}
	
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
</style>

<div id="containerDirac">
	<div id="presentationDirac">My Jobs</div>
	<div id="contentDirac">
	
		<liferay-ui:success key="submit-successufully"
			message="submit-successufully" />
			<liferay-ui:success key="upload-successufully"
			message="upload-successufully" />
		<liferay-ui:success key="resheduling-successufully"
			message="resheduling-successufully" />
		<liferay-ui:success key="deleting-successufully"
			message="deleting-successufully" />
			
		<liferay-ui:error key="rescheduling-error"
			message="rescheduling-error" />
		<liferay-ui:error key="deleting-error"
			message="deleting-error" />
	
		<portlet:renderURL var="submitUrl">
			<portlet:param name="myaction" value="showSubmitJob" />
		</portlet:renderURL>
		
		<aui:fieldset>
		<aui:column columnWidth="50">
			<aui:form action="${submitUrl }">
				<aui:button-row>
					<aui:button type="submit" value="Submit New Job"/>
				</aui:button-row>
			</aui:form>
		</aui:column>
		
		<aui:column columnWidth="50">
			<aui:form id="refresh" name="refresh">
				<aui:button-row >
					<aui:button style="float: right;" type="button" value="Refresh" onClick="location.href='https://flyback.cnaf.infn.it/dirac';"/>
				</aui:button-row>
			</aui:form>
		</aui:column>
		</aui:fieldset>
		
		<jsp:useBean id="jobs"
				type="java.util.List<it.italiangrid.portal.dirac.db.domain.Jobs>"
				scope="request" />
		<portlet:actionURL var="deleteMultipleJob">
			<portlet:param name="myaction" value="deleteMultipleJob"/>
		</portlet:actionURL>		
		<form name="delMultForm" action="${deleteMultipleJob}" method="POST">
			
			<div class="deleteButton" style="display: none;">
				<aui:button-row>
					<aui:button type="submit" value="Delete Selected Jobs"
						onClick="return confirm('Are you sure you want to delete these jobs?');" />
				</aui:button-row>
			</div>
			
			<liferay-ui:search-container
				emptyResultsMessage="No Jobs" delta="20">
				<liferay-ui:search-container-results>
	
					<%
						results = ListUtil.subList(jobs,
										searchContainer.getStart(),
										searchContainer.getEnd());
						total = jobs.size();
	
						pageContext.setAttribute("results", results);
						pageContext.setAttribute("total", total);
					%>
	
				</liferay-ui:search-container-results>
				<liferay-ui:search-container-row
					className="it.italiangrid.portal.dirac.db.domain.Jobs"
					keyProperty="jobId" modelVar="job">
					
					<liferay-ui:search-container-column-text name="Del">
						<input name="jobToDel" type="checkbox"
							value="${job.jobId }"
							onchange="viewOrHideDeleteButton('${job.jobId }');"></input>
					</liferay-ui:search-container-column-text>
					<liferay-ui:search-container-column-text name="Job ID"
						property="jobId" />
					<liferay-ui:search-container-column-text name="Name">
					<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>" var="getJdlURLonName">
								<portlet:param name="myaction" value="getJDL"/>
								<portlet:param name="jobId" value="${job.jobId }"/>
							</portlet:renderURL>
					<a href="#" onclick="$(this).modal3({width:600, height:450, message:true, src: '${getJdlURLonName}'}).open();">${job.jobName }</a>
					</liferay-ui:search-container-column-text>
					<liferay-ui:search-container-column-text name="Submission Time"
						property="submissionTime" />	
						
					<liferay-ui:search-container-column-text name="Status">
						<c:choose>
							<c:when test="${job.status == 'Failed' }">
								<div id="failedStatus" class="status"></div>
							</c:when>
							<c:when test="${job.status == 'Done' }">
								<div id="doneStatus" class="status"></div>
							</c:when>
							<c:when test="${job.status == 'Received' }">
								<div id="receivedStatus" class="status"></div>
							</c:when>
							<c:when test="${job.status == 'Waiting' }">
								<div id="waitingStatus" class="status"></div>
							</c:when>
							<c:when test="${job.status == 'Deleted' }">
								<div id="deletedStatus" class="status"></div>
							</c:when>
							<c:otherwise>
								<div id="runningStatus" class="status"></div>
							</c:otherwise>
						</c:choose>
						<div id="status value">${job.status }</div>
						<div id="reset"></div>
					</liferay-ui:search-container-column-text>
						
					<liferay-ui:search-container-column-text name="Actions">
					
						<liferay-ui:icon-menu>
							<c:if test="${job.status == 'Done' }">
								<portlet:resourceURL  var="outpuURL" escapeXml="false" id="getOutputZipFile">
									<portlet:param name="jobId" value="${job.jobId }"/>
								</portlet:resourceURL>
								<liferay-ui:icon image="download" message="GetOutput" url="${outpuURL}" />
							</c:if>
							
							<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>" var="getJdlURL">
								<portlet:param name="myaction" value="getJDL"/>
								<portlet:param name="jobId" value="${job.jobId }"/>
							</portlet:renderURL>
							<liferay-ui:icon image="history" message="JDL" url="javascript:$(this).modal3({width:600, height:450, message:true, src: '${getJdlURL}'}).open();" />
							
							<portlet:actionURL var="rescheduleURL">
								<portlet:param name="myaction" value="rescheduleJob"/>
								<portlet:param name="jobId" value="${job.jobId }"/>
							</portlet:actionURL>
							<liferay-ui:icon image="configuration" message="Reschedule" url="${rescheduleURL}" />
						
							<portlet:actionURL var="deleteURL">
								<portlet:param name="myaction" value="deleteJob"/>
								<portlet:param name="jobId" value="${job.jobId }"/>
							</portlet:actionURL>
							<liferay-ui:icon-delete url="${deleteURL}" />
						
						</liferay-ui:icon-menu>
					</liferay-ui:search-container-column-text>
					
				</liferay-ui:search-container-row>
				<liferay-ui:search-iterator />
			</liferay-ui:search-container>
			<div class="deleteButton" style="display: none;">
				<aui:button-row>
					<aui:button type="submit" value="Delete Selected Jobs"
						onClick="return confirm('Are you sure you want to delete these jobs?');" />
				</aui:button-row>
			</div>
		</form>
	</div>
</div>