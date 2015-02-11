package com.ccb.library.web.account;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ccb.library.entity.User;
import com.ccb.library.service.account.AccountService;

@Controller
@RequestMapping("/api/user")
public class UserApi {
	@Autowired
	private AccountService accountService;
	
	@ResponseBody
	@RequestMapping(value="hot",method = RequestMethod.GET)
	public List<User> hot(){
		return accountService.findHotUser().getContent();
	}
	/**
	 * Ajax请求校验loginName是否唯一。
	 */
	@RequestMapping(value = "checkLoginName")
	@ResponseBody
	public String checkLoginName(@RequestParam("loginName") String loginName) {
		if (accountService.findUserByLoginName(loginName) == null) {
			return "true";
		} else {
			return "false";
		}
	}
	
	
	@RequestMapping(value = "loginNameIsNotExist")
	@ResponseBody
	public String loginNameIsExist(@RequestParam("user.loginName") String loginName) {
		if (accountService.findUserByLoginName(loginName) == null) {
			return "false";
		} else {
			return "true";
		}
	}
	
	@RequestMapping(value = "checkName")
	@ResponseBody
	public String checkName(@RequestParam("name") String name) {
		if (accountService.findUserByName(name) == null) {
			return "true";
		} else {
			return "false";
		}
	}


}


