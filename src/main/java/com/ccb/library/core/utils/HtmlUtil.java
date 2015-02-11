package com.ccb.library.core.utils;

import java.util.regex.Pattern;

public class HtmlUtil {

	private static final Pattern HTML_CHECKER = Pattern.compile("</[a-z][^>]*>|<[a-z][^/>]*/>");

	private static final Pattern FIX_IMG_STYLE = Pattern.compile("<img\\s*.*\\s*style=\\\"(float:.*?)\\\"\\s*.*>");

	private static final int SUMMARY_SIZE = 150;
	/**
	 * 生成摘要
	 * 
	 * @param html
	 * @return
	 */
	public static String toSummary(String source) {
		String html = source.replaceAll("\\s+", " ")
				.replaceAll("</td[^>]*>", " ")
				.replaceAll("</(br|li|tr|p|pre)[^>]*>", "\r")
				.replaceAll("<[^>]*>", "")
				.replaceAll(" +", " ")
				.replaceAll("(\\r )+", "\r")
				.replaceAll("\\r+", "<br>")
				.trim();
		if(html.isEmpty())
			return "";
		else if(html.length()>SUMMARY_SIZE){
			return html.substring(0, SUMMARY_SIZE);
		}else{
			return html;			
		}
	}

	/**
	 * 修正ueditor的图片style
	 * 
	 * @param html
	 * @return
	 */
	public static String fixImageStyle(String html) {
		html = html.replaceAll("(<img.*?)style=\"(.*?)float:(left|right);(.*?>)", "$1style=\"$2$4");
		return html;
	}

	public static boolean isHtml(String html) {
		return HTML_CHECKER.matcher(html).find();
	}

	public static void main(String args[]) {
		String testStr2 = "<img src=\"http://bs.baidu.com/uploadimg/71771362842432.jpg\" style=\"float:left;width:200px;height:133px;\" width=\"200\" height=\"133\" border=\"0\" hspace=\"0\" vspace=\"0\" />";
		String testStr3 = "<p> 欢迎使用ueditor! </p> <table width=\"820\"> <tbody> <tr> <td width=\"184\" valign=\"top\"> 1 </td> <td width=\"184\" valign=\"top\"> 2 </td> <td width=\"184\" valign=\"top\"> 3 </td> <td width=\"184\" valign=\"top\"> 4 </td> </tr> <tr> <td width=\"184\" valign=\"top\"> 2 </td> <td width=\"184\" valign=\"top\"> 123 </td> <td width=\"184\" valign=\"top\"> 412 </td> <td width=\"184\" valign=\"top\"> 4214 </td> </tr> <tr> <td width=\"184\" valign=\"top\"> 141 </td> <td width=\"184\" valign=\"top\"> 4124 </td> <td width=\"184\" valign=\"top\"> 4124 </td> <td width=\"184\" valign=\"top\"> 42141<br /> </td> </tr> </tbody> </table> <p> <br /> </p> <p> <img src=\"http://bs.baidu.com/uploadimg/71771362842432.jpg\" style=\"float:right;width:200px;height:133px;\" width=\"200\" height=\"133\" border=\"0\" hspace=\"0\" vspace=\"0\" /> </p>";
		System.out.print(toSummary(testStr3));
	}

}