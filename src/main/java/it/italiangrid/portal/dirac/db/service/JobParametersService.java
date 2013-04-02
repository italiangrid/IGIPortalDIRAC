package it.italiangrid.portal.dirac.db.service;

import java.util.List;

import it.italiangrid.portal.dirac.db.domain.JobParameters;

public interface JobParametersService {

	public void save(JobParameters transientInstance);

	public void delete(JobParameters persistentInstance);

	public JobParameters findById(Integer id);

	public List<JobParameters> getAllJobParameters();

}
