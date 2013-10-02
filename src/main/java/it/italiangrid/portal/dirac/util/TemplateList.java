package it.italiangrid.portal.dirac.util;

import it.italiangrid.portal.dirac.exception.DiracException;
import it.italiangrid.portal.dirac.model.Template;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class TemplateList {

	private long user;
	private List<Template> templates;

	/**
	 * @param user
	 */
	public TemplateList(long user) {
		this.user = user;
		templates = new ArrayList<Template>();
	}

	/**
	 * 
	 */
	public TemplateList() {
		templates = new ArrayList<Template>();
	}

	/**
	 * @return the user
	 */
	public long getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(long user) {
		this.user = user;
	}
	
	/**
	 * @return the templates
	 */
	public List<Template> getTemplates() {
		return templates;
	}

	/**
	 * @param templates the templates to set
	 */
	public void setTemplates(List<Template> templates) {
		this.templates = templates;
	}
	
	public void load(){
	
		String diracHome;
		String templateHome;
		String tomcatTemp = System.getProperty("java.io.tmpdir");
		try {
			diracHome = DiracConfig.getProperties("Dirac.properties", "dirac.admin.homedir");
			templateHome = DiracConfig.getProperties("Dirac.properties", "dirac.template.home");
		} catch (DiracException e) {
			diracHome = "diracHome";
			templateHome = "Template";
			e.printStackTrace();
		}
		
		String userPath = tomcatTemp + "/users/" + this.user + "/DIRAC/" + templateHome;
		String sharedPath = tomcatTemp + "/" + diracHome + "/" + templateHome;
		
		scanFolder(userPath, "Private");
		scanFolder(sharedPath, "Shared");
		
	}

	private void scanFolder(String path, String type) {
		File folder = new File(path);
		
		if(folder.list()==null)
			return;
		
		List<File> jobNameList = new ArrayList<File>(Arrays.asList(folder.listFiles()));
		for (File templateFile : jobNameList) {
			String templatePath = templateFile.toString();
			String name = templatePath.substring(templatePath.lastIndexOf("/")+1,templatePath.length()).split("@")[0];
			String owner = templatePath.substring(templatePath.lastIndexOf("/")+1,templatePath.length()).split("@")[1];
			this.templates.add(new Template(name, owner, type, templateFile.getAbsolutePath()));
		}
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "TemplateList [user=" + user + ", templates=" + templates + "]";
	}
	
	
	
}
