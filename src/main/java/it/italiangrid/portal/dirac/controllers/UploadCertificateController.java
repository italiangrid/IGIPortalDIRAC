package it.italiangrid.portal.dirac.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.security.cert.X509Certificate;
import java.util.Enumeration;
import java.util.UUID;

import it.italiangrid.portal.dirac.model.DiracTask;
import it.italiangrid.portal.dirac.model.UploadCertificate;
import it.italiangrid.portal.dirac.util.DiracTaskJSON;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.RenderRequest;

import org.apache.log4j.Logger;
import org.glite.security.util.DNHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

import eu.emi.security.authn.x509.X509Credential;
import eu.emi.security.authn.x509.impl.CertificateUtils;
import eu.emi.security.authn.x509.impl.CertificateUtils.Encoding;
import eu.emi.security.authn.x509.impl.KeystoreCredential;

@Controller("uploadCertificateController")
@RequestMapping(value = "VIEW")
public class UploadCertificateController {
	
	private static final Logger log = Logger.getLogger(UploadCertificateController.class);

	@RenderMapping(params = "myaction=showUploadCert")
	public String showUploadCert(RenderRequest request){
		log.info("Show Certificate Uploader");
		
		return "upload";

	}
	
	@ModelAttribute("uploadCert")
	public UploadCertificate newDiracTask(){
		return new UploadCertificate();
	}
	
	@ActionMapping(params="myaction=uploadCert")
	public void uplaodCert(@ModelAttribute UploadCertificate uploadCert, ActionRequest request, ActionResponse response){
		log.info("Uploading Certificate...");
		
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
			
				File tempFile;
				UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(request);
		        
				@SuppressWarnings("unchecked")
				Enumeration<String> paramEnum = uploadRequest.getParameterNames();
				
				while (paramEnum.hasMoreElements()){
					String parameter = paramEnum.nextElement();
					if(parameter.contains("certificate")){
						String fileName = uploadRequest.getFileName(parameter);
		                log.info(parameter +" = "+fileName);
		                
		                if(!fileName.isEmpty()){
		                	
		                	log.info("Uploading " + fileName);
		                
		                	tempFile = uploadRequest.getFile(parameter, true);
		                	
		                	log.info("temp file " + tempFile.getAbsolutePath());
		                	
			                File destination = new File("/upload_files/" + fileName);
			                
			                log.info("destination file " + destination.getAbsolutePath());
			                
			                FileUtil.copyFile(tempFile, destination);
			                
			                tempFile.delete();
			                
			                uploadCert.setCertificate(destination.getAbsolutePath());
			                
			             }
					}
					if(parameter.contains("password")){
						String value = uploadRequest.getParameter(parameter);
				          
//		            	log.info(parameter +" = "+value);
				        
		            	uploadCert.setPassword(value);
				        
					}
				}
				
				log.info(uploadCert);
				
				
				
				X509Credential chain = new KeystoreCredential(uploadCert.getCertificate(), uploadCert.getPassword().toCharArray(), uploadCert.getPassword().toCharArray(), null, "PKCS12");
				
				String uuid = UUID.randomUUID().toString();
				File userCert = new File("/upload_files/usercert_"+uuid+".pem");
				FileOutputStream usercertOS = new FileOutputStream(userCert);
				File userKey = new File("/upload_files/userkey_"+uuid+".pem");
				FileOutputStream userkeyOS = new FileOutputStream(userKey);
				
				CertificateUtils.saveCertificate(usercertOS, chain.getCertificate(), Encoding.PEM);
				CertificateUtils.savePrivateKey(userkeyOS, chain.getKey(), Encoding.PEM, "AES-256-CBC", uploadCert.getPassword().toCharArray(),true);
				
				DiracTask diracTask = new DiracTask(userCert.getAbsolutePath(), userKey.getAbsolutePath(), uploadCert.getPassword(), user.getEmailAddress(), DNHandler.getSubject(chain.getCertificate()).getX500(), user.getScreenName());
				
				DiracTaskJSON diracTaskJSON = new DiracTaskJSON(diracTask);
				
				log.info(diracTaskJSON.getEncodedDiracTask()); 
				
				FileUtil.delete(userCert);
				FileUtil.delete(userKey);
				FileUtil.delete(new File(uploadCert.getCertificate()));
				
				SessionMessages.add(request, "upload-successufully");
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		SessionErrors.add(request, "upload-error");
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);
		
		response.setRenderParameter("myaction", "showUploadCert");
		request.setAttribute("uploadCert", uploadCert);
		
	}

}
