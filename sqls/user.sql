create table user(
    id int primary key auto_increment,
    email varchar(50) not null,
    password varchar(50) not null,
    addTime datetime not null,
    state tinyint not null
)engine=innodb default charset = utf8;