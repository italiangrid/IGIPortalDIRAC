package it.italiangrid.portal.dirac.db.service;

import java.util.List;

import it.italiangrid.portal.dirac.db.domain.Jobs;

public interface JobsService {

	public void save(Jobs transientInstance);

	public void delete(Jobs persistentInstance);

	public Jobs findById(Long id);

	public List<Jobs> getAllJobs();
	
	public List<Jobs> findByOwner(String owner);

}
