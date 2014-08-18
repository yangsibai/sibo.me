##sqls

###create database

	create database sibo;

###用户表

	create table user(
		id int primary key auto_increment,
		email varchar(60) not null,
		password varchar(50) not null,
		addTime datetime not null,
		state tinyint not null
	)engine=innodb default charset = utf8;

###代码片段表

	create table snippet(
        id int primary key auto_increment,
        title varchar(100) not null,
        content text not null,
        html text not null,
        addTime datetime not null,
        updateTime datetime not null,
        version int not null,
        state tinyint
    )engine=innodb default charset=utf8;

###网页表

create table page(
	id int primary key auto_increment,
	url varchar(500) not null,
	title varchar(100) not null,
	width int not null,
	height int not null,
	pinCount int not null,
	comment varchar(200),
	addTime datetime not null,
	updateTime datetime not null,
	state tinyint not null
)engine=innodb default charset=utf8;

###pin

	create table pin(
		id int primary key auto_increment,
		pageId int not null,
		x int not null,
		y int not null,
		message varchar(100),
		addTime datetime not null,
		state tinyint not null
	)engine=innodb default charset=utf8;

###tag

	create table tag(
		id int primary key auto_increment,
		name varchar(50) not null,
		addTime datetime not null
	)engine=innodb default charset=utf8;

###page_tag

	create table page_tag(
		id int primary key auto_increment,
		pageId int,
		tagId int,
		addTime datetime
	)engine=innodb default charset=utf8;

###snippet_tag

	create table snippet_tag(
		id int primary key auto_increment,
		snippetId int not null,
		tagId int not null,
		addTime datetime not null
	)engine=innodb default charset=utf8;

###snippet_revision

	create table snippet_revision(
		id int primary key auto_increment,
		snippetId int not null,
		version int not null,
		title varchar(100) not null,
		content text not null,
		tags varchar(100) not null,
		addTime datetime not null,
		state tinyint not null
	)engine =innodb default charset=utf8;

###error

	CREATE TABLE error()