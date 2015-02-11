package com.ccb.library.service.article;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

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
import org.springframework.validation.BindException;

import com.ccb.library.core.persistence.DynamicSpecifications;
import com.ccb.library.core.persistence.SearchFilter;
import com.ccb.library.core.persistence.SearchFilter.Operator;
import com.ccb.library.core.utils.DateProvider;
import com.ccb.library.core.utils.HtmlUtil;
import com.ccb.library.entity.Article;
import com.ccb.library.entity.Catalog;
import com.ccb.library.entity.Comment;
import com.ccb.library.repository.ArticleDao;
import com.ccb.library.repository.CatalogDao;
import com.ccb.library.repository.CommentDao;
import com.ccb.library.repository.UserDao;

@Component
@Transactional(readOnly = true)
public class ArticleService {

	private static Logger logger = LoggerFactory.getLogger(ArticleService.class);
	private ArticleDao articleDao;
	private CommentDao commentDao;
	private CatalogDao catalogDao;
	private UserDao userDao;
	private DateProvider dateProvider = DateProvider.DEFAULT;

	//article BUSINESS start
	public enum SortType {
		AUTO, ID, CREATETIME, VIEWCOUNT, COMMENTCOUNT
	}

	static class ArticleSpecifications {

		public static Specification<Article> articleGreateThanId(final Long id) {
			return new Specification<Article>() {
				@Override
				public Predicate toPredicate(Root<Article> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.greaterThan(root.<Long> get("id"), id);
				}
			};
		}

		public static Specification<Article> articleLessThanId(final Long id) {
			return new Specification<Article>() {
				@Override
				public Predicate toPredicate(Root<Article> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.lessThan(root.<Long> get("id"), id);
				}
			};
		}
	}

	@Transactional(readOnly = false)
	public long createArticle(Article entity) {
		Date now = dateProvider.getDate();
		entity.setCreateTime(now);
		entity.setModifyTime(now);
		String content = HtmlUtil.fixImageStyle(entity.getContent());
		String summary = HtmlUtil.toSummary(entity.getContent()) + "...";
		entity.setSummary(summary);
		if (entity.getCatalog() == null || entity.getCatalog().getId() == null) {
			entity.setCatalog(new Catalog(-1l));
		}
		entity.setContent(content);
		if(entity.getCatalog().getId()==-1l){
			userDao.increaseAum(entity.getUser().getId(),80l);
		}
		return articleDao.save(entity).getId();
	}

	public Article getArticleById(Long id) {
		return articleDao.findOne(id);
	}

	public Page<Article> getNextAritcle(Long id) {
		PageRequest pageRequest = new PageRequest(0, 1, new Sort(Direction.ASC, "id"));
		return articleDao.findAll(ArticleSpecifications.articleGreateThanId(id), pageRequest);
	}

	public Page<Article> getPreviousArticle(Long id) {
		PageRequest pageRequest = new PageRequest(0, 1, new Sort(Direction.DESC, "id"));
		return articleDao.findAll(ArticleSpecifications.articleLessThanId(id), pageRequest);
	}

	public Page<Article> getArticleTop5() {
		
		PageRequest pageRequest = new PageRequest(0, 5, new Sort(Direction.DESC,"modifyTime"));
		return articleDao.findAll(pageRequest);
	}

	@Transactional(readOnly = false)
	public Article getArticleDetail(Long id) {
		articleDao.increaseViewCount(id);
		return articleDao.findOne(id);
	}

	public List<Article> getAllArticles() {
		return (List<Article>) articleDao.findAll();
	}

	public Page<Article> getAllArticles(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Article> spec = buildSpecification(searchParams);

		return articleDao.findAll(spec, pageRequest);
	}

	public Page<Article> getUserArticles(Long userId, Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Article> spec = buildSpecification(userId, searchParams);

		return articleDao.findAll(spec, pageRequest);
	}

