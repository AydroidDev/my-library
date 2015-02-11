package com.ccb.library.service.article;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.ccb.library.entity.Photo;
import com.ccb.library.repository.PhotoDao;

@Component
@Transactional(readOnly = true)
public class PhotoService {
	@Autowired
	private PhotoDao photoDao;

	@Transactional(readOnly = false)
	public void createPhoto(Photo entity) {
		photoDao.save(entity);
	}

	@Transactional(readOnly = false)
	public void deletePhoto(Long id) {
		photoDao.delete(id);
	}

}
