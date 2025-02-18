--liquibase formatted sql
create index benefit_olympiad_id_index
    on olympguide.benefit (olympiad_id);
create index benefit_program_id_index
    on olympguide.benefit (program_id);
drop table olympguide.liked_fields;