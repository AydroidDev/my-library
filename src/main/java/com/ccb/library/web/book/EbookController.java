package com.ccb.library.web.book;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.BookComment;
import com.ccb.library.service.book.BookService;


@Controller
@RequestMapping(value = "/ebook")
public class EbookController {
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
		return "book/ebookList";
	}
	
	
	@RequestMapping(value="upload",method = RequestMethod.GET)
	public String uploadForm() {
		return "book/ebookUpload";
	}
	
	@RequestMapping(value="download/{id}",method = RequestMethod.GET)
	public String download(@PathVariable("id") Long id) throws UnsupportedEncodingException {
		Book book = bookService.downloadEbook(id);
//		String encodeName = URLEncoder.encode(book.getName(), "UTF-8");
//		ModelAndView m = new ModelAndView(new RedirectView("/"+book.getUrl()+"/" + encodeName, true, true, false));
//		return m;
		return "redirect:/"+book.getUrl()+"/"+URLEncoder.encode(book.getName(), "UTF-8");
	}

	
	//书本评论，适用于ebook和real book
	@RequestMapping(value = "comment/{id}",method = RequestMethod.GET)
	@ResponseBody
	public List<BookComment> getComments(@PathVariable("id") Long id) {
		return bookService.getBookComments(id);
	}

	@RequestMapping(value = "comment/delete/{id}",method = RequestMethod.GET)
	@ResponseBody
	public boolean delComment(@PathVariable("id") Long id) {
		try {
			bookService.deleteBookComment(id);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	@RequestMapping(value = "comment/create",method = RequestMethod.POST)
	@ResponseBody
	public Long createComment(BookComment bookComment) {
		try {
			BookComment bc = bookService.newComment(bookComment);
			return bc.getId();
		} catch (Exception e) {
			return -1l;
		}
	}

}
