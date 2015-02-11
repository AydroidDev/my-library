package com.ccb.library.web.book;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.Book;
import com.ccb.library.entity.BookBorrow;
import com.ccb.library.service.ServiceException;
import com.ccb.library.service.book.BookService;


@Controller
@RequestMapping(value = "/admin/book")
public class BookAdminController {
	@Autowired
	private BookService bookService;
	private static final int BOOK_PAGE_SIZE = 30;

	//article
	@RequestMapping(method = RequestMethod.GET)
	public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Book> bookList = bookService.getAllBooks(false,searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookList", bookList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/adminBookList";
	}
	
	
	
//	@RequestMapping(value="new",method = RequestMethod.GET)
//	public String newBookForm() {
//		return "book/adminNewBookForm";
//	}
	
	@RequestMapping(value="new",method = RequestMethod.POST)
	public String newBook(@Valid Book book, RedirectAttributes redirectAttributes) {
		
		bookService.newBook(false,book);
		redirectAttributes.addFlashAttribute("message", "添加新书《"+book.getName()+"》成功");
		return "redirect:/admin/book";
	}
	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
		Book book = bookService.getBookById(id);
		if(book!=null){
			bookService.deleteRealBook(id);
			redirectAttributes.addFlashAttribute("message", "删除书《" + book.getName() + "》成功");
		}else{
			redirectAttributes.addFlashAttribute("message", "删除书失败，该书已被其他人删除");
		}
		return "redirect:/admin/book";
	}
	
	@RequestMapping(value="update",method = RequestMethod.POST)
	public String updateBook(@Valid Book book, RedirectAttributes redirectAttributes) {
		
		bookService.updateBook(false,book);
		redirectAttributes.addFlashAttribute("message", "更新 《"+book.getName()+"》库存成功");
		return "redirect:/admin/book";
	}
	
	@RequestMapping(value="borrow",method = RequestMethod.GET)
	public String availableBookList(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<Book> bookList = bookService.getAvailableBooks(searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookList", bookList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/adminBookBorrow";
	}
	
	@RequestMapping(value="borrow",method = RequestMethod.POST)
	public String borrowBook(@Valid BookBorrow bookBorrow, RedirectAttributes redirectAttributes) {
		try {
			Book book = bookService.borrowBook(bookBorrow);
			redirectAttributes.addFlashAttribute("message", "\""+bookBorrow.getUser().getName()+"\"借阅《"+book.getName()+"》成功");
			
		} catch (ServiceException e) {
			redirectAttributes.addFlashAttribute("message", e.getMessage());
		}
		return "redirect:/admin/book/borrow";
		
	}
	
	@RequestMapping(value="return",method = RequestMethod.GET)
	public String bookBorrowingList(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) throws BindException {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<BookBorrow> bookBorrowList = bookService.getbookBorrowingList(searchParams, pageNumber, BOOK_PAGE_SIZE, sortType);
		model.addAttribute("bookBorrowList", bookBorrowList);
		model.addAttribute("sortType", sortType);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "book/adminBookReturn";
	}
	
	@RequestMapping(value="return",method = RequestMethod.POST)
	public String returnBook(@Valid BookBorrow bookBorrow, RedirectAttributes redirectAttributes) {
		bookService.returnBook(bookBorrow);
		redirectAttributes.addFlashAttribute("message", "\""+bookBorrow.getUser().getName()+"\"归还《"+bookBorrow.getBook().getName()+"》成功");
		return "redirect:/admin/book/return";
		
	}
	
}
