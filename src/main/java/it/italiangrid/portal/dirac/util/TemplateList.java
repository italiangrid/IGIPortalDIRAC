package it.italiangrid.portal.dirac.util;

import it.italiangrid.portal.dirac.model.Template;

import java.util.ArrayList;
import java.util.List;

public class TemplateList {

	private List<Template> templates;

	/**
	 * 
	 */
	public TemplateList() {
		templates = new ArrayList<Template>();
	}
	
	public boolean put(Template template){
		return templates.add(template);
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "TemplateList [templates=" + templates + "]";
	}
	
	
	
}
