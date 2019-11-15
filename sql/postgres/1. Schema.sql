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
      create type types.Schedule as enum (
        '2/3'
      , '0'
      , '1'
      );
    end if;

    if not tools.exists_type('ContentType') then
      create type types.ContentType as enum (
        'text'
      );
    end if;

    if not tools.exists_type('ChatType') then
      create type types.ChatType as enum (
        'private'
      , 'channel'
      , 'group'
      );
    end if;

    if not tools.exists_type('DoctorSpecialization') then
      create type types.DoctorSpecialization as enum (
        'Traumatologist'
      , 'Surgeon'
      , 'Oculist'
      , 'Therapist'
      );
    end if;

    if not tools.exists_type('ChangeType') then
      create type types.ChangeType as enum (
        'Addition'
      , 'Removal'
      , 'Modification'
      , 'Creation'
      );
    end if;

    if not tools.exists_type('UnitType') then
      create type types.UnitType as enum (
          'Items'
        , 'Litres'
        , 'Grams'
      );
    end if;

    if not tools.exists_type('InventoryItemCategory') then
      create type types.InventoryItemCategory as enum (
          'Medicine'
        , 'Hospital stationary item'
        , 'Electronic device'
        , 'Pharmacy item'
      );
    end if;

    if not tools.exists_type('PaymentType') then
      create type types.PaymentType as enum (
          'Cash'
        , 'Card'
        , 'Insurance'
      );
    end if;

    if not tools.exists_type('InventoryItemApprovalStatus') then
      create type types.InventoryItemApprovalStatus as enum (
          'Approved'
        , 'Rejected'
        , 'Pending'
      );
    end if;

    if not tools.exists_type('ParamedicPosition') then
      create type types.ParamedicPosition as enum (
          'Primary'
        , 'Secondary'
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
, is_dead           bool default false
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
, employment_end   date           null check (tools.is_employment_end_valid(id, employment_start, employment_end))
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
, clinic_number  varchar(32)                not null
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
  id       int primary key references usr.staff
, position types.ParamedicPosition not null
);

-------------------------------------------------------------------------------
-- usr.paramedic_groups
-------------------------------------------------------------------------------
create table if not exists usr.paramedic_groups
(
  id serial primary key 
, is_active boolean default true
);

-------------------------------------------------------------------------------
-- usr.paramedic_group_divisions
-------------------------------------------------------------------------------
create table if not exists usr.paramedic_group_divisions
(
  id           serial primary key
, paramedic_id int references usr.paramedics (id)
, group_id     int references usr.paramedic_groups (id)
);
-------------------------------------------------------------------------------
-- usr.patients
-------------------------------------------------------------------------------
create table if not exists usr.patients
(
  id int primary key references usr.staff
);

-------------------------------------------------------------------------------
-- usr.admin
-------------------------------------------------------------------------------
create table if not exists usr.admin
(
  id int primary key references usr.staff
);

-------------------------------------------------------------------------------
-- usr.users_roles
-------------------------------------------------------------------------------
create or replace view usr.users_roles as
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
  from usr.users as u
  left join usr.patients as p
    on p.id = u.id
  left join usr.hrs as h
    on h.id = u.id
  left join usr.doctors as d
    on d.id = u.id
  left join usr.nurses as n
    on n.id = u.id
  left join usr.inventory_managers as im
    on im.id = u.id
  left join usr.pharmacists as ph
    on ph.id = u.id
  left join usr.lab_technicians as lt
    on lt.id = u.id
  left join usr.receptionists as r
    on r.id = u.id
  left join usr.paramedics as pm
    on pm.id = u.id
  left join usr.admin as a
    on a.id = u.id
;


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
, content_type types.ContentType not null
, content      varchar(255)      not null
, datetime     timestamp         not null
    check (datetime <= now())
, sent_by      int               not null
    references usr.users (id)
, sent_to      int               not null
    references msg.chats (id)
);


-------------------------------------------------------------------------------
-- msg.participate
-------------------------------------------------------------------------------
create table if not exists msg.chats_participants
(
  id                              serial primary key
, chat_id                         int not null
    references msg.chats(id)
, user_id                         int not null
    references usr.users(id)
, private_chat_participant_number bool
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
    check (date <= now())
, text         text      not null
, performed_by int       not null
    references usr.users (id)
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
, expiry date not null
    default now() + interval '10 day' check ( expiry > now() )
);


-------------------------------------------------------------------------------
-- board.modifications
-------------------------------------------------------------------------------
create table if not exists board.modifications
(
  id          serial primary key
, datetime    timestamp default now() check ( datetime <= now() )
, change      text                               not null
, change_type types.ChangeType                   not null
, modifies    int references board.messages (id) not null
, made_by     int references usr.staff (id)      not null
);


-------------------------------------------------------------------------------
-- Finance
-------------------------------------------------------------------------------
create schema if not exists finance;

-------------------------------------------------------------------------------
-- finance.invoices
-------------------------------------------------------------------------------
create table if not exists finance.invoices
(
  id       serial primary key
, datetime timestamp default now() check ( datetime <= now() )
, amount   decimal                          not null check ( amount > 0 )
, text     text                             null
, paid_by  int references usr.patients (id) not null
);

