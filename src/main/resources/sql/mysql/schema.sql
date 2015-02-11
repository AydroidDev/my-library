CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `roles` varchar(64) NOT NULL,
  `login_name` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` varchar(64) NOT NULL,
  `salt` varchar(64) NOT NULL,
  `aum` bigint(20) DEFAULT '0',
  `department` varchar(64),
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_name` (`login_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (-1,'admin','admin','管理员','5a4844b2f794957b232a639532b8b53b27e99169','enabled','5e55d5b30daca71d',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;



create table books (
id bigint(20) NOT NULL AUTO_INCREMENT,
name varchar(255) NOT NULL,

author varchar(64) DEFAULT NULL,
press varchar(255) DEFAULT NULL,
publication_date datetime DEFAULT NULL,
num_instock int DEFAULT NULL, /**可借数*/
num_all int DEFAULT NULL,  /**馆藏数*/
contributor varchar(64) DEFAULT NULL,
borrow_count bigint(20) DEFAULT NULL,
is_ebook bit(1) NOT NULL DEFAULT b'0',

uploader_id bigint(20) DEFAULT NULL,
url varchar(255) DEFAULT NULL,
upload_time datetime DEFAULT NULL,
download_count bigint(20) DEFAULT NULL,
file_path varchar(255) DEFAULT NULL,
comment_count bigint(20) NOT NULL DEFAULT '0',

primary key(id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


create table book_borrow(
id bigint(20) NOT NULL AUTO_INCREMENT,
book_id bigint(20) NOT NULL references books(id),
user_id bigint(20) NOT NULL references user(id),
borrow_date datetime NOT NULL,
return_date datetime DEFAULT NULL,
primary key(id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `catalog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


LOCK TABLES `catalog` WRITE;
/*!40000 ALTER TABLE `catalog` DISABLE KEYS */;
INSERT INTO `catalog` VALUES (-2,'通知公告'),(-1,'书评影评');
/*!40000 ALTER TABLE `catalog` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `catalog_id` bigint(20) DEFAULT '-1',
  `title` varchar(200) NOT NULL,
  `summary` text,
  `content` mediumtext NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `modify_time` datetime DEFAULT NULL,
  `post_ip` varchar(50) DEFAULT NULL,
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  `view_count` bigint(20) DEFAULT '0',
  `is_top` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `article_user_id_fk` (`user_id`),
  KEY `article_catolog_id_fk` (`catalog_id`),
  CONSTRAINT `article_catolog_id_fk` FOREIGN KEY (`catalog_id`) REFERENCES `catalog` (`id`),
  CONSTRAINT `article_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `content` varchar(5000) NOT NULL,
  `create_time` datetime NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `author` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `reply_comment_id` bigint(20) DEFAULT NULL,
  `reply_comment_content` varchar(5000) DEFAULT NULL,
  `reply_author` varchar(30) DEFAULT NULL,
  `reply_author_email` varchar(100) DEFAULT NULL,
  `reply_author_url` varchar(200) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `comment_user_id_fk` (`user_id`),
  KEY `comment_article_id_fk` (`article_id`),
  CONSTRAINT `comment_article_id_fk` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `photo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `file_Path` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `photo_user_id_fk` (`user_id`),
  CONSTRAINT `photo_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/**
 * update start
 */
CREATE TABLE `book_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `book_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `content` varchar(1024) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `b_comment_book_id_fk` (`book_id`),
  CONSTRAINT `b_comment_book_id_fk` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;



/**
 * update 2015.1.6 end
 */

/**
 * update start
 */
create table book_download(
id bigint(20) NOT NULL AUTO_INCREMENT,
book_id bigint(20) NOT NULL references books(id),
user_id bigint(20) NOT NULL,
download_date datetime NOT NULL,
primary key(id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

--摘要
create table excerpt(
id bigint(20) primary key NOT NULL AUTO_INCREMENT,
content varchar(1000) NOT NULL,
book_name varchar(255) NOT NULL,
book_author varchar(255) DEFAULT '',
user_id bigint(20) DEFAULT NULL,
create_time datetime DEFAULT NULL
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
