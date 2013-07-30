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
	
	function setAll(element){
		var val = element.attr('checked');
		if(val == "checked"){
			$(".deleteCheckbox").attr('checked', true);
			$(".deleteButton").show("slow");
		}else{
			$(".deleteCheckbox").attr('checked', false);
			$(".deleteButton").hide("slow");
		}
		
	}
	
	$(document).ready(function() {
		
		if(${isAllJobsTerminate}==false){
			setTimeout(function(){
				location.href='https://flyback.cnaf.infn.it/dirac';
		    }, 20000);
		}
	});
	
	
</script>

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
		
		<liferay-portlet:renderURL var="homeUrl">
			<portlet:param name="myaction" value="showHome" />
		</liferay-portlet:renderURL>
		
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
					
					<liferay-ui:search-container-column-text name="Del <input type='checkbox' onclick='setAll($(this));'/>">
						<input class="deleteCheckbox" name="jobToDel" type="checkbox"
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
					<a href="#" onclick="$(this).modal3({width:600, height:450, message:true, redirect:'${homeUrl}', src: '${getJdlURLonName}'}).open();">${job.jobName }</a>
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
							<liferay-ui:icon image="history" message="JDL" url="javascript:$(this).modal3({width:600, height:450, message:true, redirect:'${homeUrl}', src: '${getJdlURL}'}).open();" />
							
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