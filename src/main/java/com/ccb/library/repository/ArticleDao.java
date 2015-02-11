package com.ccb.library.repository;

import java.util.Date;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.ccb.library.entity.Article;
import com.ccb.library.entity.IdEntity;

public interface ArticleDao extends PagingAndSortingRepository<Article, Long>, JpaSpecificationExecutor<Article> {

	Page<Article> findByUserId(Long id, Pageable pageRequest);
	Article findByCatalogId(Long catalogId);

	@Modifying
	@Query("update Article a set a.commentCount = a.commentCount+1 where a.id = ?1")
	public int increaseCommentCount(Long id);

	@Modifying
	@Query("update Article a set a.commentCount = a.commentCount-1 where a.id = ?1")
	public int decreaseCommentCount(Long id);

	@Modifying
	@Query("update Article a set a.viewCount = a.viewCount+1 where a.id = ?1")
	public int increaseViewCount(Long id);
	
	@Modifying
	@Query("delete from Article a where a.user.id=?1")
	public void deleteByUserId(Long id);

	@Modifying
	@Query("update Article set title=?1 ,catalog.id=?2 ,content=?3 ,modifyTime=?4 where id=?5")
	void update(String title, Long catalogId, String content, Date modifyTime,Long articleId);

}
