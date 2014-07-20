create table tag(
	id int primary key auto_increment,
	name varchar(50) not null,
	addTime datetime not null
)engine=innodb default charset=utf8;