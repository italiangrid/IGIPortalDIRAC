package it.italiangrid.portal.dirac.server;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;

import it.italiangrid.portal.dirac.util.DiracConfig;

import org.apache.log4j.Logger;

/**
 * This class get the list of VO supportated by our Dirac information, for each
 * VO associate the list of sites configured in Dirac that support the specified
 * VO.
 * 
 * @author dmichelotto
 * 
 */
public class VoListMatcher implements Runnable {

	/**
	 * The logger.
	 */
	private static final Logger log = Logger.getLogger(VoListMatcher.class);

	/**
	 * The thread that retrieve the VOs list, for each VO launch a bash script
	 * that join the Dirac sites whit the result of the command lcg-infosites
	 * that retrieve the sites tha support the VO.
	 */
	public void run() {

		try {
			log.info("Starting VO List Matcher Process.");
			DiracConfig diracConfig = new DiracConfig("Dirac.properties");
			
			String scriptName = diracConfig.getProperties("dirac.volistmatcher.script");
			log.info("Script name: " + scriptName);
			String voListString = diracConfig.getProperties("dirac.configuredVo");
			log.info(voListString);
			String[] voList = voListString.split(";");
			
			String diracDir = diracConfig.getProperties("dirac.admin.homedir");
			String resultFileName = diracConfig.getProperties("dirac.volistmatcher.list");
			File workingDir = new File(System.getProperty("java.io.tmpdir") + "/" + diracDir); 
			File resultFile = new File(System.getProperty("java.io.tmpdir") + "/" + diracDir + "/" + resultFileName);
			
			Properties resultData = new Properties();
			
			for (String vo : voList) {
				
				getList(scriptName, workingDir, resultData, vo);
			}
			
			saveList(resultFile, resultData);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return;
	}

	private void getList(String scriptName, File workingDir,
			Properties resultData, String vo) throws IOException {
		String siteList = "ANY;";	
		
		String cmd = "sh " +scriptName + " " + vo;
		log.info("Execute command: " + cmd + " on path: " + workingDir.getAbsolutePath()); 
		
		Process p = Runtime.getRuntime().exec(cmd, null, workingDir);
		InputStream stdout = p.getInputStream();
		InputStream stderr = p.getErrorStream();

		BufferedReader output = new BufferedReader(
				new InputStreamReader(stdout));
		String line = null;

		while (((line = output.readLine()) != null)) {
			if(line.equals("IGI-BOLOGNA")){
				siteList+="IGI-BOLOGNA-SL5;IGI-BOLOGNA-SL6;";
			}else{
				siteList+=line+";";
			}
		}
		output.close();

		BufferedReader brCleanUp = new BufferedReader(new InputStreamReader(
				stderr));
		while ((line = brCleanUp.readLine()) != null) {

			log.error("[Stderr] " + line);
		}

		brCleanUp.close();
		if(!siteList.isEmpty()){
			siteList = siteList.substring(0, siteList.length()-1);
		}
		log.info("Add list for VO: " + vo + " list: " + siteList);
		
		resultData.put(vo, siteList);
	}

	private void saveList(File resultFile, Properties resultData)
			throws FileNotFoundException, IOException {
		resultFile.delete();
		FileOutputStream fos = new FileOutputStream(resultFile);
		resultData.store(fos, null);
		fos.close();
	}

}
