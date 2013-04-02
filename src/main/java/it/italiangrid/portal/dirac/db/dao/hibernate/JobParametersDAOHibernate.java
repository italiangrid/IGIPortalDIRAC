package it.italiangrid.portal.dirac.db.dao.hibernate;


import it.italiangrid.portal.dirac.db.dao.generic.JobParametersDAO;
import it.italiangrid.portal.dirac.db.domain.JobParameters;
import org.springframework.stereotype.Repository;

@Repository
public class JobParametersDAOHibernate extends GenericHibernateDAO<JobParameters, Integer> implements JobParametersDAO {

}
