package it.italiangrid.portal.dirac.admin;

import it.italiangrid.portal.dbapi.domain.UserInfo;
import it.italiangrid.portal.dbapi.services.CertificateService;
import it.italiangrid.portal.dirac.exception.DiracException;
import it.italiangrid.portal.dirac.util.DiracConfig;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;

public class DiracAdminUtil {
	
	private static final Logger log  = Logger.getLogger(DiracAdminUtil.class);
	
	public boolean userExist(String user) throws DiracException{
		
		log.info("Check if " + user + " is laready registered in DIRAC");
		boolean status = false;
		
		String cmd = "dirac-admin-list-users";
		
		log.info("Execute command: " + cmd);
		
		File path = new File(System.getProperty("java.io.tmpdir") + "/" + DiracConfig.getProperties("Dirac.properties", "dirac.admin.homedir"));
		
		try {
			Process p = Runtime.getRuntime().exec(cmd, null, path);
			InputStream stdout = p.getInputStream();
			InputStream stderr = p.getErrorStream();

			BufferedReader output = new BufferedReader(new InputStreamReader(
					stdout));
			String line = null;
			while (((line = output.readLine()) != null)) {

				log.info("[Stdout] " + line);
				
				if(!line.contains("All users registered:")){
					if(line.trim().equals(user)){
						status = true;
					}
				}
			}
			output.close();

			BufferedReader brCleanUp = new BufferedReader(
					new InputStreamReader(stderr));
			while ((line = brCleanUp.readLine()) != null) {

				log.error("[Stderr] " + line);
				status = false;
			}

			brCleanUp.close();
			
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("userExist-execution-error");
		}
		
		
		return status;
	}
	
	public boolean addDiracUser(UserInfo userInfo, CertificateService certificateService) throws DiracException{
		log.info("Adding user");
		
		boolean status = true;
		
		String dn = certificateService.findById(userInfo.getUserId()).get(0).getSubject();
		
		String[] cmd = {"dirac-admin-add-user", "-N", userInfo.getPersistentId(), "-D", dn, "-M", userInfo.getMail(), "-G", "user"};
		
		String logcmd = "";
		
		for(int i = 0; i < cmd.length; i++)
			logcmd += cmd[i] + " ";
		
		log.info("Execute command: " + logcmd);
		
		File path = new File(System.getProperty("java.io.tmpdir") + "/" + DiracConfig.getProperties("Dirac.properties", "dirac.admin.homedir"));
		
		try {
			Process p = Runtime.getRuntime().exec(cmd, null, path);
			InputStream stdout = p.getInputStream();
			InputStream stderr = p.getErrorStream();

			BufferedReader output = new BufferedReader(new InputStreamReader(
					stdout));
			String line = null;

			while (((line = output.readLine()) != null)) {

				log.info("[Stdout] " + line);
				status = false;

			}
			output.close();

			BufferedReader brCleanUp = new BufferedReader(
					new InputStreamReader(stderr));
			while ((line = brCleanUp.readLine()) != null) {

				log.error("[Stderr] " + line);
				status = false;
			}

			brCleanUp.close();
			
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("userAdd-execution-error");
		}
		
		
		return status;
	}

	public void submitJob(String userPath, String path, String jdlFilename) throws DiracException {
		log.info("Submitting job");
		String[] cmd = {"dirac-wms-job-submit", path+"/"+jdlFilename};
		
		String logcmd = "";
		
		for(int i = 0; i < cmd.length; i++)
			logcmd += cmd[i] + " ";
		
		
		File exePath = new File(userPath);
		log.info("Execution Path: " + userPath);
		log.info("Execute command: " + logcmd);
		
		try {
			execute(cmd, exePath);

		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("userAdd-execution-error");
		}
	}

	public void getOutputJob(String userPath, int jobId, String storePath) throws DiracException {
		
		File exeDir = new File(userPath);
		
		String[] cmd = {"dirac-wms-job-get-output", "-D", storePath, Integer.toString(jobId)};
		
		try {
			execute(cmd, exeDir);
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("error-retrieving-output");
		}
		
	}

	public void getRescheduleJob(String userPath, int jobId) throws DiracException {
File exeDir = new File(userPath);
		
		String[] cmd = {"dirac-wms-job-reschedule", Integer.toString(jobId)};
		
		try {
			execute(cmd, exeDir);
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("error-rescheduling-output");
		}
		
	}

	public void getDeleteJob(String userPath, int jobId) throws DiracException {
		File exeDir = new File(userPath);
		
		String[] cmd = {"dirac-wms-job-delete", Integer.toString(jobId)};
		
		try {
			execute(cmd, exeDir);
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("error-deleting-output");
		}
		
	}

	public void dowloadUserProxy(String path, String screenName, String group) throws DiracException {
		String[] cmd = {"dirac-admin-get-proxy", screenName, group, "--out", path + "/x509up"};
		
		String logcmd = "";
		
		for(int i = 0; i < cmd.length; i++)
			logcmd += cmd[i] + " ";
		
		log.info("Execute command: " + logcmd);
		
		File exeDir = new File(System.getProperty("java.io.tmpdir") + "/" + DiracConfig.getProperties("Dirac.properties", "dirac.admin.homedir"));
		
		try {
			boolean status = true;
			
			Process p  = Runtime.getRuntime().exec(cmd, null, exeDir);
			InputStream stdout = p.getInputStream();
			InputStream stderr = p.getErrorStream();

			BufferedReader output = new BufferedReader(new InputStreamReader(
					stdout));
			String line = null;

			while (((line = output.readLine()) != null)) {

				log.info("[Stdout] " + line);
				if(!line.contains("Proxy downloaded to"))
					status = false;

			}
			output.close();

			BufferedReader brCleanUp = new BufferedReader(
					new InputStreamReader(stderr));
			while ((line = brCleanUp.readLine()) != null) {

				log.error("[Stderr] " + line);
				status = false;
			}

			brCleanUp.close();
			
			if(!status)
				throw new DiracException("no-proxy-uploaded");
			
		} catch (IOException e) {
			e.printStackTrace();
			throw new DiracException("error-dowloading-proxy");
		}
		
	}
	
	private boolean execute(String[] cmd, File path) throws IOException{
		
		boolean status = true;
		
		Process p  = Runtime.getRuntime().exec(cmd, null, path);
		InputStream stdout = p.getInputStream();
		InputStream stderr = p.getErrorStream();

		BufferedReader output = new BufferedReader(new InputStreamReader(
				stdout));
		String line = null;

		while (((line = output.readLine()) != null)) {

			log.info("[Stdout] " + line);

		}
		output.close();

		BufferedReader brCleanUp = new BufferedReader(
				new InputStreamReader(stderr));
		while ((line = brCleanUp.readLine()) != null) {

			log.error("[Stderr] " + line);
			status = false;
		}

		brCleanUp.close();
		
		return status;
		
	}
}
