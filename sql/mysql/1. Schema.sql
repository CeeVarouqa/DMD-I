drop procedure if exists init_db;

create procedure init_db()
begin
-- -----------------------------------------------------------------------------
-- users
-- -----------------------------------------------------------------------------
create table if not exists users
(
  id                serial primary key
, first_name        varchar(255) not null
, last_name         varchar(255) not null
, email             varchar(255) not null unique
, hash_pass         varchar(64)  not null
, birth_date        date         not null
, is_dead           bool default false
, insurance_company varchar(255)
, insurance_number  varchar(255),

  constraint unique_insurance unique (insurance_company, insurance_number)
);

-- -----------------------------------------------------------------------------
-- staff
-- -----------------------------------------------------------------------------
create table if not exists staff
(
  id               int primary key references users
, hired_by         int            null
, employment_start date           not null
, employment_end   date           null
, salary           decimal(15, 2) not null
, schedule_type    enum('2/3'
                      , '0'
                      , '1')      not null
);

-- -----------------------------------------------------------------------------
-- hrs
-- -----------------------------------------------------------------------------
create table if not exists hrs
(
  id int primary key references staff
);
if not exists_reference('staff_hired_by_hr') then
  alter table staff
  add constraint staff_hired_by_hr
  foreign key (hired_by)
  references hrs (id);
end if;

-- -----------------------------------------------------------------------------
-- doctors
-- -----------------------------------------------------------------------------
create table if not exists doctors
(
  id             int primary key references staff
, specialization enum('Traumatologist'
                    , 'Surgeon'
                    , 'Oculist'
                    , 'Therapist') not null
, clinic_number  varchar(32) not null
);

-- -----------------------------------------------------------------------------
-- nurses
-- -----------------------------------------------------------------------------
create table if not exists nurses
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- doctors_nurses
-- -----------------------------------------------------------------------------
create table if not exists doctors_nurses
(
  id        serial primary key
, doctor_id int not null references doctors
, nurse_id  int not null references nurses
);
-- -----------------------------------------------------------------------------
-- inventory_managers
-- -----------------------------------------------------------------------------
create table if not exists inventory_managers
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- pharmacists
-- -----------------------------------------------------------------------------
create table if not exists pharmacists
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- lab_technicians
-- -----------------------------------------------------------------------------
create table if not exists lab_technicians
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- receptionists
-- -----------------------------------------------------------------------------
create table if not exists receptionists
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- paramedics
-- -----------------------------------------------------------------------------
create table if not exists paramedics
(
  id       int primary key references staff
, position enum('Primary'
              , 'Secondary') not null
);

-- -----------------------------------------------------------------------------
-- paramedic_groups
-- -----------------------------------------------------------------------------
create table if not exists paramedic_groups
(
  id serial primary key
, is_active boolean default true
);

-- -----------------------------------------------------------------------------
-- paramedic_group_divisions
-- -----------------------------------------------------------------------------
create table if not exists paramedic_group_divisions
(
  id           serial primary key
, paramedic_id int references paramedics (id)
, group_id     int references paramedic_groups (id)
);

-- -----------------------------------------------------------------------------
-- patients
-- -----------------------------------------------------------------------------
create table if not exists patients
(
  id int primary key references users
);

-- -----------------------------------------------------------------------------
-- admins
-- -----------------------------------------------------------------------------
create table if not exists admins
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- users_roles
-- -----------------------------------------------------------------------------
create or replace view users_roles as
  select u.id              as user_id
       , p.id  is not null as is_patient
       , h.id  is not null as is_hr
       , d.id  is not null as is_doctor
       , n.id  is not null as is_nurse
       , im.id is not null as is_inventory_manager
       , ph.id is not null as is_pharmacist
       , lt.id is not null as is_lab_technician
       , r.id  is not null as is_receptionist
       , pm.id is not null as is_paramedic
       , a.id  is not null as is_admin
  from users as u
  left join patients as p
    on p.id = u.id
  left join hrs as h
    on h.id = u.id
  left join doctors as d
    on d.id = u.id
  left join nurses as n
    on n.id = u.id
  left join inventory_managers as im
    on im.id = u.id
  left join pharmacists as ph
    on ph.id = u.id
  left join lab_technicians as lt
    on lt.id = u.id
  left join receptionists as r
    on r.id = u.id
  left join paramedics as pm
    on pm.id = u.id
  left join admins as a
    on a.id = u.id
;

