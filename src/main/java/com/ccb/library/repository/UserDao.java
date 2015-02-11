package com.ccb.library.repository;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.ccb.library.entity.User;

public interface UserDao extends PagingAndSortingRepository<User, Long> ,JpaSpecificationExecutor<User> {
	User findByLoginName(String loginName);
	User findByName(String name);
	
	/**
	 * 上传电子书2分，捐书5分，发表书评8分
	 * @param id
	 * @param score
	 * @return
	 */
	@Modifying
	@Query("update User u set u.aum = aum+?2 where u.id =?1 " )
	int increaseAum(Long id,Long score);
	
	
	@Modifying
	@Query("update User u set u.aum = aum-?2 where u.id =?1 " )
	int decreaseAum(Long id,Long score);
	
	@Query("select u from User u where u.id!=?1 and u.name=?2 " )
	User findDuplicateName(Long id, String name);
	
	@Modifying
	@Query("update User u set u.password = ?2, u.salt = ?3 where u.id=?1" )
	void updatePassword(Long id, String password, String salt);

}
