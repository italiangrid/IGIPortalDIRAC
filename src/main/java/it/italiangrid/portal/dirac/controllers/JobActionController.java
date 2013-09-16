package it.italiangrid.portal.dirac.controllers;

import java.io.File;
import java.io.IOException;

import it.italiangrid.portal.dirac.admin.DiracAdminUtil;
import it.italiangrid.portal.dirac.util.DiracUtil;

import javax.portlet.ActionRequest;
import javax.portlet.PortletConfig;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.bind.annotation.ActionMapping;

import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

@Controller("jobActionController")
@RequestMapping(value = "VIEW")
public class JobActionController {
	/**
	 * Logger
	 */
	private static final Logger log = Logger.getLogger(JobActionController.class);
	
	@ActionMapping(params = "myaction=rescheduleJob")
	public void getRescheduleJob(ActionRequest request){
		log.info("Reschedule job: " + request.getParameter("jobId"));
		
		try {
			User user = PortalUtil.getUser(request);
			if (user != null) {
				
				int jobId = Integer.parseInt(request.getParameter("jobId"));
				
				String userPath = System.getProperty("java.io.tmpdir") + "/users/"+user.getUserId();
				
				DiracAdminUtil util = new DiracAdminUtil();
				util.getRescheduleJob(userPath, jobId);
				
				SessionMessages.add(request, "resheduling-successufully");
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		SessionErrors.add(request, "rescheduling-error");
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

	}
	
	@ActionMapping(params = "myaction=deleteJob")
	public void getDeleteJob(ActionRequest request){
		log.info("Delete job: " + request.getParameter("jobId"));
		
		try {
			User user = PortalUtil.getUser(request);
			if (user != null) {
				
				int jobId = Integer.parseInt(request.getParameter("jobId"));
				
				String userPath = System.getProperty("java.io.tmpdir") + "/users/"+user.getUserId();
				
				DiracAdminUtil util = new DiracAdminUtil();
				util.getDeleteJob(userPath, jobId);
				
				SessionMessages.add(request, "deleting-successufully");
				return;
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		SessionErrors.add(request, "deleting-error");
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

	}
	
	@ActionMapping(params = "myaction=deleteMultipleJob")
	public void getDeleteMultipleJob(@RequestParam int[] jobToDel, ActionRequest request){
		
		
		try {
			User user = PortalUtil.getUser(request);
			if (user != null) {
				
				for(int jobId : jobToDel){
					log.info("Delete job: " + jobId);
					
					String userPath = System.getProperty("java.io.tmpdir") + "/users/"+user.getUserId();
					
					DiracAdminUtil util = new DiracAdminUtil();
					util.getDeleteJob(userPath, jobId);
				}
				
				SessionMessages.add(request, "deleting-successufully");
				return;
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		SessionErrors.add(request, "deleting-error");
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

	}
	
	@ActionMapping(params = "myaction=goHome")
	public void goHome(ActionRequest request){
		
		log.info(request.getParameter("settedPath"));
		
		if(!request.getParameter("settedPath").isEmpty()){
			File dir = new File(request.getParameter("settedPath"));
			
			if(dir.exists())
				try {
					DiracUtil.delete(dir);
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return;

	}
	
}
