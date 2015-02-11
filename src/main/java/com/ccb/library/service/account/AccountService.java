package com.ccb.library.service.account;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.ccb.library.core.persistence.DynamicSpecifications;
import com.ccb.library.core.persistence.SearchFilter;
import com.ccb.library.core.security.utils.Digests;
import com.ccb.library.core.utils.DateProvider;
import com.ccb.library.core.utils.Encodes;
import com.ccb.library.entity.User;
import com.ccb.library.repository.ArticleDao;
import com.ccb.library.repository.CommentDao;
import com.ccb.library.repository.UserDao;
import com.ccb.library.service.ServiceException;
import com.ccb.library.service.account.ShiroDbRealm.ShiroUser;

/**
 * 用户管理类.
 * 
 * @author calvin,itpudge
 */
// Spring Service Bean的标识.
@Component
@Transactional(readOnly = true)
public class AccountService {

	public static final String HASH_ALGORITHM = "SHA-1";
	public static final int HASH_INTERATIONS = 1024;
	private static final int SALT_SIZE = 8;

	private static Logger logger = LoggerFactory.getLogger(AccountService.class);

	private UserDao userDao;
	private CommentDao commentDao;
	private ArticleDao articleDao;
	
	private DateProvider dateProvider = DateProvider.DEFAULT;

	public Page<User> getAllUser(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) {
		PageRequest pageRequest = new PageRequest(pageNumber - 1, pageSize, new Sort(Direction.ASC, "loginName"));
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<User> spec = DynamicSpecifications.bySearchFilter(filters.values(), User.class);
		return userDao.findAll(spec, pageRequest);

	}
	
	public User getUser(Long id) {
		return userDao.findOne(id);
	}

	public Page<User> findHotUser() {
		PageRequest pageRequest = new PageRequest(0, 5, new Sort(Direction.DESC, "aum"));
		return userDao.findAll(pageRequest);
	}

	public User findUserByLoginName(String loginName) {
		return userDao.findByLoginName(loginName);
	}

	
	public User findUserByName(String name) {
		return userDao.findByName(name);
	}

	public String findDuplicateUser(User user) {
		User name = userDao.findDuplicateName(user.getId(), user.getName());
		if (name != null) {
			return "名字已存在";
		} else {
			return null;
		}
	}

	@Transactional(readOnly = false)
	public void registerUser(User user) {
		entryptPassword(user);
		user.setRoles("user");
		user.setStatus("disabled");//注册后需要审批
		userDao.save(user);
	}

	@Transactional(readOnly = false)
	public void updateUser(User user) {
		if (StringUtils.isNotBlank(user.getPlainPassword())) {
			entryptPassword(user);
		}
		userDao.save(user);
	}
	
	@Transactional(readOnly = false)
	public void updateUserPassword(User user) {
		if (StringUtils.isNotBlank(user.getPlainPassword())) {
			entryptPassword(user);
		}
		userDao.updatePassword(user.getId(),user.getPassword(),user.getSalt());
	}

	@Transactional(readOnly = false)
	public void deleteUser(Long id) {
		if (isSupervisor(id)) {
			logger.warn("操作员{}尝试删除超级管理员用户", getCurrentUserName());
			throw new ServiceException("不能删除超级管理员用户");
		}
		commentDao.deleteUser(id);
		articleDao.deleteByUserId(id);
		userDao.delete(id);
	}

	/**
	 * 判断是否超级管理员.
	 */
	private boolean isSupervisor(Long id) {
		return id == -1;
	}

	/**
	 * 取出Shiro中的当前用户LoginName.
	 */
	private String getCurrentUserName() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user.loginName;
	}

	/**
	 * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
	 */
	private void entryptPassword(User user) {
		byte[] salt = Digests.generateSalt(SALT_SIZE);
		user.setSalt(Encodes.encodeHex(salt));

		byte[] hashPassword = Digests.sha1(user.getPlainPassword().getBytes(), salt, HASH_INTERATIONS);
		user.setPassword(Encodes.encodeHex(hashPassword));
	}

	@Autowired
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	@Autowired
	public void setCommentDao(CommentDao commentDao) {
		this.commentDao = commentDao;
	}

	@Autowired
	public void setArticleDao(ArticleDao articleDao) {
		this.articleDao = articleDao;
	}

}
