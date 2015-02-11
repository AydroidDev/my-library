package com.ccb.library.repository;

import java.util.List;

import javax.persistence.NamedNativeQuery;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.ccb.library.entity.Comment;

public interface CommentDao extends PagingAndSortingRepository<Comment, Long> {

	List<Comment> findByArticle_User_Id(Long id, PageRequest pageRequest);

	
	@Query("select c from Comment c where c.article.user.id = ?1")
	List<Comment> findByArticle_User_Id(Long id);

	List<Comment> findByUserId(Long userId);
	
	@Modifying
	@Query("delete from Comment c where c.article.id = ?1")
	void deleteByArticle_Id(Long id);

//	@Query(value = "delete c from comment as c left join article a on c.article_id=a.id where a.user_id=?1 or c.user_id=?1", nativeQuery = true)
	@Modifying
	@Query("delete from Comment c where c.article in (from Article as a where a.user.id = ?1) or c.user.id=?1")
	void deleteUser(Long id);

}
