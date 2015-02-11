package com.ccb.library.web.book;

import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Article;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.User;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.book.BookService;
import com.ccb.library.web.Constant;


@Controller
@RequestMapping(value = "/admin/ebook")
public class EbookAdminController {
	@Autowired
	private BookService bookService;
	private static final int BOOK_PAGE_SIZE = 30;

	@RequestMapping(method = RequestMethod.GET)
	public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Book> bookList = bookService.getAllBooks(true,searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookList", bookList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/adminEbookList";
	}
	
	@RequestMapping(value="update",method = RequestMethod.POST)
	public String updateBook(@Valid Book book, RedirectAttributes redirectAttributes) {
		
		bookService.updateBook(true,book);
		redirectAttributes.addFlashAttribute("message", "更新 《"+book.getName()+"》成功");
		return "redirect:/admin/ebook";
	}


	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
		Book book = bookService.deleteEBookById(id);
		redirectAttributes.addFlashAttribute("message", "删除电子书《" + book.getName() + "》成功");
		return "redirect:/admin/ebook";
	}
}
