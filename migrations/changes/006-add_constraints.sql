--liquibase formatted sql
ALTER TABLE olympguide.university ADD CONSTRAINT name_university_unique UNIQUE (name);
ALTER TABLE olympguide.faculty
    ADD CONSTRAINT name_and_universityid_faculty_unique UNIQUE (name, university_id);
ALTER TABLE olympguide.educational_program
    ADD CONSTRAINT name_program_unique UNIQUE (name, university_id)