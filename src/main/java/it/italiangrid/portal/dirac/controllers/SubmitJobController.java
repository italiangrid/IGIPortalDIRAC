package it.italiangrid.portal.dirac.controllers;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import it.italiangrid.portal.dirac.admin.DiracAdminUtil;
import it.italiangrid.portal.dirac.exception.DiracException;
import it.italiangrid.portal.dirac.model.Jdl;
import it.italiangrid.portal.dirac.util.DiracUtil;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

@Controller("diracSubmitJobController")
@RequestMapping(value = "VIEW")
public class SubmitJobController {
	/**
	 * Logger
	 */
	private static final Logger log = Logger.getLogger(SubmitJobController.class);
	
	/**
	 * Display the home page.
	 * 
	 * @return Return the portlet home page.
	 */
	@RenderMapping(params="myaction=showSubmitJob")
	public String showHomePage(){
		
		Jdl jdl = new Jdl();
		
		List<String> list = new ArrayList<String>();
		
		list.add(jdl.getStdOutput());
		list.add(jdl.getStdError());
		
		jdl.setOutputSandbox(list);
		
		log.info("Test JDL:\n" + jdl);
		return "submit";
	}
	
	@ModelAttribute("jdl")
	public Jdl newJob(){
		return new Jdl();
	}
	
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
		                
		                if(!fileName.isEmpty()){
		                
		                	tempFile = uploadRequest.getFile(parameter);
		                	
			                File destination = new File(path + "/" + fileName);
			                
			                FileUtil.copyFile(tempFile, destination);
			                
			                tempFile.delete();
			 
			                inputSandbox.add(path+"/"+fileName);
			             }
		            }else{
		            	 String value = uploadRequest.getParameter(parameter);
				            
				         log.info(parameter +" = "+value);
				         
				         
				         jdl.setParameter(parameter, value);
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
				 * Submit job
				 */
				
				DiracAdminUtil util = new DiracAdminUtil();
				util.submitJob(userPath, path, jdlFilename);
				
				/*
				 * Delete temp folder
				 */
				DiracUtil.delete(jdlFolder);
				
				
			}
			
			
			return;

		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		} catch (DiracException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.setRenderParameter("myaction", "showSubmitJob");
		request.setAttribute("jdl", jdl);
		
	}
}
