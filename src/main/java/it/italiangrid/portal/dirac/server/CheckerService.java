package it.italiangrid.portal.dirac.server;

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
	 * Kill the Checker thread.
	 */
	public void contextDestroyed(ServletContextEvent arg0) {
		
		log.info("Kill the Checker Service.");
		
	}

	/**
	 * Launch the Checker thread.
	 */
	public void contextInitialized(ServletContextEvent arg0) {
		
		log.info("Start the Checker Service.");
		
	}

}
