package com.ccb.library.web.article;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Article;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.BookBorrow;
import com.ccb.library.entity.Comment;
import com.ccb.library.entity.User;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.account.AccountService;
import com.ccb.library.service.account.ShiroDbRealm.ShiroUser;
import com.ccb.library.service.article.ArticleService;
import com.ccb.library.service.book.BookService;
import com.ccb.library.web.Constant;
import com.google.common.collect.Maps;

/**
 * 控制台的controller
 * Console Page				:GET /console/blog
 * ArticleList Page			:GET /console/blog/article
 * CatalogList Page			:GET /console/blog/catalog
 * CommentList Page			:GET /console/blog/comment
 * 
 * @author Itpudge
 *
 */
@Controller
@RequestMapping(value = "/console")
public class ConsoleController {
	@Autowired
	private ArticleService blogService;
	@Autowired
	private AccountService accountService;
	@Autowired
	private BookService bookService;

	private static final int ARTICLE_PAGE_SIZE = 10;
	private static final int COMMENT_PAGE_SIZE = 10;
	private static Map<String, String> sortTypes = Maps.newLinkedHashMap();
	static {
		sortTypes.put("auto", "自动");
		sortTypes.put("createTime", "时间");
	}

	@RequestMapping(value = "about", method = RequestMethod.GET)
	public String aboutMe(@RequestParam(value = "id", defaultValue = "") Long id,Model model) throws BindException {
		Long currentId = getCurrentUserId();
		if(id == null||id.longValue()==currentId.longValue()){
			User user = accountService.getUser(currentId);
			List<BookBorrow> bookBorrow = bookService.getbookBorrowingListByUserId(user.getId());
			List<Book> ebooks = bookService.getUserEbooks(user.getId(), 1, 20, "ID");
			model.addAttribute("user", user);
			model.addAttribute("bookBorrows", bookBorrow);
			model.addAttribute("ebooks", ebooks);
			model.addAttribute("allRoles", Constant.allRoles);
			return "account/aboutMe";
		}else{
			User user = accountService.getUser(id);
			List<BookBorrow> bookBorrow = bookService.getbookBorrowingListByUserId(user.getId());
			List<Book> ebooks = bookService.getUserEbooks(user.getId(), 1, 20, "ID");
			model.addAttribute("user", user);
			model.addAttribute("bookBorrows", bookBorrow);
			model.addAttribute("ebooks", ebooks);
			model.addAttribute("allRoles", Constant.allRoles);
			return "account/about";
		}
	}

	@RequestMapping(value = "profile", method = RequestMethod.GET)
	public String updateForm(Model model) {
		return "account/profile";
	}

	@RequestMapping(value = "profile", method = RequestMethod.POST)
	public String update(String plainPassword, RedirectAttributes redirectAttributes) {
		if(StringUtils.isNotEmpty(plainPassword)){
			User user = new User(getCurrentUserId());
			user.setPlainPassword(plainPassword);
			accountService.updateUserPassword(user);
			redirectAttributes.addFlashAttribute("message", "更新密码成功");
		}else{
			redirectAttributes.addFlashAttribute("message", "密码未更改");
		}
		return "redirect:/console/about-me";
	}
	@RequestMapping(value="userEbookList",method = RequestMethod.GET)
	public String userEbookList(Model model){
		return "redirect:/ebook?search_LIKE_user.id="+getCurrentUserId();
	}

	@RequestMapping(value = "", method = RequestMethod.GET)
	public String console(Model model) {
		return "console/console";
	}

	//article
	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "/article")
	public String ariticle(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Long userId = ShiroUtils.getCurrentUserId();
		Page<Article> articles = blogService.getUserArticles(userId, searchParams, pageNumber, ARTICLE_PAGE_SIZE, sortType);
		model.addAttribute("articles", articles);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "console/articleList";
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "/article/delete/{id}", method = RequestMethod.GET)
	public String articleDelete(@PathVariable("id") Long id, @RequestParam(value = "url", defaultValue = "/article") String url, RedirectAttributes redirectAttributes) {
		Article article = blogService.getArticleById(id);
		if (article == null) {
			redirectAttributes.addFlashAttribute("message", "错误:文章不存在");
			return "redirect:" + url;
		}
		ShiroUtils.makeSureAuthorized(article.getUser().getId());
		blogService.deleteArticle(article);
		redirectAttributes.addFlashAttribute("message", "删除文章成功");
		return "redirect:" + url;
	}

	//comment
	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "/article-comment", method = RequestMethod.GET)
	public String userArticleComments(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber,
			Model model) throws BindException {
		Long userId = ShiroUtils.getCurrentUserId();
		List<Comment> comments = blogService.getUserArticleComments(userId, pageNumber, COMMENT_PAGE_SIZE, sortType);
		model.addAttribute("comments", comments);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		model.addAttribute("url", "/console/blog/article-comment");
		return "console/commentList";
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "/publish-comment", method = RequestMethod.GET)
	public String userPublishComments(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber,
			Model model) throws BindException {
		Long userId = ShiroUtils.getCurrentUserId();
		List<Comment> comments = blogService.getUserComments(userId, pageNumber, COMMENT_PAGE_SIZE, sortType);
		model.addAttribute("comments", comments);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		model.addAttribute("url", "/console/blog/publish-comment");
		return "console/commentList";
	}

	/**
	 * 取出Shiro中的当前用户Id.
	 */
	private Long getCurrentUserId() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user.id;
	}

}
