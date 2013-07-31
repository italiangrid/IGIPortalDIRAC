package it.italiangrid.portal.dirac.server;

import java.io.IOException;

import org.apache.log4j.Logger;

/**
 * This class run a separated thread for store on file the notification queue.
 * 
 * @author dmichelotto
 * 
 */
public class CheckerBackup implements Runnable {

	/**
	 * The logger
	 */
	private static final Logger log = Logger.getLogger(CheckerBackup.class);

	/**
	 * The thread that store the queue.
	 */
	public void run() {

		log.info("Starting storing the notification queue...");

		try {

			Checker.store();
			log.info("Queue stored on file.");

		} catch (IOException e) {

			log.info("Queue NOT stored on file.");
			e.printStackTrace();

		}

		return;

	}

}
