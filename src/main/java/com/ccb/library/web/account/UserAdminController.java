package com.ccb.library.web.account;

import java.util.Map;

import javax.servlet.ServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.core.web.Servlets;
import com.ccb.library.entity.User;
import com.ccb.library.service.ShiroUtils;
import com.ccb.library.service.account.AccountService;
import com.ccb.library.web.Constant;

/**
 * 管理员管理用户的Controller.
 * 
 * @author calvin
 */
@Controller
@RequestMapping(value = "/admin/user")
public class UserAdminController {

	@Autowired
	private AccountService accountService;

//	@RequestMapping(method = RequestMethod.GET)
//	public String list(Model model) {
//		List<User> users = accountService.getAllUser();
//		model.addAttribute("users", users);
//		model.addAttribute("allStatus", Constant.allStatus);
//		model.addAttribute("allRoles", Constant.allRoles);
//		return "account/adminUserList";
//	}
	@RequestMapping(method = RequestMethod.GET)
	public String list(@RequestParam(value = "sortType", defaultValue = "auto") String sortType, @RequestParam(value = "page", defaultValue = "1") int pageNumber, Model model,
			ServletRequest request) {
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Page<User> users = accountService.getAllUser(searchParams, pageNumber, 30, sortType);
		model.addAttribute("users", users);
		model.addAttribute("sortType", sortType);
		model.addAttribute("allStatus", Constant.allStatus);
		model.addAttribute("allRoles", Constant.allRoles);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "account/adminUserList";
	}

	@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Long id, Model model) {
		model.addAttribute("user", accountService.getUser(id));
		model.addAttribute("allStatus", Constant.allStatus);
		model.addAttribute("allRoles", Constant.allRoles);
		model.addAttribute("allDepartment",Constant.allDepartMent);
		return "account/adminUserForm";
	}

	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(@Valid @ModelAttribute("preloadUser") User user, String roles, String status, RedirectAttributes redirectAttributes) {
		//进行手动绑定roles和status，默认管理员或管理员自己的角色和状态不能更改
		if (user.getId() != -1&&user.getId()!=ShiroUtils.getCurrentUserId()) {
			user.setRoles(roles);
			user.setStatus(status);
		}
		String message = accountService.findDuplicateUser(user);
		if(message!=null){
			redirectAttributes.addFlashAttribute("message", message);
			return "redirect:/admin/user/update/"+user.getId();
		}
		accountService.updateUser(user);
		redirectAttributes.addFlashAttribute("message", "更新用户" + user.getLoginName() + "成功");
		return "redirect:/admin/user";
	}

	@RequestMapping(value = "delete/{id}")
	public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
		if(ShiroUtils.getCurrentUserId()!=-1){
			redirectAttributes.addFlashAttribute("message", "你没有删除用户权限");
			return "redirect:/admin/user";
		}
		User user = accountService.getUser(id);
		accountService.deleteUser(id);
		redirectAttributes.addFlashAttribute("message", "删除用户" + user.getLoginName() + "成功");
		return "redirect:/admin/user";
	}

	/**
	 * 使用@ModelAttribute, 实现Struts2 Preparable二次部分绑定的效果,先根据form的id从数据库查出User对象,再把Form提交的内容绑定到该对象上。
	 * 因为仅update()方法的form中有id属性，因此本方法在该方法中执行.
	 */
	@ModelAttribute("preloadUser")
	public User getUser(@RequestParam(value = "id", required = false) Long id) {
		if (id != null) {
			return accountService.getUser(id);
		}
		return null;
	}

	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.setDisallowedFields("loginName", "roles", "status");
	}

}
