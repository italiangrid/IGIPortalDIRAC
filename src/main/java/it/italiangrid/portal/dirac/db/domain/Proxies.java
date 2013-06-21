package it.italiangrid.portal.dirac.db.domain;

// Generated 21-giu-2013 14.56.05 by Hibernate Tools 3.4.0.CR1

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * ProxyDbProxies generated by hbm2java
 */
@Entity
@Table(name = "ProxyDB_Proxies", catalog = "ProxyDB")
public class Proxies implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3481823786957536457L;
	private ProxiesId id;
	private String userName;
	private byte[] pem;
	private String persistentFlag;
	private Date expirationTime;

	public Proxies() {
	}

	public Proxies(ProxiesId id, String userName,
			String persistentFlag) {
		this.id = id;
		this.userName = userName;
		this.persistentFlag = persistentFlag;
	}

	public Proxies(ProxiesId id, String userName, byte[] pem,
			String persistentFlag, Date expirationTime) {
		this.id = id;
		this.userName = userName;
		this.pem = pem;
		this.persistentFlag = persistentFlag;
		this.expirationTime = expirationTime;
	}

	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "userDn", column = @Column(name = "UserDN", nullable = false)),
			@AttributeOverride(name = "userGroup", column = @Column(name = "UserGroup", nullable = false)) })
	public ProxiesId getId() {
		return this.id;
	}

	public void setId(ProxiesId id) {
		this.id = id;
	}

	@Column(name = "UserName", nullable = false, length = 64)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "Pem")
	public byte[] getPem() {
		return this.pem;
	}

	public void setPem(byte[] pem) {
		this.pem = pem;
	}

	@Column(name = "PersistentFlag", nullable = false, length = 5)
	public String getPersistentFlag() {
		return this.persistentFlag;
	}

	public void setPersistentFlag(String persistentFlag) {
		this.persistentFlag = persistentFlag;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "ExpirationTime", length = 19)
	public Date getExpirationTime() {
		return this.expirationTime;
	}

	public void setExpirationTime(Date expirationTime) {
		this.expirationTime = expirationTime;
	}

}
