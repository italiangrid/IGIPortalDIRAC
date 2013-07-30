package it.italiangrid.portal.dirac.controllers;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;

import it.italiangrid.portal.dirac.admin.DiracAdminUtil;
import it.italiangrid.portal.dirac.model.Jdl;
import it.italiangrid.portal.dirac.model.Notify;
import it.italiangrid.portal.dirac.server.Checker;
import it.italiangrid.portal.dirac.util.DiracUtil;
import it.italiangrid.portal.dirac.util.GuseNotify;
import it.italiangrid.portal.dirac.util.GuseNotifyUtil;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

@Controller("diracSubmitJobControllerAction")
@RequestMapping(value = "VIEW")
public class SubmitJobControllerAction {
	/**
	 * Logger
	 */
	private static final Logger log = Logger.getLogger(SubmitJobControllerAction.class);
	
	@ActionMapping(params="myaction=submitJob")
	public void submitJob(@ModelAttribute Jdl jdl, ActionRequest request, ActionResponse response){
		log.info("Submitting job");
		
		
		try {
			User user = PortalUtil.getUser(request);

			if (user != null) {
				
				/*
				 * Prepare temp folder for submission
				 */
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
				Calendar cal = new GregorianCalendar();
				Date now = cal.getTime();
				
				String userPath = System.getProperty("java.io.tmpdir") + "/users/"+user.getUserId();
				String tmpDir = "JDL_"+sdf.format(now);
				String path = userPath + "/DIRAC/jdls/"+tmpDir;
				
				File jdlFolder = new File(path);
				jdlFolder.mkdirs();
				
				/*
				 * Get inputSandbox and jdl parameters
				 */
				
				List<String> inputSandbox = new ArrayList<String>();
				UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(request);
		        File tempFile;
		        
		        @SuppressWarnings("unchecked")
				Enumeration<String> paramEnum = uploadRequest.getParameterNames();
		        while (paramEnum.hasMoreElements())
		        {
		        	
		            String parameter = paramEnum.nextElement();
		            
		           
		            
		            if (parameter.startsWith("uploadFile"))
		            {
		            	
		                
		                
		                String fileName = uploadRequest.getFileName(parameter);
		                log.info(parameter +" = "+fileName);
		                
		                if(!fileName.isEmpty()){
		                	
		                	log.info("Uploading " + fileName);
		                
		                	tempFile = uploadRequest.getFile(parameter, true);
		                	
		                	log.info("temp file " + tempFile.getAbsolutePath());
		                	
			                File destination = new File(path + "/" + fileName);
			                
			                log.info("destination file " + destination.getAbsolutePath());
			                
			                FileUtil.copyFile(tempFile, destination);
			                
			                tempFile.delete();
		                	
			                inputSandbox.add(path+"/"+fileName);
			                
			             }
		            }else{
		            	
		            	
		            	if(parameter.contains("executableFile")){
		            		 String fileName = uploadRequest.getFileName(parameter);
				                log.info(parameter +" = "+fileName);
				                
				                if(!fileName.isEmpty()){
				                	
				                	log.info("Uploading exe file: " + fileName);
				                
				                	tempFile = uploadRequest.getFile(parameter, true);
				                	
				                	log.info("temp file " + tempFile.getAbsolutePath());
				                	
					                File destination = new File(path + "/" + fileName);
					                
					                log.info("destination file " + destination.getAbsolutePath());
					                
					                FileUtil.copyFile(tempFile, destination);
					                
					                tempFile.delete();
				                	
					                inputSandbox.add(path+"/"+fileName);
					                jdl.setExecutable(fileName);
					                
					             }
		            	} else{
			            	String value = uploadRequest.getParameter(parameter);
					          
			            	log.info(parameter +" = "+value);
					        
					        jdl.setParameter(parameter, value);
		            	}
		            }
		        }
		        
		        List<String> outputSandbox = new ArrayList<String>();
				outputSandbox.add(jdl.getStdOutput());
				outputSandbox.add(jdl.getStdError());
				if(!jdl.getOutputSandboxRequest().isEmpty()){
					for(String s: jdl.getOutputSandboxRequest().split(";")){
						outputSandbox.add(s.replaceAll(" ", ""));
					}
				}
				jdl.setOutputSandbox(outputSandbox);
		        
		        if(!inputSandbox.isEmpty()){
		        	jdl.setInputSandbox(inputSandbox);
		        }
		 
		        log.info("Jdl:\n"+jdl);
		        
		        /*
				 * Save jdl on file
				 */
				
				String jdlFilename = jdl.getJobName()+".jdl";
				
				FileOutputStream jdlFile = new FileOutputStream(path + "/" + jdlFilename);
				jdlFile.write(jdl.toString().getBytes());
				jdlFile.close();
				
				/*
				 * Download proxy
				 */
				
				DiracAdminUtil util = new DiracAdminUtil();
				util.dowloadUserProxy(path, user.getScreenName(), jdl.getVo()+"_user");
				
				/*
				 * Submit job
				 */
				
				List<Long> ids = util.submitJob(path, path, jdlFilename);
				
				/*
				 * Adding notify task
				 */
				boolean isNotify = isNotificationSetted(user);
				
				log.info("notify = " + isNotify);
				if(isNotify){
					Notify notify = new Notify(user.getEmailAddress(), user.getFirstName(), ids);
					Checker.addNotify(notify);
				}
				
				/*
				 * Delete temp folder
				 */
				DiracUtil.delete(jdlFolder);
				
				
			}
			
			SessionMessages.add(request, "submit-successufully");
			
			return;

		} catch (Exception e) {
			
			if(e.getMessage().contains("no-proxy-uploaded")){
				
				SessionErrors.add(request, e.getMessage());
				PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
				SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);
				
				response.setRenderParameter("showUploadCert", "true");
				
//				response.setRenderParameter("myaction", "showUploadCert");
				
//				return;
			}else{
				if (e.getMessage().equals("submit-error")){
					SessionErrors.add(request, "check-jdl");
				}else{
					e.printStackTrace();
				}
			}
		}
		
		SessionErrors.add(request, "submit-error");
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(request, portletConfig.getPortletName() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);
		
		response.setRenderParameter("myaction", "showSubmitJob");
		request.setAttribute("jdl", jdl);
		
	}

	private boolean isNotificationSetted(User user) {
		GuseNotifyUtil gnu = new GuseNotifyUtil();
		GuseNotify gn = gnu.readNotifyXML(user);
		if(gn!=null){
			
			log.info("The notification configuration is: " + gn.getWfchgEnab());
			
			if(gn.getWfchgEnab().equals("true"))
				return true;
		}
		return false;
	}
}
