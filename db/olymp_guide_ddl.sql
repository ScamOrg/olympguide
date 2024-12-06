CREATE SCHEMA olympguide;

ALTER DATABASE olympguide_db SET search_path TO olympguide;

create table if not exists subject
(
    subject_id serial not null primary key,
    name text not null
);

create table if not exists olympiad
(
    olympiad_id serial
        primary key,
    name        text     not null,
    description text,
    level       smallint not null
        constraint olympiad_level_check
            check (level = ANY (ARRAY [1, 2, 3])),
    profile     text     not null,
    link        text
);

create table if not exists olymp_stage
(
    olympiad_id serial
        primary key,
    start_date  date,
    number      smallint not null,
    description text,
    is_final    boolean  not null,
    is_online   boolean
);

create table if not exists region
(
    region_id serial
        primary key,
    name      text
);

create table if not exists university
(
    university_id serial
        primary key,
    name          text              not null,
    logo          bytea,
    description   text,
    region_id     integer           not null
        references region,
    popularity    integer default 0 not null,
    link          text              not null
);

create table if not exists faculty
(
    faculty_id    serial
        primary key,
    university_id integer not null
        references university
            on delete cascade,
    name          text    not null,
    description   text
);

create table if not exists "user"
(
    user_id       serial
        primary key,
    email         text not null
        unique,
    first_name    text not null,
    last_name     text not null,
    second_name   text,
    birthday      date not null,
    password_hash text not null,
    region_id     integer
                       references region
                           on delete set null
);

create table if not exists email_code
(
    email      text                                not null
        primary key,
    code       integer                             not null,
    created_at timestamp default CURRENT_TIMESTAMP not null
);

create table if not exists group_of_fields
(
    group_id serial
        primary key,
    name     text    not null,
    code     char(8) not null
        unique
);

create table if not exists field_of_study
(
    field_id serial
        primary key,
    name     text    not null,
    code     char(8) not null
        unique,
    degree   text    not null,
    group_id integer not null
        references group_of_fields
            on delete cascade
);

create table if not exists educational_program
(
    program_id    serial
        primary key,
    university_id integer not null
        references university
            on delete cascade,
    faculty_id    integer not null
        references faculty
            on delete cascade,
    field_id      integer not null
        references field_of_study
            on delete cascade,
    budget_places smallint,
    paid_places   smallint,
    cost          smallint,
    link          text    not null
);

create table if not exists benefit
(
    benefit_id        serial
        primary key,
    olympiad_id       integer  not null
        references olympiad
            on delete cascade,
    program_id        integer  not null
        references educational_program
            on delete cascade,
    is_bvi            boolean  not null,
    min_diploma_level smallint not null,
    min_class         smallint not null
);

create table if not exists won_olympiads
(
    user_id     integer not null
        references "user"
            on delete cascade,
    olympiad_id integer not null
        references olympiad
            on delete cascade,
    primary key (user_id, olympiad_id)
);

create table if not exists liked_olympiads
(
    user_id     integer not null
        references "user"
            on delete cascade,
    olympiad_id integer not null
        references olympiad
            on delete cascade,
    primary key (user_id, olympiad_id)
);

create table if not exists liked_fields
(
    user_id  integer not null
        references "user"
            on delete cascade,
    field_id integer not null
        references field_of_study
            on delete cascade,
    primary key (user_id, field_id)
);

create table if not exists liked_universities
(
    user_id       integer not null
        references "user"
            on delete cascade,
    university_id integer not null
        references university
            on delete cascade,
    primary key (user_id, university_id)
);

create table if not exists liked_programs
(
    user_id    integer not null
        references "user"
            on delete cascade,
    program_id integer not null
        references educational_program
            on delete cascade,
    primary key (user_id, program_id)
);

create table if not exists program_subjects
(
    program_id integer not null
        references educational_program
            on delete cascade,
    subject_id integer not null
        references subject
            on delete cascade,
    primary key (program_id, subject_id)
);

create table if not exists confirmation_subjects
(
    benefit_id integer not null
        references benefit
            on delete cascade,
    subject_id integer not null
        references subject
            on delete cascade,
    primary key (benefit_id, subject_id)
);

create table if not exists fullscore_subjects
(
    benefit_id integer not null
        references benefit
            on delete cascade,
    subject_id integer not null
        references subject
            on delete cascade,
    primary key (benefit_id, subject_id)
);

create table if not exists admin_users
(
    user_id               integer               not null
        primary key
        references "user"
            on delete cascade,
    can_change_olymp      boolean               not null,
    can_change_university boolean               not null,
    edit_university_id    integer
                                                references university
                                                    on delete set null,
    is_founder            boolean default false not null
);