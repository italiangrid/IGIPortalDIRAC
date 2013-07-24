package it.italiangrid.portal.dirac.db.domain;

// Generated 21-giu-2013 14.56.05 by Hibernate Tools 3.4.0.CR1

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * ProxyDbProxiesId generated by hbm2java
 */
@Embeddable
public class ProxiesId implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3111438750447552250L;
	private String userDn;
	private String userGroup;

	public ProxiesId() {
	}

	public ProxiesId(String userDn, String userGroup) {
		this.userDn = userDn;
		this.userGroup = userGroup;
	}

	@Column(name = "UserDN", nullable = false)
	public String getUserDn() {
		return this.userDn;
	}

	public void setUserDn(String userDn) {
		this.userDn = userDn;
	}

	@Column(name = "UserGroup", nullable = false)
	public String getUserGroup() {
		return this.userGroup;
	}

	public void setUserGroup(String userGroup) {
		this.userGroup = userGroup;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ProxiesId))
			return false;
		ProxiesId castOther = (ProxiesId) other;

		return ((this.getUserDn() == castOther.getUserDn()) || (this
				.getUserDn() != null && castOther.getUserDn() != null && this
				.getUserDn().equals(castOther.getUserDn())))
				&& ((this.getUserGroup() == castOther.getUserGroup()) || (this
						.getUserGroup() != null
						&& castOther.getUserGroup() != null && this
						.getUserGroup().equals(castOther.getUserGroup())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getUserDn() == null ? 0 : this.getUserDn().hashCode());
		result = 37 * result
				+ (getUserGroup() == null ? 0 : this.getUserGroup().hashCode());
		return result;
	}

}