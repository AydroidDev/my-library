package com.ccb.library.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author itpudge
 *
 */
//JPA标识
@Entity
@Table(name = "book_download")
public class BookDownload  extends IdEntity{
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date downloadDate;
	
	private Book book;
	private User user;

	
	
	
	public BookDownload(Date downloadDate, Book book, User user) {
		this.downloadDate = downloadDate;
		this.book = book;
		this.user = user;
	}

	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+08:00")
	public Date getDownloadDate() {
		return downloadDate;
	}

	public void setDownloadDate(Date downloadDate) {
		this.downloadDate = downloadDate;
	}

	
	@ManyToOne
	@JoinColumn(name = "user_id")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@JsonIgnore
	@ManyToOne
	@JoinColumn(name = "book_id")
	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}
