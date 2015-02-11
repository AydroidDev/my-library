package com.ccb.library.repository;

import org.springframework.data.repository.CrudRepository;

import com.ccb.library.entity.Photo;

public interface PhotoDao extends CrudRepository<Photo, Long> {
}
