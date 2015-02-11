package com.ccb.library.service.book;

import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.domain.Specifications;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindException;

import com.ccb.library.core.persistence.DynamicSpecifications;
import com.ccb.library.core.persistence.SearchFilter;
import com.ccb.library.core.persistence.SearchFilter.Operator;
import com.ccb.library.core.utils.DateProvider;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.BookBorrow;
import com.ccb.library.entity.BookComment;
import com.ccb.library.entity.BookDownload;
import com.ccb.library.entity.Excerpt;
import com.ccb.library.entity.User;
import com.ccb.library.repository.BookBorrowDao;
import com.ccb.library.repository.BookCommentDao;
import com.ccb.library.repository.BookDao;
import com.ccb.library.repository.BookDownloadDao;
import com.ccb.library.repository.ExcerptDao;
import com.ccb.library.repository.UserDao;
import com.ccb.library.service.ServiceException;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.account.ShiroDbRealm.ShiroUser;

@Component
@Transactional(readOnly = true)
public class BookService {

	private static Logger logger = LoggerFactory.getLogger(BookService.class);
	private BookDao bookDao;
	private UserDao userDao;
	private BookBorrowDao bookBorrowDao;
	private BookCommentDao bookCommentDao;
	private BookDownloadDao bookDownloadDao;
	private ExcerptDao excerptDao;
	private DateProvider dateProvider = DateProvider.DEFAULT;
	private final long BORROWLIMIT = 2;

	//book BUSINESS start
	public enum SortType {
		AUTO, ID,COMMENTCOUNT, NAME, PUBLICATIONDATE, BORROWCOUNT, DOWNLOADCOUNT, BORROWDATE, RETURNDATE
	}

	static class BookBorrowSpecs {
		public static Specification<BookBorrow> returnDateIsNull() {
			return new Specification<BookBorrow>() {
				@Override
				public Predicate toPredicate(Root<BookBorrow> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.isNull(root.<Date> get("returnDate"));
				}
			};
		}

		public static Specification<BookBorrow> userIdEq(final Long userId) {
			return new Specification<BookBorrow>() {
				@Override
				public Predicate toPredicate(Root<BookBorrow> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.equal(root.<User> get("user").<Long> get("id"), userId);
				}
			};
		}

	}

	static class BookSpecs {
		public static Specification<Book> userIdEq(final Long userId) {
			return new Specification<Book>() {
				@Override
				public Predicate toPredicate(Root<Book> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.equal(root.<User> get("user").<Long> get("id"), userId);
				}
			};
		}

		public static Specification<Book> isEbook(final Byte isEbook) {
			return new Specification<Book>() {
				@Override
				public Predicate toPredicate(Root<Book> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
					return cb.equal(root.<Byte> get("isEbook"), isEbook);
				}
			};
		}

	}

	@Transactional(readOnly = false)
	public long newBook(boolean isEbook, Book entity) {
		if (isEbook) {
			entity.setIsEbook((byte) 1);
			entity.setUser(new User(getCurrentUser().id));
			entity.setCommentCount(0l);
			entity.setDownloadCount(0l);
			userDao.increaseAum(entity.getUser().getId(), 15l);
		} else {
			entity.setIsEbook((byte) 0);
			entity.setNumInstock(entity.getNumAll());
			entity.setCommentCount(0l);
			entity.setBorrowCount(0l);
			if (StringUtils.isBlank(entity.getContributor())) {
				entity.setContributor("三处");
			}
		}
		return bookDao.save(entity).getId();
	}


	@Transactional(readOnly = false)
	public long donateBook(Book entity) {

		entity.setIsEbook((byte) 0);
		entity.setNumInstock(entity.getNumAll());
		entity.setBorrowCount(0l);
		entity.setCommentCount(0l);
		entity.setContributor(getCurrentUser().name);
		userDao.increaseAum(getCurrentUser().id, 50l);
		return bookDao.save(entity).getId();
	}

	@Transactional(readOnly = false)
	public void updateBook(boolean isEbook, Book entity) {
		if (isEbook) {
			Book book = bookDao.findOne(entity.getId());

			File f = new File(book.getFilePath() + "/" + book.getName());
			if (f.exists())
				if (!f.renameTo(new File(book.getFilePath() + "/" + entity.getName())))
					throw new ServiceException("修改书名失败，可能服务器上存在同名文件!");
			bookDao.updateName(entity.getId(), entity.getName());
		} else {
			bookDao.update(entity.getId(), entity.getName(), entity.getNumInstock(), entity.getNumAll(), entity.getAuthor(), entity.getPress(), entity.getPublicationDate(),
					entity.getContributor());
		}
	}

