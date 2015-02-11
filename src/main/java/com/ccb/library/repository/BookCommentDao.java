package com.ccb.library.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.ccb.library.entity.BookComment;
import com.ccb.library.entity.Comment;

public interface BookCommentDao extends CrudRepository<BookComment, Long> {

//	List<BookComment> findByUserId(Long userId);
	
	List<BookComment> findByBookId(Long bookId);
	
	@Modifying
	@Query("delete from BookComment c where c.book.id = ?1")
	void deleteByBookId(Long bookId);
}
