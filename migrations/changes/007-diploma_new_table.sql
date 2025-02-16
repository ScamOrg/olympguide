--liquibase formatted sql
DROP TABLE olympguide.won_olympiads;

CREATE TABLE IF NOT EXISTS olympguide.diploma (
    diploma_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    olympiad_id INTEGER NOT NULL,
    class SMALLINT NOT NULL,
    level SMALLINT NOT NULL ,
    UNIQUE(user_id, olympiad_id, class)
);

ALTER TABLE olympguide.diploma ADD FOREIGN KEY (user_id) REFERENCES "olympguide"."user"(user_id) ON DELETE CASCADE;

ALTER TABLE olympguide.diploma ADD FOREIGN KEY (olympiad_id) REFERENCES olympguide.olympiad(olympiad_id) ON DELETE CASCADE;

ALTER TABLE olympguide.diploma ADD CONSTRAINT diploma_level_checker CHECK (level = ANY(ARRAY[1, 2, 3]));

ALTER TABLE olympguide.diploma ADD CONSTRAINT diploma_class_checker CHECK (class = ANY(ARRAY[9, 10, 11]));