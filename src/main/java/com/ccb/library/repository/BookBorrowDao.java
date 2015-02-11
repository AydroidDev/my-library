package com.ccb.library.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.ccb.library.entity.BookBorrow;

public interface BookBorrowDao extends PagingAndSortingRepository<BookBorrow, Long>, JpaSpecificationExecutor<BookBorrow> {
	@Modifying
	@Query("update BookBorrow a set a.returnDate = ?2 where a.id = ?1")
	void updateReturnDate(Long id, Date returnDate);

	List<BookBorrow> findByBookId(Long bookId, Sort sortType);


}
