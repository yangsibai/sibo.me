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