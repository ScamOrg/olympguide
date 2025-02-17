--liquibase formatted sql
alter table olympguide.confirmation_subjects
    add score integer default 0 not null;
