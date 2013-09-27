package it.italiangrid.portal.dirac.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.portlet.RenderRequest;

import it.italiangrid.portal.dbapi.domain.Certificate;
import it.italiangrid.portal.dbapi.domain.UserInfo;
import it.italiangrid.portal.dbapi.services.CertificateService;
import it.italiangrid.portal.dbapi.services.UserInfoService;
import it.italiangrid.portal.dirac.db.domain.Jobs;
import it.italiangrid.portal.dirac.db.service.JobsService;
import it.italiangrid.portal.dirac.db.service.ProxiesService;
import it.italiangrid.portal.dirac.exception.DiracException;
import it.italiangrid.portal.dirac.util.DiracConfig;
import it.italiangrid.portal.dirac.util.TemplateList;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

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
	
	@Autowired
	private ProxiesService proxiesService;
	
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
				return "home";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "error";
	}
	
	/**
	 * Display the home page.
	 * 
	 * @return Return the portlet home page.
	 */
	@RenderMapping(params="myaction=showHome")
	public String showHomePage2(RenderRequest request){
		return showHomePage(request);
	}
	
	
	@ModelAttribute("jobs")
	public List<Jobs> getJobs(RenderRequest request){
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				log.info("User logged in.....");
				UserInfo userInfo = userInfoService.findByMail(user.getEmailAddress());
				log.info(userInfo.getFirstName() + " " +userInfo.getLastName());
				
				List<Certificate> certs = new ArrayList<Certificate>();
				
				certs = certificateService.findById(userInfo.getUserId());
				
				List<Jobs> jobs = new ArrayList<Jobs>();
				
				for (Certificate certificate : certs) {
					
					jobs.addAll(jobService.findByOwnerDN(certificate.getSubject()));
					
				}
				
				return jobs;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	@ModelAttribute("isAllJobsTerminate")
	public boolean getAllJobsStatus(RenderRequest request){
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				log.info("User logged in.....");
				UserInfo userInfo = userInfoService.findByMail(user.getEmailAddress());
				log.info(userInfo.getFirstName() + " " +userInfo.getLastName());
				
				List<Certificate> certs = new ArrayList<Certificate>();
				
				certs = certificateService.findById(userInfo.getUserId());
				
				List<Jobs> jobs = new ArrayList<Jobs>();
				
				for (Certificate certificate : certs) {
					
					jobs.addAll(jobService.findByOwnerDN(certificate.getSubject()));
					
				}
				
				for (Jobs job : jobs) {
					if(!job.getStatus().equals("Done")&&!job.getStatus().equals("Failed")&&!job.getStatus().equals("Deleted"))
						return false;
				}
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	@ModelAttribute("reloadPage")
	public String getReloadPage(){
		try {
			return DiracConfig.getProperties("Dirac.properties", "dirac.reload.page");
		} catch (DiracException e) {
			e.printStackTrace();
		}
		return "https://portal.italiangrid.it/job";
	}
	
	@ModelAttribute("templateList")
	public TemplateList getTemplates(RenderRequest request){
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return new TemplateList();	
	}
	
}
