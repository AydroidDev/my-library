package com.ccb.library.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotBlank;
import org.hibernate.validator.constraints.URL;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "comment")
public class Comment extends IdEntity {
	private String content;
	private Date createTime;
	private String author;
	private String email;
	private String url;
	private Long replyCommentId;
	private String replyCommentContent;
	private String replyAuthor;
	private String replyAuthorEmail;
	private String replyAuthorUrl;
	private String status;
	private Article article;
	private User user;

	public Comment() {
	}

	@NotBlank
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+08:00")
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	@Email
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@URL
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Long getReplyCommentId() {
		return replyCommentId;
	}

	public void setReplyCommentId(Long replyCommentId) {
		this.replyCommentId = replyCommentId;
	}

	public String getReplyCommentContent() {
		return replyCommentContent;
	}

	public void setReplyCommentContent(String replyCommentContent) {
		this.replyCommentContent = replyCommentContent;
	}

	public String getReplyAuthor() {
		return replyAuthor;
	}

	public void setReplyAuthor(String replyAuthor) {
		this.replyAuthor = replyAuthor;
	}

	@Email
	public String getReplyAuthorEmail() {
		return replyAuthorEmail;
	}

	public void setReplyAuthorEmail(String replyAuthorEmail) {
		this.replyAuthorEmail = replyAuthorEmail;
	}

	@URL
	public String getReplyAuthorUrl() {
		return replyAuthorUrl;
	}

	public void setReplyAuthorUrl(String replyAuthorUrl) {
		this.replyAuthorUrl = replyAuthorUrl;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	@JsonIgnore
	@ManyToOne
	@JoinColumn(name = "article_id")
	public Article getArticle() {
		return article;
	}

	public void setArticle(Article article) {
		this.article = article;
	}
	
	@ManyToOne
	@JoinColumn(name = "user_id")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}
