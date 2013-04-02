package it.italiangrid.portal.dirac.db.dao.hibernate;


import java.util.List;

import it.italiangrid.portal.dirac.db.dao.generic.JobsDAO;
import it.italiangrid.portal.dirac.db.domain.Jobs;

import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository
public class JobsDAOHibernate extends GenericHibernateDAO<Jobs, Integer> implements JobsDAO {

	public List<Jobs> findByOwner(String owner) {
		
		return findByCriteria(Restrictions.eq("owner", owner),
				Restrictions.sqlRestriction("1=1 ORDER BY jobId DESC"));
	}

}
