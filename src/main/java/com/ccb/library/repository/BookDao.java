package com.ccb.library.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.ccb.library.entity.Book;

public interface BookDao extends PagingAndSortingRepository<Book, Long>, JpaSpecificationExecutor<Book> {

	Page<Book> findByUserId(Long id, Pageable pageRequest);

	@Modifying
	@Query("update Book a set a.commentCount = a.commentCount+1 where a.id = ?1")
	public int increaseCommentCount(Long id);
	
	@Modifying
	@Query("update Book a set a.commentCount = a.commentCount-1 where a.id = ?1")
	public int  decreaseCommentCount(Long id);

	
	@Modifying
	@Query("update Book a set a.numInstock = a.numInstock-1 where a.id = ?1")
	public int decreaseNumInstock(Long id);

	@Modifying
	@Query("update Book a set a.numInstock = a.numInstock+1 where a.id = ?1")
	public int increaseNumInstock(Long id);

	
	@Modifying
	@Query("update Book a set a.borrowCount = a.borrowCount+1 where a.id = ?1")
	public int increaseborrowCount(Long id);

	
	@Modifying
	@Query("update Book a set a.downloadCount = a.downloadCount+1 where a.id = ?1")
	public int increasedownloadCount(Long id);
	
//	@Modifying
//	@Query("update Book a set a.numAll = a.numAll+?2, numInstock = a.numInstock+?2 where a.id = ?1")
//	public int increaseNum(Long id,int add);

	List<Book> findByName(String name);

	
	@Modifying
	@Query("update Book set name = ?2, numInstock =?3, numAll = ?4, author = ?5, press=?6, publicationDate=?7, contributor=?8 where id = ?1")
	void update(Long id, String name, Integer numInstock, Integer numAll, String author, String press, Date publicationDate, String contributor);

	List<Book> findByNameAndIsEbook(String name, byte b);
	
	@Modifying
	@Query("update Book set name = ?2 where id = ?1")
	void updateName(Long id, String name);
	

}
