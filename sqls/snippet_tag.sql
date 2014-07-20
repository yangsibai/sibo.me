create table snippet_tag(
    id int primary key auto_increment,
    snippetId int not null,
    tagId int not null,
    addTime datetime not null
)engine=innodb default charset=utf8;