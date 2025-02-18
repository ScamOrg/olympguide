--liquibase formatted sql
alter table olympguide.educational_program
    add popularity integer default 0 not null;