	@Transactional(readOnly = false)
	public Book borrowBook(BookBorrow bookBorrow) {
		Book book = bookDao.findOne(bookBorrow.getBook().getId());
		User user = userDao.findByLoginName(bookBorrow.getUser().getLoginName());
		if (book == null) {
			logger.warn("操作员" + getCurrentUserLoginName() + "尝试借不存的书book.id=" + bookBorrow.getBook().getId());
			throw new ServiceException("借书失败,该书不存在!");
		}
		if (book.getNumInstock() > 0) {
			bookDao.decreaseNumInstock(book.getId());
		} else {
			throw new ServiceException("借书失败,该书库存为0,可能已被抢走!");
		}
		if (user == null) {
			throw new ServiceException("借书失败,输入借书人不存在!");
		}
		bookDao.increaseborrowCount(book.getId());
		bookBorrow.setUser(user);
		bookBorrowDao.save(bookBorrow);
		return book;
	}

	@Transactional(readOnly = false)
	public Book borrowBookByUser(BookBorrow bookBorrow) {
		Book book = bookDao.findOne(bookBorrow.getBook().getId());
		if (book == null) {
			logger.warn("操作员" + getCurrentUserLoginName() + "尝试借不存的书book.id=" + bookBorrow.getBook().getId());
			throw new ServiceException("借书失败，该书不存在!");
		}
		if (book.getNumInstock() > 0) {
			bookDao.decreaseNumInstock(book.getId());
		} else {
			throw new ServiceException("借书失败，该书库存为0，可能已被抢走!");
		}
		Long currentUserId = getCurrentUser().getId();
		long count = bookBorrowDao.count(Specifications.where(BookBorrowSpecs.userIdEq(currentUserId)).and(BookBorrowSpecs.returnDateIsNull()));
		if (count >= BORROWLIMIT) {
			throw new ServiceException("借书失败，每人限借书 " + BORROWLIMIT + " 本，请将本书放回书架！");
		}
		bookDao.increaseborrowCount(book.getId());
		bookBorrow.setUser(new User(currentUserId));
		bookBorrow.setBorrowDate(dateProvider.getDate());
		bookBorrowDao.save(bookBorrow);
		return book;
	}

	@Transactional(readOnly = false)
	public void returnBook(BookBorrow entity) {
		BookBorrow b = bookBorrowDao.findOne(entity.getId());
		if (b.getReturnDate() == null) {
			bookBorrowDao.updateReturnDate(entity.getId(), entity.getReturnDate());
			bookDao.increaseNumInstock(entity.getBook().getId());
		} else {
			throw new ServiceException("还书失败：书已归还!");
		}
	}

	@Transactional(readOnly = false)
	public void returnBookByUser(BookBorrow entity) {
		BookBorrow b = bookBorrowDao.findOne(entity.getId());
		if (b == null) {
			throw new ServiceException("还书失败：您并未借过此书!");
		}
		if (b.getReturnDate() == null) {
			bookBorrowDao.updateReturnDate(entity.getId(), dateProvider.getDate());
			bookDao.increaseNumInstock(entity.getBook().getId());
		} else {
			throw new ServiceException("还书失败：该书已归还!");
		}
	}

