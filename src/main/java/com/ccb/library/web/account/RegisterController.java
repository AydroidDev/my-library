package com.ccb.library.web.account;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.entity.User;
import com.ccb.library.service.account.AccountService;
import com.ccb.library.web.Constant;

/**
 * 用户注册的Controller.
 * 
 * @author calvin,itpudge
 */
@Controller
@RequestMapping(value = "/register")
public class RegisterController {

	@Autowired
	private AccountService accountService;

	@RequestMapping(method = RequestMethod.GET)
	public String registerForm(Model model) {
		model.addAttribute("user",new User());
		model.addAttribute("allDepartment",Constant.allDepartMent);
		return "account/register";
	}

	@RequestMapping(method = RequestMethod.POST)
	public String register(@Valid User user, RedirectAttributes redirectAttributes) {
		accountService.registerUser(user);
		redirectAttributes.addFlashAttribute("username", user.getLoginName());
		redirectAttributes.addFlashAttribute("message", "注册成功,请登录");
		return "redirect:/login";
	}

}