-------------------------------------------------------------------------------
-- finance.payments
-------------------------------------------------------------------------------
create table if not exists finance.payments
(
  id                serial primary key
, datetime          timestamp default now() check ( datetime <= now())
, type              types.PaymentType not null
, insurance_company varchar(255) check ( type = 'Insurance' AND insurance_company is not null )
, insurance_number  varchar(255) check ( type = 'Insurance' AND insurance_number is not null )
, accepted_by       int references usr.receptionists (id)
, pays_for          int references finance.invoices (id)
);


-------------------------------------------------------------------------------
-- Service
-------------------------------------------------------------------------------
create schema if not exists service;

-------------------------------------------------------------------------------
-- service.appointments
-------------------------------------------------------------------------------
create table if not exists service.appointments
(
  id         serial primary key
, doctor_id  int references usr.doctors  not null
, patient_id int references usr.patients not null
, datetime   timestamp                   not null
, location   varchar(255)                not null
, invoice_id int                         not null
    references finance.invoices

, unique (doctor_id, datetime)
, unique (patient_id, datetime)
, unique (datetime, location)
);

-------------------------------------------------------------------------------
-- service.redirection
-------------------------------------------------------------------------------
create table if not exists service.redirections
(
  id         serial primary key
, issue_date date not null
    default now() check (issue_date <= now())
, directs_to int not null
    references usr.doctors (id)
, is_made_by int not null
    references usr.doctors (id)
, directs    int not null
    references usr.patients (id)
);

-------------------------------------------------------------------------------
-- service.in_patient_direction
-------------------------------------------------------------------------------
create table if not exists service.in_patient_directions
(
  id         serial primary key
, issue_date date                             not null
    default now() check ( issue_date <= now() )
, is_made_by int                              not null
    references usr.doctors (id)
, directs    int                              not null
    references usr.patients (id)
);

-------------------------------------------------------------------------------
-- Inventory
-------------------------------------------------------------------------------
create schema if not exists inventory;

-------------------------------------------------------------------------------
-- inventory.inventory_items
-------------------------------------------------------------------------------
create table if not exists inventory.inventory_items
(
  id                serial primary key
, name              varchar(255)                not null
, cost_per_unit     money                       not null
, quantity          numeric(32, 6)              not null
, units             types.UnitType              not null
, is_consumable     bool                        not null
, category          types.InventoryItemCategory not null
, need_prescription bool                        not null

, unique (category, name)
);

-------------------------------------------------------------------------------
-- inventory.inventory_items_requests
-------------------------------------------------------------------------------
create table if not exists inventory.inventory_items_requests
(
  id           serial primary key
, item_id      int not null
    references inventory.inventory_items
, requested_by int                                      not null
    references usr.staff
    check (tools.can_staff_make_item_request(requested_by))
, status       types.InventoryItemApprovalStatus        not null
    default 'Pending'
, approved_by  int references usr.inventory_managers    null
, datetime     timestamp                                not null
    default now() check (datetime >= now())
, units        types.UnitType                           not null
, quantity     numeric(32, 6)                           not null
);

-------------------------------------------------------------------------------
-- inventory.item_sales
-------------------------------------------------------------------------------
create table if not exists inventory.item_sales
(
  id serial primary key
, item_id      int not null
    references inventory.inventory_items
    check (tools.is_inventory_item_valid_for_sale(item_id))
, units         types.UnitType not null
, quantity      numeric(32, 6) not null
, cost_per_unit money          not null
, datetime      timestamp      not null
    default now() check (datetime >= now())
, sold_by       int            not null
    references usr.pharmacists
, invoice_id    int            not null
    references finance.invoices
);


-------------------------------------------------------------------------------
-- In-patient clinic
-------------------------------------------------------------------------------
create schema if not exists ipc;

-------------------------------------------------------------------------------
-- ipc.in_patient_clinic_places
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Medical data
-------------------------------------------------------------------------------
create schema if not exists medical_data;

-------------------------------------------------------------------------------
-- medical_data.medical_records
-------------------------------------------------------------------------------
create table if not exists medical_data.medical_records
(
  id         serial primary key
, content    text                             not null
, belongs_to int references usr.patients (id) not null
);

-------------------------------------------------------------------------------
-- medical_data.medical_record_modifications
-------------------------------------------------------------------------------
create table if not exists medical_data.medical_record_modifications
(
  id          serial primary key
, change      text                          not null
, change_type types.ChangeType              not null
, date        date                          not null
    default now() check ( date <= now() )
, is_made_by  int references usr.staff (id) not null
);

-------------------------------------------------------------------------------
-- medical_data.prescriptions
-------------------------------------------------------------------------------
create table if not exists medical_data.prescriptions
(
  id serial primary key
, issue_date date not null
    default now() check ( issue_date <= now() )
);

-------------------------------------------------------------------------------
-- medical_data.prescription_allowances
-------------------------------------------------------------------------------
create table if not exists medical_data.prescription_allowances
(
  id                serial primary key
, prescription_id   int not null
    references medical_data.prescriptions(id)
, inventory_item_id int not null
    references inventory.inventory_items (id)
    check (tools.is_inventory_item_valid_for_sale(inventory_item_id))
);

-------------------------------------------------------------------------------
-- medical_data.ambulance_calls
-------------------------------------------------------------------------------
create table if not exists medical_data.ambulance_calls
(
  id               serial primary key
, location         point     not null
, datetime         timestamp not null default now() check ( datetime < now() )
, assigned_group   int       not null references usr.paramedic_groups (id)
, assigned_invoice int       not null references finance.invoices (id)
, is_made_by       int       not null references usr.patients (id)
);