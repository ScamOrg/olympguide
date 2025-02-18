--liquibase formatted sql
ALTER TABLE olympguide.benefit
    ADD CONSTRAINT benefit_unique UNIQUE (olympiad_id, program_id, min_class, min_diploma_level);