package com.ccb.library.repository;

import org.springframework.data.repository.CrudRepository;

import com.ccb.library.entity.Catalog;

public interface CatalogDao extends CrudRepository<Catalog, Long> {
}
