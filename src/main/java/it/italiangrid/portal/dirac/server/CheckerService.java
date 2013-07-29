package it.italiangrid.portal.dirac.server;

import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

/**
 * Launch a separate thread that check the job status.
 * 
 * @author dmichelotto
 *
 */
public class CheckerService implements ServletContextListener {
	
	/**
	 * Class logger.
	 */
	private static final Logger log = Logger
			.getLogger(CheckerService.class);
	
	/**
	 * The executor for the thread management.
	 */
	private ExecutorService executor;
	
	/**
	 * The scheduler for the thread backup.
	 */
	private ScheduledExecutorService scheduler;

	/**
	 * Kill the Checker thread.
	 */
	public void contextDestroyed(ServletContextEvent arg0) {
		
		log.info("Kill the Checker Service.");
		
		try {
			Checker.store();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		Checker.closeConnection();
		
		executor.shutdownNow();
	}

	/**
	 * Launch the Checker thread.
	 */
	public void contextInitialized(ServletContextEvent arg0) {
		
		log.info("Start the Checker Service.");
		
		executor = Executors.newSingleThreadExecutor();
		executor.execute(new Checker());
		
		log.info("Start the Checker Backup Service.");
		
		scheduler = Executors.newSingleThreadScheduledExecutor();
		scheduler.scheduleAtFixedRate(new CheckerBackup(), 0, 10, TimeUnit.MINUTES);
		
	}

}