	/**
	 * @param searchParams
	 * @param pageNumber
	 * @param pageSize
	 * @param sortType
	 * @return  在借书籍列表
	 * @throws BindException
	 */
	public Page<BookBorrow> getbookBorrowingList(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));
		Specification<BookBorrow> spec = buildBorrowBooksSpecification(searchParams);

		return bookBorrowDao.findAll(Specifications.where(spec).and(BookBorrowSpecs.returnDateIsNull()), pageRequest);
	}

	public List<BookBorrow> getbookBorrowingListByUserId(Long userId) {
		List<BookBorrow> bookList = bookBorrowDao.findAll(Specifications.where(BookBorrowSpecs.userIdEq(userId)).and(BookBorrowSpecs.returnDateIsNull()), new Sort(Direction.DESC,
				"id"));
		for (int i = 0; i < bookList.size(); i++) {
			BookBorrow book = bookList.get(i);
			if (book.getReturnDate() == null) {
				book.setShouldReturnDate(shouldReturnDate(book.getBorrowDate()));

			}
		}
		return bookList;
	}

	public List<BookBorrow> getShouldReturnBooks() {
		List<BookBorrow> bookBorrows = bookBorrowDao.findAll(Specifications.where(BookBorrowSpecs.returnDateIsNull()), new Sort(Direction.ASC, "borrowDate"));
		Iterator<BookBorrow> booksIterator = bookBorrows.iterator();
		while (booksIterator.hasNext()) {
			BookBorrow book = booksIterator.next();
			DateTime borrowDateTime = new DateTime(book.getBorrowDate());
			if (borrowDateTime.minusDays(3).plusMonths(1).isAfterNow()) {
				//未到期图书
				booksIterator.remove();
			} else if (borrowDateTime.plusMonths(1).isAfterNow()) {
				//快到期
				book.setShouldReturnDate(borrowDateTime.plusMonths(1).toDate());
			}
			//到期  shouldReturnDate 为空
		}
		return bookBorrows;
	}

	public Page<BookBorrow> getbookHistoryList(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));
		Specification<BookBorrow> spec = buildBorrowBooksSpecification(searchParams);
		Page<BookBorrow> page = bookBorrowDao.findAll(spec, pageRequest);
		List<BookBorrow> bookList = page.getContent();
		for (int i = 0; i < bookList.size(); i++) {
			BookBorrow book = bookList.get(i);
			if (book.getReturnDate() == null) {
				book.setShouldReturnDate(shouldReturnDate(book.getBorrowDate()));

			}
		}
		return page;
	}
	public List<BookBorrow> getbookHistoryList(Long bookId,String sortType) throws BindException {
		return bookBorrowDao.findByBookId(bookId,buildSort(Direction.DESC, buildSortType(sortType)));
	}
	private Date shouldReturnDate(Date borrowDate) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(borrowDate);
		cal.add(Calendar.MONTH, 1);
		return cal.getTime();
	}

	/**
	 * @return 可借书籍
	 * @throws BindException 
	 */
	public Page<Book> getAvailableBooks(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Book> spec = buildAvailableBooksSpecification(searchParams);

		return bookDao.findAll(spec, pageRequest);
	}

	public Book getBookById(Long id) {
		return bookDao.findOne(id);
	}

	public List<Book> getRealBookByName(String name) {
		return bookDao.findByNameAndIsEbook(name, (byte) 0);
	}

	public List<Book> getEbookByName(String name) {
		return bookDao.findByNameAndIsEbook(name, (byte) 1);
	}

	public Page<Book> getRealBookTop5(SortType sotType) {
		PageRequest pageRequest = buildPageRequest(1, 5, Direction.DESC, sotType);
		return bookDao.findAll(Specifications.where(BookSpecs.isEbook((byte) 0)), pageRequest);
	}

	public List<Book> getAllBooks() {
		return (List<Book>) bookDao.findAll();
	}

	public Page<Book> getAllBooks(Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Book> spec = buildSpecification(searchParams);

		return bookDao.findAll(spec, pageRequest);
	}

	public Page<Book> getAllBooks(Boolean isEbook, Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Book> spec = buildSpecification(isEbook, searchParams);

		return bookDao.findAll(spec, pageRequest);
	}

	public Page<Book> getUserEbooks(Long userId, Map<String, Object> searchParams, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		Specification<Book> spec = buildSpecification(userId, searchParams);

		return bookDao.findAll(spec, pageRequest);
	}

	public List<Book> getUserEbooks(Long userId, int pageNumber, int pageSize, String sortType) throws BindException {

		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, Direction.DESC, buildSortType(sortType));

		return bookDao.findAll(Specifications.where(BookSpecs.userIdEq(userId)), pageRequest).getContent();
	}

	@Transactional(readOnly = false)
	public void deleteRealBook(Long id) {
		bookCommentDao.deleteByBookId(id);
		bookDao.delete(id);
	}

	@Transactional(readOnly = false)
	public Book deleteEBookById(Long id) {
		Book book = bookDao.findOne(id);
		if (book != null && book.getIsEbook() == 1) {
			userDao.decreaseAum(book.getUser().getId(), 15l);
			bookCommentDao.deleteByBookId(id);
			bookDao.delete(id);
			File f = new File(book.getFilePath() + "/" + book.getName());
			if (f.exists())
				f.delete();
			return book;
		} else {
			throw new ServiceException("改电子书不存在，请刷新!");
		}
	}
	//book BUSINESS end

	//book comment start
	
	public List<BookComment> getBookComments(Long bookId) {
		return bookCommentDao.findByBookId(bookId);
	}
	@Transactional(readOnly = false)
	public BookComment newComment(BookComment bookComment) {
		bookComment.setUser(new User(getCurrentUser().getId()));
		bookComment.setCreateTime(dateProvider.getDate());
		bookDao.increaseCommentCount(bookComment.getBook().getId());
		return bookCommentDao.save(bookComment);
	}
	@Transactional(readOnly = false)
	public void deleteBookComment(Long bookCommentId){
		BookComment bc = bookCommentDao.findOne(bookCommentId);
		ShiroUtils.makeSureAuthorized(bc.getUser().getId());
		bookDao.decreaseCommentCount(bc.getBook().getId());
		bookCommentDao.delete(bc);
	}
	//book comment end
	
	//book download start
	@Transactional(readOnly = false)
	public Book downloadEbook(Long id) {
		Book book = bookDao.findOne(id);
		if (book == null) {
			throw new ServiceException("该书不存在!");
		}
		bookDao.increasedownloadCount(id);
		bookDownloadDao.save(new BookDownload(dateProvider.getDate(), book, new User(getCurrentUser().getId())));
		return book;
	}

	//book download end

	//excerpt start
	public Excerpt getRandomExcerpt(){
		return excerptDao.findRandomExcerpt();
	}

	/**
	 * 创建分页请求.
	 */
	private PageRequest buildPageRequest(int pageNumber, int pageSize, Direction direction, SortType sortType) {
		return new PageRequest(pageNumber - 1, pageSize, buildSort(direction,sortType));
	}
	
	private Sort buildSort(Direction direction,SortType sortType){
		Sort sort = null;
		switch (sortType) {
		case BORROWCOUNT:
			sort = new Sort(direction, "borrowCount");
			break;
		case COMMENTCOUNT:
			sort = new Sort(direction, "commentCount");
			break;
		case DOWNLOADCOUNT:
			sort = new Sort(direction, "downloadCount");
			break;
		case BORROWDATE:
			sort = new Sort(direction, "borrowDate");
			break;
		case PUBLICATIONDATE:
			sort = new Sort(direction, "publicationDate");
			break;
		case RETURNDATE:
			sort = new Sort(direction, "returnDate");
			break;
		case NAME:
			sort = new Sort(direction, "name");
			break;
		case ID:
			sort = new Sort(direction, "id");
		default:
			sort = new Sort(direction, "id");
		}
return sort;
	}

	/**
	 * 创建动态查询条件组合.
	 */
	private Specification<Book> buildSpecification(Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<Book> spec = DynamicSpecifications.bySearchFilter(filters.values(), Book.class);
		return spec;
	}

	private Specification<Book> buildSpecification(boolean isEbook, Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		if (isEbook) {
			filters.put("isEbook", new SearchFilter("isEbook", Operator.EQ, 1));
		} else {
			filters.put("isEbook", new SearchFilter("isEbook", Operator.EQ, 0));
		}
		Specification<Book> spec = DynamicSpecifications.bySearchFilter(filters.values(), Book.class);
		return spec;
	}

	private Specification<Book> buildAvailableBooksSpecification(Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		filters.put("isEbook", new SearchFilter("isEbook", Operator.EQ, 0));
		filters.put("numInstock", new SearchFilter("numInstock", Operator.GT, 0));
		Specification<Book> spec = DynamicSpecifications.bySearchFilter(filters.values(), Book.class);
		return spec;
	}

	private Specification<BookBorrow> buildBorrowBooksSpecification(Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<BookBorrow> spec = DynamicSpecifications.bySearchFilterWithOr(filters.values(), BookBorrow.class);
		return spec;
	}

	private Specification<Book> buildSpecification(Long userId, Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		filters.put("user.id", new SearchFilter("user.id", Operator.EQ, userId));
		Specification<Book> spec = DynamicSpecifications.bySearchFilter(filters.values(), Book.class);
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
	public void setBookDao(BookDao bookDao) {
		this.bookDao = bookDao;
	}

	@Autowired
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	@Autowired
	public void setBookBorrowDao(BookBorrowDao bookBorrowDao) {
		this.bookBorrowDao = bookBorrowDao;
	}

	@Autowired
	public void setBookCommentDao(BookCommentDao bookCommentDao) {
		this.bookCommentDao = bookCommentDao;
	}
	@Autowired
	public void setBookDownloadDao(BookDownloadDao bookDownloadDao){
		this.bookDownloadDao = bookDownloadDao;
	}

	@Autowired
	public void setExcerptDao(ExcerptDao excerptDao) {
		this.excerptDao = excerptDao;
	}


	/**
	 * 取出Shiro中的当前用户LoginName.
	 */
	private String getCurrentUserLoginName() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user.loginName;
	}

	private ShiroUser getCurrentUser() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user;
	}


}
