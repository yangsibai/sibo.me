create table page_tag(
	id int primary key auto_increment,
	pageId int,
	tagId int,
	addTime datetime
)engine=innodb default charset=utf8;