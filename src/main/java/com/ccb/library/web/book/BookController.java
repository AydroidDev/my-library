package com.ccb.library.web.book;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.BookBorrow;
import com.ccb.library.service.ServiceException;
import com.ccb.library.service.book.BookService;


@Controller
@RequestMapping(value = "/book")
public class BookController {
	@Autowired
	private BookService bookService;
	private static final int BOOK_PAGE_SIZE = 20;
	
	
	@RequestMapping(value="home",method = RequestMethod.GET)
	public String home(){
		return "book/home";
	}
	@RequestMapping(value="home1",method = RequestMethod.GET)
	public String home1(){
		return "book/home1";
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Book> bookList = bookService.getAllBooks(false,searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookList", bookList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/bookList";
	}
	
	
	@RequestMapping(value="history",method = RequestMethod.GET)
	public String bookBorrowHistory(@RequestParam(value = "sortType", defaultValue = "BORROWDATE") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<BookBorrow> bookHistoryList = bookService.getbookHistoryList(searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookHistoryList", bookHistoryList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/bookBorrowHistory";
	}

	@RequestMapping(value="history/{id}",method = RequestMethod.GET)
	@ResponseBody
	public List<BookBorrow> bookBorrowHistoryByBookId(@PathVariable Long id,@RequestParam(value = "sortType", defaultValue = "BORROWDATE") String sortType) throws BindException{
		List<BookBorrow> bookHistoryList = bookService.getbookHistoryList(id,sortType);
		return bookHistoryList;
	}

	@RequestMapping(value="new",method = RequestMethod.POST)
	public String donateBook(@Valid Book book, RedirectAttributes redirectAttributes) {
		
		bookService.donateBook(book);
		redirectAttributes.addFlashAttribute("message", "捐书《"+book.getName()+"》成功");
		return "redirect:/book";
	}
	@RequestMapping(value="borrow",method = RequestMethod.POST)
	public String borrowBook(@Valid BookBorrow bookBorrow, RedirectAttributes redirectAttributes) {
		try {
			Book book = bookService.borrowBookByUser(bookBorrow);
			redirectAttributes.addFlashAttribute("message", "您借阅《"+book.getName()+"》成功");
			
		} catch (ServiceException e) {
			redirectAttributes.addFlashAttribute("message", e.getMessage());
		}
		return "redirect:/book";
		
	}
	@RequestMapping(value="return",method = RequestMethod.POST)
	public String returnBook(@Valid BookBorrow bookBorrow, RedirectAttributes redirectAttributes) {
		bookService.returnBookByUser(bookBorrow);
		redirectAttributes.addFlashAttribute("message", "归还《"+bookBorrow.getBook().getName()+"》成功");
		return "redirect:/console/about-me";
		
	}
	
	@RequestMapping(value = "shouldReturnBooks",method = RequestMethod.GET)
	@ResponseBody
	public List<BookBorrow> shouldReturnBooks() {
		return bookService.getShouldReturnBooks();
	}
	@RequestMapping(value = "latestBook",method = RequestMethod.GET)
	@ResponseBody
	public List<Book> latestBook() {
		return bookService.getRealBookTop5(BookService.SortType.ID).getContent();
	}
}
