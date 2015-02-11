package com.ccb.library.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ccb.library.entity.Book;
import com.ccb.library.entity.Excerpt;
import com.ccb.library.service.book.BookService;

@Controller
@RequestMapping("/api")
public class Api {
	@Autowired
	private BookService bookService;
	
	@ResponseBody
	@RequestMapping(value="book/hot",method = RequestMethod.GET)
	public List<Book> hot(){
		return bookService.getRealBookTop5(BookService.SortType.BORROWCOUNT).getContent();
	}
	
	/**
	 * @param name
	 * @return 实体书不存在返回true
	 */
	@RequestMapping(value = "book/checkName")
	@ResponseBody
	public String checkName(@RequestParam("name") String name) {
		List<Book> books = bookService.getRealBookByName(name);
		if ( books!= null&&books.size()!=0) {
			return "false";
		} else {
			return "true";
		}
	}
	
	@RequestMapping(value = "excerpt",method = RequestMethod.GET)
	@ResponseBody
	public Excerpt randomExcerpt(){
		return bookService.getRandomExcerpt();
	}


}


