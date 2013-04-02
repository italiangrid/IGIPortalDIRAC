<%@ include file="/WEB-INF/jsp/init.jsp"%>

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
	
		<portlet:renderURL var="submitUrl">
			<portlet:param name="myaction" value="showSubmitJob" />
		</portlet:renderURL>
		
		<aui:form action="${submitUrl }">
			<aui:button type="submit" value="Submit"/>
		</aui:form>
	
		<jsp:useBean id="jobs"
				type="java.util.List<it.italiangrid.portal.dirac.db.domain.Jobs>"
				scope="request" />
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
				<liferay-ui:search-container-column-text name="Job ID"
					property="jobId" />
				<liferay-ui:search-container-column-text name="Name"
					property="jobName" />
				<liferay-ui:search-container-column-text name="Status"
					property="status" />
					
				<liferay-ui:search-container-column-text name="Actions">
				
					<liferay-ui:icon-menu>
						<c:if test="${job.status == 'Done' }">
							<portlet:resourceURL  var="outpuURL" escapeXml="false" id="getOutputZipFile">
								<portlet:param name="jobId" value="${job.jobId }"/>
							</portlet:resourceURL>
							<liferay-ui:icon image="download" message="GetOutput" url="${outpuURL}" />
						</c:if>
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
	</div>
</div>