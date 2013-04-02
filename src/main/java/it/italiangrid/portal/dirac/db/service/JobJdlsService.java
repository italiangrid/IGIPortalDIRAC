package it.italiangrid.portal.dirac.db.service;

import java.util.List;

import it.italiangrid.portal.dirac.db.domain.JobJdls;

public interface JobJdlsService {

	public void save(JobJdls transientInstance);

	public void delete(JobJdls persistentInstance);

	public JobJdls findById(Integer id);

	public List<JobJdls> getAllJobJdls();

}
