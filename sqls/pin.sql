create table pin(
    id int primary key auto_increment,
    pageId int not null,
    x int not null,
    y int not null,
    message varchar(100),
    addTime datetime not null,
    state tinyint not null
)engine=innodb default charset=utf8;