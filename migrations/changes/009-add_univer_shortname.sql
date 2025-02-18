--liquibase formatted sql
alter table olympguide.university
    add short_name text;