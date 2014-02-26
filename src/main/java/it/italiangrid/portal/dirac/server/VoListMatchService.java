package it.italiangrid.portal.dirac.server;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

/**
 * Launch a separate thread that create lists of association between VO and Dirac Sites.
 * 
 * @author dmichelotto
 *
 */
public class VoListMatchService implements ServletContextListener {
	
	/**
	 * Class logger.
	 */
	private static final Logger log = Logger
			.getLogger(VoListMatchService.class);
	
	/**
	 * The executor for the thread management.
	 */
	private ScheduledExecutorService scheduler  = Executors.newSingleThreadScheduledExecutor();

	/**
	 * Kill the Vo List Matcher thread.
	 */
	public void contextDestroyed(ServletContextEvent arg0) {
		
		log.info("Kill the Vo List Matcher Service.");
		
		scheduler.shutdownNow();
	}

	/**
	 * Launch the Vo List Matcher thread.
	 */
	public void contextInitialized(ServletContextEvent arg0) {
		
		log.info("Start the Vo List Matcher Service.");
		
		scheduler.scheduleAtFixedRate(new VoListMatcher(), 0, 1, TimeUnit.HOURS);
		
	}

}
