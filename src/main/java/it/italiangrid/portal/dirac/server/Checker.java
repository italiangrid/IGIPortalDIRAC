package it.italiangrid.portal.dirac.server;

import it.italiangrid.portal.dirac.exception.DiracException;
import it.italiangrid.portal.dirac.model.Notify;
import it.italiangrid.portal.dirac.util.DiracConfig;
import it.italiangrid.portal.dirac.util.SendMail;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * This class check the status of all the job submitted through the portal and
 * send a e-mail notification when the job terminate.
 * 
 * @author dmichelotto
 * 
 */
public class Checker implements Runnable{
	
	/**
	 * The logger.
	 */
	private static final Logger log = Logger.getLogger(Checker.class);

	/**
	 * Th enotification queue.
	 */
	private static List<Notify> queue = new ArrayList<Notify>();
	
	private static Connection conn = null;
	
	/**
	 * Method to backup on file the notification queue.
	 * 
	 * @throws IOException
	 * @throws DiracException 
	 */
	public static void store() throws IOException{
		log.info("Storing Checker queue ...\n"+queue.toString()); 
		
		File datFile;
		try {
			DiracConfig diracConfig = new DiracConfig("Dirac.properties");
			datFile = new File(System.getProperty("java.io.tmpdir") + "/" + diracConfig.getProperties("dirac.admin.homedir") + "/" + diracConfig.getProperties("dirac.checker.store"));
		} catch (DiracException e) {
			datFile = new File(System.getProperty("java.io.tmpdir") + "/diracAdmin/checker.dat");
		}
		
		log.info("Backup file: " + datFile.getAbsolutePath());
		
		if(datFile.exists())
			datFile.delete();
		
		FileOutputStream saveFile = new FileOutputStream(datFile);
		ObjectOutputStream save = new ObjectOutputStream(saveFile);
		
		save.writeObject(queue);
		
		save.close();
		
		log.info("Storing completed.");
	}
	
