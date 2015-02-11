package com.ccb.library.web.error;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/error")
public class ErrorController {
	
	
	@RequestMapping(value = "{id}", method = RequestMethod.GET)
	public String redirectErrorPage(@PathVariable("id") Long id) {
		return "error/"+id;
	}
	
}
