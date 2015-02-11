package com.ccb.library.web.article;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ccb.library.web.Constant;

@Controller
@RequestMapping(value = "/admin")
public class AdminConsoleController {
	
	@RequestMapping(value={"","console"},method = RequestMethod.GET)
	public String console() {
		return "console/adminConsole";
	}
	@RequestMapping(value="global",method = RequestMethod.GET)
	public String globalSetForm(Model model) {
		model.addAttribute("style", Constant.type);
		model.addAttribute("allStyles", Constant.allStyles);
		return "console/adminGlobal";
	}
	
	@RequestMapping(value="global",method = RequestMethod.POST)
	public String globalSet(String style, RedirectAttributes redirectAttributes) {
		if(Constant.allStyles.containsKey(style)){
			Constant.type = style;
			redirectAttributes.addFlashAttribute("message", "更新风格为"+style+"成功");
		}else {
			redirectAttributes.addFlashAttribute("message", "不存在"+style+"风格");
		}
		
		return "redirect:/admin/console";
	}
}
