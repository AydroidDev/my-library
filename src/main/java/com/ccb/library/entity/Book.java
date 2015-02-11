package com.ccb.library.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.hibernate.validator.constraints.NotBlank;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * @author itpudge
 *
 */
//JPA标识
@Entity
@Table(name = "books")
public class Book extends IdEntity {
	private String name;
	private String author;
	private String press;
	@DateTimeFormat(pattern="yyyy-MM")
	private Date publicationDate;
	private Integer numInstock;
	private Integer numAll;
	private String contributor;
	private Long borrowCount;
	private Long commentCount;
	private byte isEbook;;
	private User user;
	private String url;
	private Date uploadTime;
	private Long downloadCount;
	private String filePath;

	public Book() {
	}

	@NotBlank
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPress() {
		return press;
	}

	public void setPress(String press) {
		this.press = press;
	}
	
	
	public Date getPublicationDate() {
		return publicationDate;
	}

	public void setPublicationDate(Date publicationDate) {
		this.publicationDate = publicationDate;
	}


	public String getContributor() {
		return contributor;
	}

	public void setContributor(String contributor) {
		this.contributor = contributor;
	}

	public Long getBorrowCount() {
		return borrowCount;
	}

	public void setBorrowCount(Long borrowCount) {
		this.borrowCount = borrowCount;
	}


	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+08:00")
	public Date getUploadTime() {
		return uploadTime;
	}
	
	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}

	
	@ManyToOne
	@JoinColumn(name = "uploader_id")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	

	public byte getIsEbook() {
		return isEbook;
	}


	public void setIsEbook(byte isEbook) {
		this.isEbook = isEbook;
	}


	public Long getDownloadCount() {
		return downloadCount;
	}


	public void setDownloadCount(Long downloadCount) {
		this.downloadCount = downloadCount;
	}


	public String getAuthor() {
		return author;
	}


	public void setAuthor(String author) {
		this.author = author;
	}


	public Integer getNumInstock() {
		return numInstock;
	}


	public void setNumInstock(Integer numInstock) {
		this.numInstock = numInstock;
	}


	public Integer getNumAll() {
		return numAll;
	}


	public void setNumAll(Integer numAll) {
		this.numAll = numAll;
	}


	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	

	public Long getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Long commentCount) {
		this.commentCount = commentCount;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}
