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