	/**
	 * Method to load queue from backup.
	 * 
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	@SuppressWarnings("unchecked")
	public static void load() throws IOException, ClassNotFoundException{
		log.info("Loading Checker queue ...");
		
		File datFile;
		try {
			DiracConfig diracConfig = new DiracConfig("Dirac.properties");
			datFile = new File(System.getProperty("java.io.tmpdir") + "/" + diracConfig.getProperties("dirac.admin.homedir") + "/" + diracConfig.getProperties("dirac.checker.store"));
		} catch (DiracException e) {
			datFile = new File(System.getProperty("java.io.tmpdir") + "/diracAdmin/checker.dat");
		}
			
		log.info("Backup file: " + datFile.getAbsolutePath());
		
		if(datFile.exists()){
		
			FileInputStream loadFile = new FileInputStream(datFile);
			ObjectInputStream load = new ObjectInputStream(loadFile);
			
			queue = (List<Notify>) load.readObject();
			
			load.close();
			
			log.info("Loading completed. " + queue.toString());
		}else{
			log.info("No data founded.");
		}
	}
	
	/**
	 * Method to add new notification task to the queue.
	 * @param notify
	 */
	public static void addNotify(Notify notify){
		log.info("Adding Task do DIRAC Queue");

		if (queue.add(notify)) {
			log.info("Task Successfully Added");
			try {
				store();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			log.error("Task Not Added ");
		}

		log.info(queue);
	}

	/**
	 * The scanner thread that check the jobs status, and if it is terminated send an notification e-mail to the user.
	 */
	public void run() {
		
		try {
			log.info("Starting Queue Scanner Process.");

			if (!queue.isEmpty()) {
				boolean isChanged = false;
				List<Notify> scanList = new ArrayList<Notify>(queue);
				for (Notify n : scanList) {
				
					log.info("Checking: " + n);
					
					boolean status = true;
					List<String> jobsStatus = new ArrayList<String>();
					for (long jobId : n.getJobs()) {
						
						String jobStatus = getStatus(jobId);
						
						if(!jobStatus.equals("Done") && !jobStatus.equals("Failed") && !jobStatus.equals("Deleted")){
							status=false;
							break;
						}else{
							jobsStatus.add(jobStatus);
						}
					}
					
					if(status){
						
						boolean isDeleted = true;
						
						for (String string : jobsStatus) {
							if(!string.equals("Deleted"))
								isDeleted = false;
						}
						
						if(!isDeleted){
							sendMail(n, jobsStatus);
						}
						queue.remove(n);
						isChanged = true;
					}
				
				}
				if(isChanged)
					store();
			} else {
				log.info("Empty List");
			}
		} catch (Exception e) {
			e.printStackTrace();
			closeConnection();
			return;
		}
		return;
	}
	
	/**
	 * Configure and sned the notification via email.
	 * 
	 * @param n - the notification instance.
	 * @param status - the status list.
	 * @throws DiracException
	 */
	private void sendMail(Notify n, List<String> status) throws DiracException {
		
		DiracConfig diracConfig = new DiracConfig("Dirac.properties");
		String from =  diracConfig.getProperties("igiportal.mail");
		String mailSubject = "";
		String mailContent = "";
		String jobIDs = "";
		String jobStatus = "";
		boolean isHtml = true;
		if(status.size()>1){
			
			mailSubject =  diracConfig.getProperties("dirac.checker.subject.multi");
			
			try {
				mailContent = readFile(diracConfig.getProperties("dirac.checker.mail.multi.template"));
			} catch (IOException e) {
				isHtml = false;
				mailContent = diracConfig.getProperties("dirac.checker.mail.multi");
			}
			
			
			
		}else{
		
			mailSubject =  diracConfig.getProperties("dirac.checker.subject.single");
			try {
				mailContent = readFile(diracConfig.getProperties("dirac.checker.mail.single.template"));
			} catch (IOException e) {
				isHtml = false;
				mailContent = diracConfig.getProperties("dirac.checker.mail.single");
			}
		
		}
		
		for (long id : n.getJobs()) {
			jobIDs += id + " ";
		}
		
		for (int i = 0; i<status.size(); i++){
			jobStatus += "\t" + n.getJobs().get(i) + "\t" + status.get(i) + "\n";
		}
		
		mailSubject = mailSubject.replace("##JOBIDS##", jobIDs);
		mailContent = mailContent.replace("##USER##", n.getUser());
		mailContent = mailContent.replace("##STATUS##", jobStatus);
		mailContent = mailContent.replace("##HOST##", diracConfig.getProperties("portal.home"));
		
		SendMail sm = new SendMail(from, n.getEmail(), mailSubject, mailContent, isHtml);
		sm.send();
		
	}
	
	/**
	 * Open the connection to the DIRAC Job DB using the configuration file.
	 * 
	 * @return The connection.
	 * @throws DiracException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	private Connection openConnetion() throws DiracException, InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException{
		DiracConfig diracConfig = new DiracConfig("../../spring.properties");
		String url = diracConfig.getProperties("app2.jdbc.url");
	    String driver = diracConfig.getProperties("app2.jdbc.driverClassName");
	    String userName = diracConfig.getProperties("app2.jdbc.username");
	    String password = diracConfig.getProperties("app2.jdbc.password");
	    
	    Class.forName(driver).newInstance();
	    log.debug("Connected to the database");
	    
	    return DriverManager.getConnection(url,userName,password);
	    
	}
	
	/**
	 * Query the DIRAC Job DB for retrieving the Job Status.
	 * 
	 * @param jobId - the job to get the information.
	 * @return the status.
	 * @throws SQLException
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws DiracException 
	 */
	private String getStatus(long jobId) throws SQLException, DiracException, InstantiationException, IllegalAccessException, ClassNotFoundException {
		
		if(conn==null||conn.isClosed())
			conn = openConnetion();
		
		Statement statement = conn.createStatement();
		
	    String status = ""; 
	    String query = "SELECT Status FROM Jobs WHERE JobID = \"" + jobId + "\"";
	    
	    ResultSet resultSet = statement.executeQuery(query);
	    
	    while (resultSet.next()) {
	    	status = resultSet.getString("Status");
	    }
	    
	    if(status.isEmpty())
	    	status = "Deleted"; 
	    
	    log.info("Result query: " + status);
	    
		return status;
	}
	
	/**
	 * Close the DIRAC Job DB connetion.
	 */
	public static void closeConnection(){
		try {
			if(conn!=null)
				if(!conn.isClosed())
					conn.close();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	}
	
	private String readFile(String fileName) throws IOException {
		log.info("Path mail: " + Checker.class.getClassLoader().getResource("").getPath() + fileName);
	    BufferedReader br = new BufferedReader(new FileReader(Checker.class.getClassLoader().getResource("").getPath() + fileName));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append("\n");
	            line = br.readLine();
	        }
	        return sb.toString();
	    } finally {
	        br.close();
	    }
	}

}