	@Transactional(readOnly = false)
	public void updateArticle(Article oldEntity, Article entity) {
		entity.setModifyTime(dateProvider.getDate());
		String content = HtmlUtil.fixImageStyle(entity.getContent());
		String summary = HtmlUtil.toSummary(entity.getContent()) + "...";
		entity.setSummary(summary);
		entity.setContent(content);
		if (oldEntity.getCatalog().getId() != entity.getCatalog().getId()) {
			if(entity.getCatalog().getId()==-1){
				userDao.increaseAum(oldEntity.getUser().getId(), 80l);
			}else if(oldEntity.getCatalog().getId()==-1) {
				userDao.decreaseAum(oldEntity.getUser().getId(), 80l);
			}
		}
		articleDao.update(entity.getTitle(),entity.getCatalog().getId(),entity.getContent(),entity.getModifyTime(),entity.getId());
	}

	@Transactional(readOnly = false)
	public void deleteArticle(Article entity) {
		userDao.decreaseAum(entity.getUser().getId(),80l);
		commentDao.deleteByArticle_Id(entity.getId());
		articleDao.delete(entity.getId());
	}

	//article BUSINESS end

	//comment BUSINESS start
	@Transactional(readOnly = false)
	public void saveComment(Comment entity) {
		entity.setStatus("published");
		entity.setCreateTime(dateProvider.getDate());
		commentDao.save(entity);
		articleDao.increaseCommentCount(entity.getArticle().getId());
	}

	public Page<Comment> getAllComments(int pageNumber, int pageSize, String sortType) throws BindException {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));
		return commentDao.findAll(pageRequest);
	}

	public List<Comment> getUserArticleComments(Long userId, int pageNumber, int pageSize, String sortType) throws BindException {
//		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));
		return (List<Comment>) commentDao.findByArticle_User_Id(userId);
	}

	public List<Comment> getUserComments(Long userId, int pageNumber, int pageSize, String sortType) throws BindException {
//		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));
		return (List<Comment>) commentDao.findByUserId(userId);
	}

	public Comment getComment(Long id) {
		return commentDao.findOne(id);
	}

	@Transactional(readOnly = false)
	public void deleteComment(Comment comment) {
		articleDao.decreaseCommentCount(comment.getArticle().getId());
		commentDao.delete(comment.getId());

	}

	//comment BUSINESS end

	
	//catalog business
	public List<Catalog> getAllCatalogs() {
		return (List<Catalog>) catalogDao.findAll();
	}


	/**
	 * 创建分页请求.
	 */
	private PageRequest buildPageRequest(int pageNumber, int pageSize, Direction direction, SortType sortType) {
		Sort sort = null;
		switch (sortType) {
		case CREATETIME:
			sort = new Sort(direction, "createTime");
			break;
		case VIEWCOUNT:
			sort = new Sort(direction, "viewCount");
			break;
		case COMMENTCOUNT:
			sort = new Sort(direction, "commentCount");
			break;
		case ID:
			sort = new Sort(direction, "id");
		default:
			sort = new Sort(direction, "id");
		}
		return new PageRequest(pageNumber - 1, pageSize, sort);
	}

	/**
	 * 创建动态查询条件组合.
	 */
	private Specification<Article> buildSpecification(Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<Article> spec = DynamicSpecifications.bySearchFilter(filters.values(), Article.class);
		return spec;
	}

	private Specification<Article> buildSpecification(Long userId, Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		filters.put("user.id", new SearchFilter("user.id", Operator.EQ, userId));
		Specification<Article> spec = DynamicSpecifications.bySearchFilter(filters.values(), Article.class);
		return spec;
	}

	private SortType buildSortType(String sortType) throws BindException {
		try {
			return SortType.valueOf(sortType.toUpperCase());
		} catch (java.lang.IllegalArgumentException e) {
			logger.error("输入类型不符合规定", e);
			throw new org.springframework.validation.BindException(sortType, "SortType");
		}
	}

	@Autowired
	public void setArticleDao(ArticleDao articleDao) {
		this.articleDao = articleDao;
	}

	@Autowired
	public void setCommentDao(CommentDao commentDao) {
		this.commentDao = commentDao;
	}


	@Autowired
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	
	@Autowired
	public void setCatalogDao(CatalogDao catalogDao) {
		this.catalogDao = catalogDao;
	}

}
