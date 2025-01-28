CREATE SCHEMA olympguide;

SET search_path TO olympguide;

CREATE TABLE IF NOT EXISTS region
(
    region_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS subject
(
    subject_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS group_of_fields
(
    group_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    code CHAR(8) NOT NULL UNIQUE
);

ALTER TABLE group_of_fields ADD CONSTRAINT group_of_fields_verifier CHECK (code SIMILAR TO '\d\d\.00\.00');


CREATE TABLE IF NOT EXISTS olympiad
(
    olympiad_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    level SMALLINT NOT NULL,
    profile TEXT NOT NULL,
    link TEXT
);

ALTER TABLE olympiad ADD CONSTRAINT olympiad_level_checker CHECK (level = ANY(ARRAY[1, 2, 3]));


CREATE TABLE IF NOT EXISTS "user"
(
    user_id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    second_name TEXT,
    birthday DATE NOT NULL,
    password_hash TEXT NOT NULL,
    region_id INTEGER
);

ALTER TABLE "user" ADD FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE SET NULL;


CREATE TABLE university
(
    university_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    logo TEXT,
    email TEXT,
    site TEXT,
    description TEXT,
    region_id INTEGER NOT NULL,
    popularity INTEGER NOT NULL DEFAULT 0
);

ALTER TABLE university ADD FOREIGN KEY (region_id) REFERENCES region (region_id) ON DELETE CASCADE;

ALTER TABLE university ADD CONSTRAINT university_popularity_checker CHECK (popularity >= 0);


CREATE TABLE IF NOT EXISTS field_of_study
(
    field_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    code CHAR(8) NOT NULL UNIQUE,
    degree TEXT NOT NULL,
    group_id INTEGER NOT NULL
);

ALTER TABLE field_of_study ADD FOREIGN KEY (group_id) REFERENCES group_of_fields(group_id) ON DELETE CASCADE;

ALTER TABLE field_of_study ADD CONSTRAINT field_of_study_verifier CHECK (code SIMILAR TO '\d\d\.\d\d\.\d\d');


CREATE TABLE IF NOT EXISTS faculty
(
    faculty_id SERIAL PRIMARY KEY,
    university_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT
);

ALTER TABLE faculty ADD FOREIGN KEY (university_id) REFERENCES university (university_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS admin_user
(
    user_id INTEGER PRIMARY KEY,
    edit_university_id INTEGER,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_founder BOOLEAN NOT NULL DEFAULT FALSE
);

ALTER TABLE admin_user ADD FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE;

ALTER TABLE admin_user ADD FOREIGN KEY (edit_university_id) REFERENCES university(university_id) ON DELETE SET NULL;


CREATE TABLE IF NOT EXISTS olymp_stage
(
    stage_id SERIAL PRIMARY KEY,
    olympiad_id INTEGER NOT NULL,
    start_date DATE,
    number SMALLINT NOT NULL DEFAULT 1,
    description TEXT,
    is_final BOOLEAN NOT NULL,
    is_online BOOLEAN
);

ALTER TABLE olymp_stage ADD FOREIGN KEY (olympiad_id) REFERENCES olympiad(olympiad_id) ON DELETE SET NULL;

ALTER TABLE olymp_stage ADD CONSTRAINT olymp_stage_checker CHECK (number > 0);


CREATE TABLE IF NOT EXISTS educational_program
(
    program_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    university_id INTEGER NOT NULL,
    faculty_id INTEGER NOT NULL,
    field_id INTEGER NOT NULL,
    budget_places SMALLINT NOT NULL,
    paid_places SMALLINT NOT NULL,
    cost INTEGER NOT NULL,
    link TEXT
);

ALTER TABLE educational_program ADD FOREIGN KEY (university_id) REFERENCES university (university_id) ON DELETE CASCADE;

ALTER TABLE educational_program ADD FOREIGN KEY (faculty_id) REFERENCES faculty (faculty_id) ON DELETE CASCADE;

ALTER TABLE educational_program ADD FOREIGN KEY (field_id) REFERENCES field_of_study (field_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS benefit
(
    benefit_id SERIAL PRIMARY KEY,
    olympiad_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    is_bvi BOOLEAN NOT NULL,
    min_diploma_level SMALLINT NOT NULL,
    min_class SMALLINT NOT NULL
);

ALTER TABLE benefit ADD FOREIGN KEY (olympiad_id) REFERENCES olympiad (olympiad_id) ON DELETE CASCADE;

ALTER TABLE benefit ADD FOREIGN KEY (program_id) REFERENCES educational_program (program_id) ON DELETE CASCADE;

ALTER TABLE benefit ADD CONSTRAINT benefit_diploma_level_checker CHECK (min_diploma_level = ANY(ARRAY[1, 2, 3]));

ALTER TABLE benefit ADD CONSTRAINT benefit_class_checker CHECK (min_class = ANY(ARRAY[9, 10, 11]));


CREATE TABLE IF NOT EXISTS won_olympiads
(
    user_id INTEGER NOT NULL,
    olympiad_id INTEGER NOT NULL,
    class SMALLINT NOT NULL,
    diploma_level SMALLINT NOT NULL,
    PRIMARY KEY (user_id, olympiad_id)
);

ALTER TABLE won_olympiads ADD FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE;

ALTER TABLE won_olympiads ADD FOREIGN KEY (olympiad_id) REFERENCES olympiad(olympiad_id) ON DELETE CASCADE;

ALTER TABLE won_olympiads ADD CONSTRAINT won_olympiads_diploma_level_checker CHECK (diploma_level = ANY(ARRAY[1, 2, 3]));

ALTER TABLE won_olympiads ADD CONSTRAINT won_olympiads_class_checker CHECK (class = ANY(ARRAY[9, 10, 11]));


CREATE TABLE IF NOT EXISTS liked_fields
(
   user_id INTEGER NOT NULL,
   field_id INTEGER NOT NULL,
   PRIMARY KEY (user_id, field_id)
);

ALTER TABLE liked_fields ADD FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE;

ALTER TABLE liked_fields ADD FOREIGN KEY (field_id) REFERENCES field_of_study(field_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS liked_universities
(
   user_id INTEGER NOT NULL,
   university_id INTEGER NOT NULL,
   PRIMARY KEY (user_id, university_id)
);

ALTER TABLE liked_universities ADD FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE;

ALTER TABLE liked_universities ADD FOREIGN KEY (university_id) REFERENCES university(university_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS liked_programs
(
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, program_id)
);

ALTER TABLE liked_programs ADD FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE;

ALTER TABLE liked_programs ADD FOREIGN KEY (program_id) REFERENCES educational_program(program_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS liked_olympiads
(
    user_id INTEGER NOT NULL,
    olympiad_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, olympiad_id)
);

ALTER TABLE liked_olympiads ADD FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE CASCADE;

ALTER TABLE liked_olympiads ADD FOREIGN KEY (olympiad_id) REFERENCES olympiad(olympiad_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS program_subjects
(
    program_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    PRIMARY KEY (program_id, subject_id)
);

ALTER TABLE program_subjects ADD FOREIGN KEY (program_id) REFERENCES educational_program(program_id) ON DELETE CASCADE;

ALTER TABLE program_subjects ADD FOREIGN KEY (subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS confirmation_subjects
(
    benefit_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    PRIMARY KEY (benefit_id, subject_id)
);

ALTER TABLE confirmation_subjects ADD FOREIGN KEY (benefit_id) REFERENCES benefit(benefit_id) ON DELETE CASCADE;

ALTER TABLE confirmation_subjects ADD FOREIGN KEY (subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS fullscore_subjects
(
    benefit_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    PRIMARY KEY (benefit_id, subject_id)
);

ALTER TABLE fullscore_subjects ADD FOREIGN KEY (benefit_id) REFERENCES benefit (benefit_id) ON DELETE CASCADE;

ALTER TABLE fullscore_subjects ADD FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE;