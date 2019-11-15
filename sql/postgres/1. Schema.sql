-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------
create schema if not exists usr;

-------------------------------------------------------------------------------
-- types
-------------------------------------------------------------------------------
create schema if not exists types;
do
$$
  begin
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
        'Traumatologist'
      , 'Surgeon'
      , 'Oculist'
      , 'Therapist'
      );
    end if;
  end
$$;


-------------------------------------------------------------------------------
-- usr.users
-------------------------------------------------------------------------------
create table if not exists usr.users
(
  id                serial primary key
, first_name        varchar(255) not null
, last_name         varchar(255) not null
, email             varchar(255) not null unique
, hash_pass         varchar(64)  not null
, birth_date        date         not null
, is_dead           boolean default false
, insurance_company varchar(255)
, insurance_number  varchar(255),

  constraint unique_insurance unique (insurance_company, insurance_number)
);


-------------------------------------------------------------------------------
-- usr.staff
-------------------------------------------------------------------------------
create table if not exists usr.staff
(
  id               int primary key references usr.users
, hired_by         int            not null
, employment_start date           not null
, employment_end   date           null
, salary           decimal        not null
, schedule_type    types.Schedule not null
);


-------------------------------------------------------------------------------
-- usr.hrs
-------------------------------------------------------------------------------
create table if not exists usr.hrs
(
  id int primary key references usr.staff
);

do
$$
  begin
    if not tools.exists_reference('usr_staff_hired_by_usr_hr') then
      alter table usr.staff
      add constraint usr_staff_hired_by_usr_hr
      foreign key (hired_by)
      references usr.hrs (id);
    end if;
  end
$$;


-------------------------------------------------------------------------------
-- usr.doctors
-------------------------------------------------------------------------------
create table if not exists usr.doctors
(
  id             int primary key references usr.staff
, specialization types.DoctorSpecialization not null
-- , clinc_number not null
);


-------------------------------------------------------------------------------
-- usr.nurses
-------------------------------------------------------------------------------
create table if not exists usr.nurses
(
  id int primary key references usr.staff
);


-------------------------------------------------------------------------------
-- usr.doctors_nurses
-------------------------------------------------------------------------------
create table if not exists usr.doctors_nurses
(
  id        serial primary key
, doctor_id int references usr.doctors not null
, nurse_id  int references usr.nurses  not null
);


-------------------------------------------------------------------------------
-- usr.inventory_managers
-------------------------------------------------------------------------------
create table if not exists usr.inventory_managers
(
  id int primary key references usr.staff
);


-------------------------------------------------------------------------------
-- usr.pharmacists
-------------------------------------------------------------------------------
create table if not exists usr.pharmacists
(
  id int primary key references usr.staff
);


-------------------------------------------------------------------------------
-- usr.lab_technicians
-------------------------------------------------------------------------------
create table if not exists usr.lab_technicians
(
  id int primary key references usr.staff
);


-------------------------------------------------------------------------------
-- usr.receptionists
-------------------------------------------------------------------------------
create table if not exists usr.receptionists
(
  id int primary key references usr.staff
);


-------------------------------------------------------------------------------
-- usr.paramedics
-------------------------------------------------------------------------------
create table if not exists usr.paramedics
(
  id int primary key references usr.staff
-- , position
);


-------------------------------------------------------------------------------
-- usr.patients
-------------------------------------------------------------------------------
create table if not exists usr.patients
(
  id int primary key references usr.users
);


-------------------------------------------------------------------------------
-- Chats
-------------------------------------------------------------------------------
create schema if not exists msg;

-------------------------------------------------------------------------------
-- msg.chat
-------------------------------------------------------------------------------
create table if not exists msg.chats
(
  id        serial primary key
, name      varchar(255)   not null unique
, chat_type types.ChatType not null
);


-------------------------------------------------------------------------------
-- msg.message
-------------------------------------------------------------------------------
create table if not exists msg.messages
(
  id           serial primary key
, content_type types.ContentType                 not null
, content      varchar(255)                      not null
, datetime     timestamp                         not null
, sent_by      integer references usr.users (id) not null
, sent_to      integer references msg.chats (id) not null
);


-------------------------------------------------------------------------------
-- msg.participate
-------------------------------------------------------------------------------
create table if not exists msg.chats_participants
(
  id                              serial primary key
, chat_id                         integer references msg.chats (id) not null
, user_id                         integer references usr.users (id)
, private_chat_participant_number boolean
);

create unique index participate_private on msg.chats_participants (chat_id, private_chat_participant_number) where (
  tools.is_chat_private(chat_id));


-------------------------------------------------------------------------------
-- Log
-------------------------------------------------------------------------------
create schema if not exists logging;

-------------------------------------------------------------------------------
-- logging.logs
-------------------------------------------------------------------------------
create table if not exists logging.logs
(
  id           serial primary key
, date         timestamp not null
, text         text      not null
, performed_by integer references usr.users (id)
);


-------------------------------------------------------------------------------
-- Notice board
-------------------------------------------------------------------------------
create schema if not exists board;

-------------------------------------------------------------------------------
-- board.messages
-------------------------------------------------------------------------------
create table if not exists board.messages
(
  id     serial primary key
, text   text not null
, expiry date default now() + interval '10 day'
);


-------------------------------------------------------------------------------
-- board.modifications
-------------------------------------------------------------------------------
create table if not exists board.modifications
(
  id       serial primary key
, date     date default now()
, change   text                               not null
, modifies int references board.messages (id) not null
, made_by  int references usr.staff (id)      not null
);


-------------------------------------------------------------------------------
-- Service
-------------------------------------------------------------------------------
create schema if not exists service;

-------------------------------------------------------------------------------
-- service.redirection
-------------------------------------------------------------------------------
create table if not exists service.redirections
(
  id         serial primary key
, issue_date date default now()
, directs_to int references usr.doctors (id)  not null
, is_made_by int references usr.doctors (id)  not null
, directs    int references usr.patients (id) not null
);

-------------------------------------------------------------------------------
-- service.in_patient_direction
-------------------------------------------------------------------------------
create table if not exists service.in_patient_directions
(
  id         serial primary key
, issue_date date default now()
, is_made_by int references usr.doctors (id)  not null
, directs    int references usr.patients (id) not null
);