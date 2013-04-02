package it.italiangrid.portal.dirac.controllers;

import java.util.List;

import javax.portlet.RenderRequest;

import it.italiangrid.portal.dbapi.domain.UserInfo;
import it.italiangrid.portal.dbapi.services.CertificateService;
import it.italiangrid.portal.dbapi.services.UserInfoService;
import it.italiangrid.portal.dirac.admin.DiracAdminUtil;
import it.italiangrid.portal.dirac.db.domain.Jobs;
import it.italiangrid.portal.dirac.db.service.JobsService;
import it.italiangrid.portal.dirac.exception.DiracException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

/**
 * Home controller for present the portlet first page and prepare the user
 * session for dirac job submission.
 * 
 * @author dmichelotto
 * 
 */

@Controller("diracHomeController")
@RequestMapping(value = "VIEW")
public class HomeController {
	/**
	 * Logger
	 */
	private static final Logger log = Logger.getLogger(HomeController.class);
	
	/**
	 * Jobs Service
	 */
	@Autowired
	private JobsService jobService;
	
	@Autowired
	private UserInfoService userInfoService;
	
	@Autowired
	private CertificateService certificateService;
	
	/**
	 * Display the home page.
	 * 
	 * @return Return the portlet home page.
	 */
	@RenderMapping
	public String showHomePage(RenderRequest request){
		log.info("Display home page");
		
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				log.info("User logged in.....");
				UserInfo userInfo = userInfoService.findByMail(user.getEmailAddress());
				log.info(userInfo.getFirstName() + " " +userInfo.getLastName());
				DiracAdminUtil util = new DiracAdminUtil();
				if(!util.userExist(userInfo.getPersistentId())){
					if(util.addDiracUser(userInfo, certificateService))
						log.info("User added");
					else
						log.info("User not added");
				}else{
					log.info("User already added");
				}
			}
			
//			return "home";

		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		} catch (DiracException e) {
			e.printStackTrace();
		}
		
		return "home";
//		return "error";
	}
	
	@ModelAttribute("jobs")
	public List<Jobs> getJobs(RenderRequest request){
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				log.info("User logged in.....");
				UserInfo userInfo = userInfoService.findByMail(user.getEmailAddress());
				log.info(userInfo.getFirstName() + " " +userInfo.getLastName());
				
				return jobService.findByOwner(userInfo.getPersistentId());
			}
			
//			return "home";

		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		} 
		
		return null;
	}
}
