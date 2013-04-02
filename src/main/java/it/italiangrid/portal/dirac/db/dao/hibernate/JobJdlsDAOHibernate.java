package it.italiangrid.portal.dirac.db.dao.hibernate;


import it.italiangrid.portal.dirac.db.dao.generic.JobJdlsDAO;
import it.italiangrid.portal.dirac.db.domain.JobJdls;
import org.springframework.stereotype.Repository;

@Repository
public class JobJdlsDAOHibernate extends GenericHibernateDAO<JobJdls, Integer> implements JobJdlsDAO {

}
