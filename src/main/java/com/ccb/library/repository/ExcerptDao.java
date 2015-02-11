package com.ccb.library.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.ccb.library.entity.Excerpt;

public interface ExcerptDao extends CrudRepository<Excerpt, Long> {

	@Query(value = "select * from excerpt ORDER BY RAND() LIMIT 1", nativeQuery = true)
	Excerpt findRandomExcerpt();

}
