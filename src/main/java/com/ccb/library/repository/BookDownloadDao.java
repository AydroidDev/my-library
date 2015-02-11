package com.ccb.library.repository;

import org.springframework.data.repository.CrudRepository;

import com.ccb.library.entity.BookDownload;

public interface BookDownloadDao extends CrudRepository<BookDownload, Long> {

}
