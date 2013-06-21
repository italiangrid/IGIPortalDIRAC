package it.italiangrid.portal.dirac.db.service;

import java.util.List;

import it.italiangrid.portal.dirac.db.domain.Proxies;
import it.italiangrid.portal.dirac.db.domain.ProxiesId;

public interface ProxiesService {

	public void save(Proxies transientInstance);

	public void delete(Proxies persistentInstance);

	public Proxies findById(ProxiesId id);

	public List<Proxies> getAllProxies();

}
