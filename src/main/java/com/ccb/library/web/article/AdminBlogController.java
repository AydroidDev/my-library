package com.ccb.library.web.article;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

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
import com.ccb.library.entity.Catalog;
import com.ccb.library.entity.Comment;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.article.ArticleService;
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
@RequestMapping(value = "/admin/blog")
public class AdminBlogController {
	@Autowired
	private ArticleService blogService;
	private static final int ARTICLE_PAGE_SIZE = 10;
	private static final int COMMENT_PAGE_SIZE = 10;
	private static Map<String, String> sortTypes = Maps.newLinkedHashMap();
	static {
		sortTypes.put("auto", "自动");
		sortTypes.put("createTime", "时间");
	}

	//article
	@RequestMapping(value = "article")
	public String ariticle(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Article> articles = blogService.getAllArticles(searchParams, pageNumber, ARTICLE_PAGE_SIZE, sortType);
		model.addAttribute("articles", articles);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "console/adminArticleList";
	}
	@RequestMapping(value = "article/delete/{id}", method = RequestMethod.GET)
	public String articleDelete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
		Article aritcle = blogService.getArticleById(id);
		if(aritcle == null){
			redirectAttributes.addFlashAttribute("message", "错误:文章不存在");
			return "redirect:/admin/blog/article";
		}
		blogService.deleteArticle(aritcle);
		redirectAttributes.addFlashAttribute("message", "删除文章成功");
		return "redirect:/admin/blog/article";
	}

	//comment
	@RequestMapping(value = "comment", method = RequestMethod.GET)
	public String comments(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model) throws BindException {
		Page<Comment> comments = blogService.getAllComments(pageNumber, COMMENT_PAGE_SIZE, sortType);
		model.addAttribute("comments", comments);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		model.addAttribute("url", "/admin/blog/comment");
		return "console/adminCommentList";
	}

	
}
