package com.ccb.library.web;

import java.util.Map;

import com.google.common.collect.Maps;

public class Constant {
	public static final Map<String, String> allStatus = Maps.newHashMap();
	public static final Map<String, String> allRoles = Maps.newHashMap();
	public static final Map<String,String> allStyles = Maps.newHashMap();
	public static final Map<String,String> allDepartMent = Maps.newLinkedHashMap();
	public static String type = "blue";
	static {
		allStatus.put("enabled", "有效");
		allStatus.put("disabled", "无效");
		allRoles.put("admin", "管理员");
		allRoles.put("user", "用户");
		allStyles.put("blue", "蓝色");
		allStyles.put("green", "绿色");
		allStyles.put("brown", "棕色");
		allStyles.put("orange", "桔色");
		allStyles.put("pink", "粉色");
		allStyles.put("red", "红色");
		allDepartMent.put("开发三处","开发三处");
		allDepartMent.put("开发一处","开发一处");
		allDepartMent.put("开发二处","开发二处");
		allDepartMent.put("开发四处","开发四处");
		allDepartMent.put("技术管理处","技术管理处");
		allDepartMent.put("技术支持处","技术支持处");
		allDepartMent.put("项目管理处","项目管理处");
		allDepartMent.put("综合管理处","综合管理处");
	}

}
