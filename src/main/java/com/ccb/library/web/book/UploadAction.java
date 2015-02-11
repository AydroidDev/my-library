package com.ccb.library.web.book;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ccb.library.entity.Book;
import com.ccb.library.service.book.BookService;

@Controller
@RequestMapping("/uploadEbook")
public class UploadAction {
	private static Logger logger = LoggerFactory.getLogger(UploadAction.class);
@Autowired
private BookService bookService;

	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	public String upload(HttpServletRequest request, HttpServletResponse response) throws IOException {
		//        request = new MulpartRequestWrapper(request);
		if(SecurityUtils.getSubject().getPrincipal()==null){
			response.setStatus(403);
			return "ERROR:" + "匿名用户禁止上传";
		}
		String responseStr = "";
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		//获取前台传值  
		String[] userNames = multipartRequest.getParameterValues("userName");
		String[] contents = multipartRequest.getParameterValues("content");
		String userName = "";
		String content = "";
		if (userNames != null) {
			userName = userNames[0];
		}
		if (contents != null) {
			content = contents[0];
		}
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();

		//            String ctxPath=request.getSession().getServletContext().getRealPath("/")+"uploads\\"; 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy" + File.separator + "MM" + File.separator + "dd");
		SimpleDateFormat sd1 = new SimpleDateFormat("yyyy/MM/dd");
//		SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
		Date now = new Date();
		String ymd = sdf.format(now);
//		String time = sdf2.format(now);
		String ctxPath = request.getSession().getServletContext().getRealPath("/") + "static" + File.separator + "upload"+ File.separator + "ebook" + File.separator+ymd;
		System.out.println("ctx=" + ctxPath);
		//创建文件夹  
		File file = new File(ctxPath);
		if (!file.exists()) {
			file.mkdirs();
		}
		String fileName = null;
		String path = null;
		for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
			// 上传文件名    
			MultipartFile mf = entity.getValue();
			fileName = mf.getOriginalFilename();

//			String uuid = UUID.randomUUID().toString().replaceAll("\\-", "");// 返回一个随机UUID。
//			String suffix = fileName.indexOf(".") != -1 ? fileName.substring(fileName.lastIndexOf("."), fileName.length()) : null;

//			String newFileName = time + "-" + uuid + (suffix != null ? suffix : "");// 构成新文件名。
			String newFileName = fileName;
			File uploadFile = new File(ctxPath +"/"+ newFileName);

			try {
				List<Book> books = bookService.getEbookByName(fileName);
				if ( books!= null&&books.size()!=0) {
					response.setStatus(400);
					return "ERROR:" + "书已存在";
				}
				FileCopyUtils.copy(mf.getBytes(), uploadFile);
				path = ctxPath + newFileName;
				Book ebook = new Book();
				ebook.setName(fileName);
				ebook.setUploadTime(now);
				ebook.setUrl("static/upload/ebook/" + sd1.format(now));
				ebook.setFilePath(ctxPath);
				bookService.newBook(true, ebook);
//				PhotoMeta photo = new PhotoMeta();
//				photo.setOriginalName(fileName);
//				photo.setName(newFileName);
//				photo.setUrl("static/upload/" + sd1.format(now) + "/" + newFileName);
//				photo.setCreateTime(now);
//				photoService.createPhoto(photo);
			} catch (IOException e) {
				response.setStatus(500);
				logger.error("upload error " + e.getMessage(), e);
				return "ERROR:" + e.getMessage();
			} catch (Exception e) {
				response.setStatus(500);
				logger.error("upload error " + e.getMessage(), e);
				return "ERROR:" + e.getMessage();
			}
		}

		return path;
	}
}