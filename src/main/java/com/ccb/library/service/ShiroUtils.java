package com.ccb.library.service;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.UnauthenticatedException;

import com.ccb.library.service.account.ShiroDbRealm.ShiroUser;

public class ShiroUtils {

	/**
	 * 删除或更新前调用,只有当前用户是管理员或者是owner一直才能删除
	 * @param userId 文章的用户、评论的用户，站内信的用户，photo的用户
	 * @throws UnauthenticatedException
	 */
	public static void makeSureAuthorized(Long userId) throws UnauthenticatedException{
		long currentUserId = getCurrentUserId();
		if (currentUserId != -1 && currentUserId != userId) {
			throw new UnauthenticatedException("非法操作，权限不足");
		}
	}
	public static boolean isAdmin(){
		try{
			if(getCurrentUserId()==-1)
				return true;
		}catch(UnauthenticatedException e){
		}
		return false;
	}

	public static long getCurrentUserId() throws UnauthenticatedException{
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			throw new UnauthenticatedException("未认证，请登录");
		}
		return user.id;
	}

}
