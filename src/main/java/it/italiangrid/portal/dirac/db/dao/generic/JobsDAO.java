package it.italiangrid.portal.dirac.db.dao.generic;

import java.util.List;

import it.italiangrid.portal.dirac.db.domain.Jobs;

public interface JobsDAO extends GenericDAO<Jobs, Long>{

	List<Jobs> findByOwner(String owner);

	List<Jobs> findByOwnerDN(String dn);

}
