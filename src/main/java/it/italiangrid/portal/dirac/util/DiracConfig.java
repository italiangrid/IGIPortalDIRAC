package it.italiangrid.portal.dirac.util;

import it.italiangrid.portal.dirac.exception.DiracException;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Logger;

public class DiracConfig {
	
	private static final Logger log = Logger.getLogger(DiracConfig.class);
	
	public static String getProperties(String file, String key) throws DiracException{
		String contextPath = DiracConfig.class.getClassLoader()
				.getResource("").getPath();
		File test = new File(contextPath + "/content/" + file);
		log.info("File: " + test.getAbsolutePath());
		if (test.exists()) {
			log.info("ESISTE!!");
			try {
				FileInputStream inStream = new FileInputStream(contextPath
						+ "/content/" + file);

				Properties prop = new Properties();

				prop.load(inStream);

				inStream.close();
				if (prop.getProperty(key) != null)
					return prop.getProperty(key);
				else
					throw new DiracException("properties-not-found");

			} catch (IOException e) {
				e.printStackTrace();
				throw new DiracException("properties-file-not-found");
			}
		}else{
			throw new DiracException("properties-file-not-found");
		}
	}

}
