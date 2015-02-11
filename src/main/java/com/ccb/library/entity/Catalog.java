package com.ccb.library.entity;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.validator.constraints.NotBlank;

@Entity
@Table(name = "catalog")
public class Catalog extends IdEntity {
	private String name;

	public Catalog() {
	}

	public Catalog(Long id) {
		this.id=id;
	}

	@NotBlank
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


}
