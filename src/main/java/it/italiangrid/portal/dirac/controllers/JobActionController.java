package it.italiangrid.portal.dirac.controllers;

import it.italiangrid.portal.dirac.admin.DiracAdminUtil;
import it.italiangrid.portal.dirac.exception.DiracException;
import javax.portlet.ActionRequest;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
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
				
			}
		} catch (PortalException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DiracException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

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
				
			}
		} catch (PortalException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DiracException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
}
