package com.ccb.library.web.article;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.apache.shiro.authz.UnauthenticatedException;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Article;
import com.ccb.library.entity.Comment;
import com.ccb.library.entity.User;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.article.ArticleService;
import com.google.common.collect.Maps;

/**
 * Blog管理的Controller, 使用Restful风格的Urls:
 * 
 * List page     : GET /blog/
 * Detail page     : GET /blog/article/detail/{id}
 * Create page   : GET /blog/article/create
 * Create action : POST /blog/article/create
 * Update page   : GET /blog/article/update/{id}
 * Update action : POST /blog/article/update
 * 
 * @author itpudge
 */
@Controller
@RequestMapping(value = "/article")
public class ArticleController {

	private static final int ARTICLE_PAGE_SIZE = 5;

	private static Map<String, String> sortTypes = Maps.newLinkedHashMap();
	static {
		sortTypes.put("auto", "自动");
		sortTypes.put("createTime", "时间");
	}
	@Autowired
	private ArticleService articleService;

	@RequestMapping(method = RequestMethod.GET)
	public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");

		Page<Article> articles = articleService.getAllArticles(searchParams, pageNumber, ARTICLE_PAGE_SIZE, sortType);
		if (articles.getTotalElements() != 0) {
			model.addAttribute("articles", articles);
		}
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "article/articleList";
	}

	@RequestMapping(value = "{userId}", method = RequestMethod.GET)
	public String ariticle(@PathVariable("userId") Long userId, @RequestParam(value = "sortType", defaultValue = "auto") String sortType,
			@RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model, ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Article> articles = articleService.getUserArticles(userId, searchParams, pageNumber, ARTICLE_PAGE_SIZE, sortType);
		if (articles.getTotalElements() != 0) {
			model.addAttribute("articles", articles);
		}
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "article/articleList";
	}

	@RequestMapping(value = "detail/{id}", method = RequestMethod.GET)
	public String detail(@PathVariable("id") Long id, Model model) {
		model.addAttribute("article", articleService.getArticleDetail(id));
		Page<Article> nextArticle = articleService.getNextAritcle(id);
		Page<Article> previousArticle = articleService.getPreviousArticle(id);
		if(!nextArticle.getContent().isEmpty()){
			model.addAttribute("nextArticleId", nextArticle.getContent().get(0).getId());
		}
		if(!previousArticle.getContent().isEmpty()){
			model.addAttribute("previousArticleId", previousArticle.getContent().get(0).getId());
		}
		return "article/articleSingle";
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "create", method = RequestMethod.GET)
	public String createForm(Model model) {
		model.addAttribute("article", new Article());
		model.addAttribute("allCatalog", articleService.getAllCatalogs());
		model.addAttribute("action", "create");
		return "article/articleForm";
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "create", method = RequestMethod.POST)
	public String create(@Valid Article newArticle, RedirectAttributes redirectAttributes) {
		User user = new User(ShiroUtils.getCurrentUserId());
		newArticle.setUser(user);
		long id = articleService.createArticle(newArticle);
		redirectAttributes.addFlashAttribute("message", "发表成功");
		return "redirect:/article/detail/" + id;
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Long id, Model model) {
		Article article = articleService.getArticleById(id);
		ShiroUtils.makeSureAuthorized(article.getUser().getId());
		model.addAttribute("article", article);
		model.addAttribute("allCatalog", articleService.getAllCatalogs());
		model.addAttribute("action", "update");
		return "article/articleForm";
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(@Valid Article article ,RedirectAttributes redirectAttributes) {
		Article oldArticle = articleService.getArticleById(article.getId());
		if(oldArticle==null){
			redirectAttributes.addFlashAttribute("message", "文章不存在");
			return "redirect:/article/detail/" + article.getId();
		}
		ShiroUtils.makeSureAuthorized(oldArticle.getUser().getId());
		articleService.updateArticle(oldArticle,article);
		redirectAttributes.addFlashAttribute("message", "修改成功");
		return "redirect:/article/detail/" + article.getId();
	}
	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "delete/{id}", method = RequestMethod.GET)
	public String articleDelete(@PathVariable("id") Long id, @RequestParam(value = "url", defaultValue = "/article") String url, RedirectAttributes redirectAttributes) {
		Article article = articleService.getArticleById(id);
		if (article == null) {
			redirectAttributes.addFlashAttribute("message", "错误:文章不存在");
			return "redirect:" + url;
		}
		ShiroUtils.makeSureAuthorized(article.getUser().getId());
		articleService.deleteArticle(article);
		redirectAttributes.addFlashAttribute("message", "删除文章成功");
		return "redirect:" + url;
	}

	@RequestMapping(value = "topArticle/latest")
	@ResponseBody
	public List<Article> topArticle() {
		return articleService.getArticleTop5().getContent();
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "comment/create", method = RequestMethod.POST)
	public String create(@Valid Comment newComment, RedirectAttributes redirectAttributes) {
		try {
			long userId = ShiroUtils.getCurrentUserId();
			User user = new User(userId);
			newComment.setUser(user);
		} catch (UnauthenticatedException e) {
		}
		articleService.saveComment(newComment);
		redirectAttributes.addFlashAttribute("message", "评论成功");
		return "redirect:/article/detail/" + newComment.getArticle().getId();
	}

	@RequiresRoles(value = { "admin", "user" }, logical = Logical.OR)
	@RequestMapping(value = "comment/delete/{id}", method = RequestMethod.GET)
	public String commentDelete(@PathVariable("id") Long id, @RequestParam(value = "url", defaultValue = "/console") String url, RedirectAttributes redirectAttributes) {
		Comment comment = articleService.getComment(id);
		if (comment == null) {
			redirectAttributes.addFlashAttribute("message", "所操作评论不存在");
			return "redirect:" + url;
		}
		if (!ShiroUtils.isAdmin()) {
			if(comment.getUser()==null){
				throw new UnauthenticatedException("非法操作，权限不足");
			}else{
				ShiroUtils.makeSureAuthorized(comment.getUser().getId());
			}
		}
		articleService.deleteComment(comment);
		redirectAttributes.addFlashAttribute("message", "删除评论成功");
		return "redirect:" + url;
	}

	
	
//	@RequestMapping(value = "catalog")
//	@ResponseBody
//	public List<Catalog> catalog() {
//		return blogService.getAllCatalogs();
//	}

	@ModelAttribute("preloadArticle")
	public Article getArticle(@RequestParam(value = "id", required = false) Long id) {
		if (id != null) {
			return articleService.getArticleById(id);
		}
		return null;
	}

	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.setDisallowedFields("user", "createTime", "postIp");
	}

}