-- -----------------------------------------------------------------------------
-- chats
-- -----------------------------------------------------------------------------
create table if not exists chats
(
  id        serial primary key
, name      varchar(255)   not null unique
, chat_type enum('private'
               , 'channel'
               , 'group') not null
);

-- -----------------------------------------------------------------------------
-- chats_messages
-- -----------------------------------------------------------------------------
create table if not exists chats_messages
(
  id           serial primary key
, content_type enum('text') not null
, content      text              not null
, datetime     timestamp         not null
, sent_by      int               not null
    references users (id)
, sent_to      int               not null
    references chats (id)
);

-- -----------------------------------------------------------------------------
-- chats_participants
-- -----------------------------------------------------------------------------
create table if not exists chats_participants
(
  id                              serial primary key
, chat_id                         int not null
    references chats(id)
, user_id                         int not null
    references users(id)
, private_chat_participant_number bool
);

-- -----------------------------------------------------------------------------
-- logs
-- -----------------------------------------------------------------------------
create table if not exists logs
(
  id           serial primary key
, date         timestamp not null
, text         text      not null
, performed_by int       not null
    references users (id)
);

-- -----------------------------------------------------------------------------
-- board_messages
-- -----------------------------------------------------------------------------
create table if not exists board_messages
(
  id     serial primary key
, text   text not null
, expiry date not null
    default (date_add(current_date(), interval 10 day))
);

-- -----------------------------------------------------------------------------
-- modifications
-- -----------------------------------------------------------------------------
create table if not exists board_modifications
(
  id          serial primary key
, datetime    timestamp default current_timestamp()
, `change`    text not null
, change_type enum('Addition'
                 , 'Removal'
                 , 'Modification'
                 , 'Creation') not null
, `modifies` int not null references board_messages (id)
, made_by    int not null references staff (id)
);

