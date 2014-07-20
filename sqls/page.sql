create table page(
	id int primary key auto_increment,
	url varchar(500) not null,
	title varchar(100) not null,
	width int not null,
	height int not null,
	pinCount int not null,
	addTime datetime not null,
	updateTime datetime not null,
	state tinyint not null
)engine=innodb default charset=utf8;

--add comment at 2014-7-20
alter table page add column comment varchar(200);