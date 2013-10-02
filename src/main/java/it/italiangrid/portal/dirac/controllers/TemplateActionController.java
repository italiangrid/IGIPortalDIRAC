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

@Controller("templateActionController")
@RequestMapping(value = "VIEW")
public class TemplateActionController {
	
	private static final Logger log = Logger.getLogger(TemplateActionController.class);

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
			
			response.setRenderParameter("myaction", "showSubmitJob");
			response.setRenderParameter("viewTemplate", "true");
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