-- -----------------------------------------------------------------------------
-- invoices
-- -----------------------------------------------------------------------------
create table if not exists invoices
(
  id       serial primary key
, datetime timestamp not null
    default current_timestamp()
, amount   decimal(15, 2) not null
    check (amount > 0.0)
, text     text null
, paid_by  int  not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- payments
-- -----------------------------------------------------------------------------
create table if not exists payments
(
  id                serial primary key
, datetime          timestamp default current_timestamp()
, type              enum('Cash'
                       , 'Card'
                       , 'Insurance') not null
, insurance_company varchar(255) null
, insurance_number  varchar(255) null
, accepted_by       int null references receptionists
, pays_for          int unique not null references invoices

, check ( (not (type = 'Insurance')) or (insurance_company is not null) )
, check ( (not (type = 'Insurance')) or (insurance_number is not null) )
);

-- -----------------------------------------------------------------------------
-- appointments
-- -----------------------------------------------------------------------------
create table if not exists appointments
(
  id         serial primary key
, doctor_id  int not null references doctors
, patient_id int not null references patients
, datetime   timestamp               not null
, location   varchar(255)            not null
, invoice_id int unique              not null
    references invoices

, unique (doctor_id, datetime)
, unique (patient_id, datetime)
, unique (datetime, location)
);

-- -----------------------------------------------------------------------------
-- meeting.redirection
-- -----------------------------------------------------------------------------
create table if not exists redirections
(
  id         serial primary key
, issue_date date not null
    default (curdate())
, directs_to int not null
    references doctors (id)
, is_made_by int not null
    references doctors (id)
, directs    int not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- in_patient_direction
-- -----------------------------------------------------------------------------
create table if not exists in_patient_directions
(
  id         serial primary key
, issue_date date                             not null
    default (curdate())
, is_made_by int                              not null
    references doctors (id)
, directs    int                              not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_places
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_places
(
  id             serial primary key
, room           varchar(32)    not null
, amount_per_day decimal(15, 2) not null
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_stay
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_stay
(
  id                 serial primary key
, place_id           int            not null references in_patient_clinic_places
, occupied_by        int            not null references patients
, invoice_id         int unique     not null references invoices
, check_in_datetime  timestamp      not null default now()
, check_out_datetime timestamp      null
, amount_per_day     decimal(15, 2) not null

, check((check_out_datetime is null) or (check_in_datetime < check_out_datetime))
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_services
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_services
(
  id           serial primary key
, service_name varchar(255) not null
, amount       decimal(15, 2)        not null
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_provided_services
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_provided_services
(
  id       serial primary key
, stay_id  int            not null references in_patient_clinic_stay
, service  int            not null references in_patient_clinic_services
, datetime timestamp      not null default current_timestamp()
, amount   decimal(15, 2) not null
);

-- -----------------------------------------------------------------------------
-- inventory_items
-- -----------------------------------------------------------------------------
create table if not exists inventory_items
(
  id                serial primary key
, name              varchar(255)                not null
, cost_per_unit     decimal(15, 2)              not null
, quantity          numeric(32, 6)              not null
, units             enum('Items'
                       , 'Litres'
                       , 'Grams')              not null
, is_consumable     bool                        not null
, category          enum('Medicine'
                       , 'Hospital stationary item'
                       , 'Electronic device'
                       , 'Pharmacy item'
                       , 'In-patient clinic inventory') not null
, need_prescription bool                        not null
, belongs_to_place  int                         null references in_patient_clinic_places
, unique (category, name)
, check ((category = 'In-patient clinic inventory') = (belongs_to_place is not null))
);

-- -----------------------------------------------------------------------------
-- inventory_items_requests
-- -----------------------------------------------------------------------------
create table if not exists inventory_items_requests
(
  id           serial primary key
, item_id      int not null
    references inventory_items
, requested_by int not null
    references staff
, status enum('Approved'
            , 'Rejected'
            , 'Pending') not null
    default 'Pending'
, approved_by  int null references inventory_managers
, datetime     timestamp                             not null
    default current_timestamp()
, quantity     numeric(32, 6)                        not null
, check ((status='Pending' and approved_by is null) or (status != 'Pending' and approved_by is not null))
);

-- -----------------------------------------------------------------------------
-- item_sales
-- -----------------------------------------------------------------------------
create table if not exists item_sales
(
  id            serial primary key
, item_id       int            not null
    references inventory_items
, quantity      numeric(32, 6) not null
, cost_per_unit decimal(15, 2) not null
, datetime      timestamp      not null
    default current_timestamp()
, sold_by       int            not null
    references pharmacists
, invoice_id    int            not null
    references invoices
);

-- -----------------------------------------------------------------------------
-- medical_records
-- -----------------------------------------------------------------------------
create table if not exists medical_records
(
  id         serial primary key
, content    text not null
, belongs_to int  not null references patients (id)
);

-- -----------------------------------------------------------------------------
-- medical_record_modifications
-- -----------------------------------------------------------------------------
create table if not exists medical_record_modifications
(
  id          serial primary key
, `change`      text not null
, change_type enum('Addition'
                 , 'Removal'
                 , 'Modification'
                 , 'Creation') not null
, date date not null
    default (current_date())
, is_made_by  int not null references staff (id)
, `modifies`    int not null references medical_records
);

-- -----------------------------------------------------------------------------
-- prescriptions
-- -----------------------------------------------------------------------------
create table if not exists prescriptions
(
  id         serial primary key
, issue_date date not null
    default (curdate())
, belongs_to int references medical_records (id)
);

-- -----------------------------------------------------------------------------
-- prescription_allowances
-- -----------------------------------------------------------------------------
create table if not exists prescription_allowances
(
  id                serial primary key
, prescription_id   int not null
    references prescriptions(id)
, inventory_item_id int not null
    references inventory_items (id)
);

-- -----------------------------------------------------------------------------
-- ambulance_calls
-- -----------------------------------------------------------------------------
create table if not exists ambulance_calls
(
  id               serial primary key
, location         point      not null
, datetime         timestamp  not null default current_timestamp()
, assigned_group   int        not null references paramedic_groups (id)
, assigned_invoice int unique not null references invoices (id)
, is_made_by       int        not null references patients (id)
);

-- -----------------------------------------------------------------------------
-- analyses
-- -----------------------------------------------------------------------------
create table if not exists analyses
(
  id serial primary key
, type enum('Blood'
          , 'Urine'
          , 'Fecal') not null
, status enum('Collected'
            , 'Proceeded') not null default 'Collected'
, result text null
, assigned_invoice   int       not null references invoices(id)
, proceeded_by       int       null references lab_technicians (id)
, requested_by       int       not null references patients (id)
, datetime_collected timestamp not null default current_timestamp()
, datetime_proceeded timestamp null

, check ((status = 'Proceeded') and (datetime_proceeded is not null)
      or (status = 'Collected') and datetime_proceeded is null)
, check ((status = 'Collected' and result is null ) or (status = 'Proceeded' and result is not null))
);
end;

call init_db();
