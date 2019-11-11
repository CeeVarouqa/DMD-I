-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------
create schema if not exists usr;

-------------------------------------------------------------------------------
-- types
-------------------------------------------------------------------------------
create schema if not exists types;
do $$ begin
  if not tools.exists_type('Schedule') then
    create type types.Schedule as enum ('2/3', '0', '1');
  end if;

  if not tools.exists_type('ContentType') then
    create type types.ContentType as enum ('text');
  end if;

  if not tools.exists_type('ChatType') then
    create type types.ChatType as enum ('private', 'channel', 'group');
  end if;

  if not tools.exists_type('DoctorSpecialization') then
    create type types.DoctorSpecialization as enum (
      'Traumatologist',
      'Surgeon',
      'Oculist',
      'Therapist'
    );
  end if;
end $$;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- usr.user
-------------------------------------------------------------------------------
create table if not exists usr.user
(
  id                serial primary key,
  first_name        varchar(255) not null,
  last_name         varchar(255) not null,
  email             varchar(255) not null unique,
  hash_pass         varchar(64)  not null,
  birth_date        date         not null,
  is_dead           boolean default false,
  insurance_company varchar(255),
  insurance_number  varchar(255),

  constraint unique_insurance unique (insurance_company, insurance_number)
);
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- usr.staff
-------------------------------------------------------------------------------
create table if not exists usr.staff
(
  id               int primary key references usr.user,
  hired_by         int      not null,
  employment_start date     not null,
  employment_end   date     null,
  salary           decimal  not null,
  schedule_type    types.Schedule not null
);
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- usr.hr
-------------------------------------------------------------------------------
create table if not exists usr.hr
(
  id int primary key references usr.staff
);

do $$ begin
  if not tools.exists_reference('usr_staff_hired_by_usr_hr') then
    alter table usr.staff
    add constraint usr_staff_hired_by_usr_hr
    foreign key (hired_by)
    references usr.hr(id);
  end if;
end $$;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- usr.doctor
-------------------------------------------------------------------------------
create table if not exists usr.doctor
(
  id int primary key references usr.staff,

);
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Chats
-------------------------------------------------------------------------------
create schema if not exists msg;

create table if not exists msg.chat
(
    id   serial primary key,
    name varchar(255)   not null unique,
    chat_type types.ChatType not null
);

create table if not exists msg.message
(
    id           serial primary key,
    content_type types.ContentType not null,
    content      varchar(255)      not null,
    datetime     timestamp         not null,
    sent_by      integer references usr.user (id) not null,
    sent_to      integer references msg.chat (id) not null
);

create table if not exists msg.participate
(
    id                              serial primary key,
    chat_id                         integer references msg.chat (id) not null,
    user_id                         integer references usr.user (id),
    private_chat_participant_number boolean
);

create unique index participate_private on msg.participate (chat_id, private_chat_participant_number) where (
    tools.is_chat_private(chat_id));

-------------------------------------------------------------------------------
-- Log
-------------------------------------------------------------------------------
create schema if not exists logging;

create table if not exists logging.log(
    id serial primary key,
    date timestamp not null,
    text text not null,
    performed_by integer references usr.user(id)
);
-------------------------------------------------------------------------------
