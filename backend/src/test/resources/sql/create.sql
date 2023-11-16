create table if not exists `user`
(
    user_id        bigint auto_increment primary key,
    create_date    datetime(6)  not null,
    modified_date  datetime(6)  not null,
    activate_date  datetime(6)  not null,
    delete_yn      char         not null,
    phone_number   varchar(255) not null,
    name           varchar(255) not null,
    nickname       varchar(255) not null,
    phone_model    varchar(255) null,
    picture        varchar(255) null,
    status_message varchar(255) null,
    password       varchar(255) not null
);

create table if not exists authority
(
    authority_id bigint auto_increment
    primary key,
    role_name    varchar(255) not null,
    user_id      bigint       not null,
    constraint FKr1wgeo077ok1nr1shx0t70tg8
        foreign key (user_id) references `user` (user_id)
);

create table if not exists fcm_token
(
    fcm_token_id  bigint auto_increment
        primary key,
    activate_date datetime(6)  not null,
    token         varchar(255) not null,
    user_id       bigint       not null,
    constraint FK8u9xsmd3agc2nn80tb16ouph4
        foreign key (user_id) references `user` (user_id)
);

create table if not exists study
(
    study_id       bigint auto_increment
        primary key,
    create_date    datetime(6)  not null,
    modified_date  datetime(6)  not null,
    delete_yn      char         not null,
    detail         varchar(40)  null,
    invite_qr_code varchar(255) not null,
    invite_link    varchar(255) not null,
    picture        varchar(255) null,
    study_name     varchar(30)  not null,
    host_user_id        bigint       not null,
    constraint FKkhcyngf15w120k4wx6pp21ijn
        foreign key (host_user_id) references `user` (user_id)
);

create table if not exists notice
(
    notice_id     bigint auto_increment
        primary key,
    create_date   datetime(6)  not null,
    modified_date datetime(6)  not null,
    contents      varchar(100) not null,
    delete_yn     char         not null,
    pin_yn        char         not null,
    title         varchar(50)  not null,
    study_id      bigint       not null,
    user_id       bigint       not null,
    constraint FKcvf4mh5se36inrxn7xlh2brfv
        foreign key (user_id) references `user` (user_id),
    constraint FKdyaf5r9t0nrj8brk9v61odjc2
        foreign key (study_id) references study (study_id)
);

create table if not exists check_notice
(
    id        bigint auto_increment
        primary key,
    notice_id bigint not null,
    user_id   bigint not null,
    constraint FKajbojoc8jmrv3j4xcmrpv688l
        foreign key (user_id) references `user` (user_id),
    constraint FKcnhxuf35g6dbj0s9tihgulfd
        foreign key (notice_id) references notice (notice_id)
);

create table if not exists comment
(
    comment_id        bigint auto_increment
        primary key,
    create_date       datetime(6)  not null,
    modified_date     datetime(6)  not null,
    contents          varchar(100) not null,
    delete_yn         char         not null,
    notice_id         bigint       null,
    parent_comment_id bigint       null,
    user_id           bigint       not null,
    constraint FK8kcum44fvpupyw6f5baccx25c
        foreign key (user_id) references `user` (user_id),
    constraint FKhvh0e2ybgg16bpu229a5teje7
        foreign key (parent_comment_id) references comment (comment_id),
    constraint FKq7rr5epaoagevts8cop65o31h
        foreign key (notice_id) references notice (notice_id)
);

create table if not exists rel_user_study
(
    user_study_id bigint auto_increment
        primary key,
    create_date   datetime(6)  not null,
    modified_date datetime(6)  not null,
    color         varchar(127) not null,
    study_id      bigint       not null,
    user_id       bigint       not null,
    constraint FK7erm3ctgn7n8tfvst4auyd5fl
        foreign key (user_id) references `user` (user_id),
    constraint FKc74bwwaegphmtuefmi8sfhowv
        foreign key (study_id) references study (study_id)
);

create table if not exists round
(
    round_id      bigint auto_increment
        primary key,
    create_date   datetime(6)  not null,
    modified_date datetime(6)  not null,
    study_place   varchar(30)  null,
    study_time    datetime(6)  null,
    delete_yn     char         not null,
    detail        varchar(100) null,
    study_id      bigint       not null,
    constraint FK41ah5maxtjcdgiohmdr2s9fai
        foreign key (study_id) references study (study_id)
);

create table if not exists rel_user_round
(
    user_round_id bigint auto_increment
        primary key,
    status_tag    varchar(20) not null,
    round_id      bigint      not null,
    user_id       bigint      not null,
    constraint FKfa12r32ylmnl47houwtwek9ij
        foreign key (user_id) references `user` (user_id),
    constraint FKssy2n9lbn5sxtxugavyqkvvog
        foreign key (round_id) references round (round_id)
);

create table if not exists rule
(
    rule_id       bigint auto_increment
        primary key,
    create_date   datetime(6) not null,
    modified_date datetime(6) not null,
    delete_yn     char        not null,
    detail        varchar(50) not null,
    study_id      bigint      not null,
    constraint FK8lmh7l1b5g26mr79ie80dv1mv
        foreign key (study_id) references study (study_id)
);

create table if not exists task
(
    task_id       bigint auto_increment
        primary key,
    detail        varchar(200) not null,
    done_yn       char         not null,
    task_type     varchar(20)  not null,
    user_round_id bigint       not null,
    constraint FK8vl3vhkgegfpqrgle2wb3sp3t
        foreign key (user_round_id) references rel_user_round (user_round_id)
);

