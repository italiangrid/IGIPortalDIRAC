package it.italiangrid.portal.dirac.controllers;

import java.io.File;

import it.italiangrid.portal.dirac.util.DiracUtil;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;

import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

@Controller("templateController")
@RequestMapping(value = "VIEW")
public class TemplateController {
	
	private static final Logger log = Logger.getLogger(TemplateController.class);

	@ActionMapping(params = "myaction=deleteTemplate")
	public void deleteTemplate(ActionRequest request, ActionResponse response){
		String path = request.getParameter("path");
		log.info("Deleting: " + path);
		
		long owner = Long.parseLong(path.split("@")[1]);
		
		
		try {
			User user = PortalUtil.getUser(request);

			if (user != null && user.getUserId()==owner) {
				
				DiracUtil.delete(new File(path));
				
				log.info("Template deleted");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@ActionMapping(params = "myaction=useTemplate")
	public void useTemplate(ActionRequest request, ActionResponse response){
		String path = request.getParameter("path");
		log.info("Use: " + path);
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				
//				String diracJdl = "";
				
//				DiracUtil.getTemplate(diracJdl, user.getUserId());
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
