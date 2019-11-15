create schema if not exists tools;


create or replace function tools.exists_type(typename name)
returns bool as $$ begin
  return exists(
    select 1 as res
    from pg_type as t
    join pg_namespace as n
      on t.typnamespace = n.oid
    where t.typname = lower(typename)
      and n.nspname = 'types'
  );
end; $$ language plpgsql;


create or replace function tools.is_chat_private(chat_id integer)
    returns bool
    immutable as
$$
begin
  return exists(
    select 1 as res
    from msg.chat
    where id = chat_id
      and chat_type = 'private'
  );
end;
$$ language plpgsql;


create or replace function tools.exists_reference(
  reference_name information_schema.sql_identifier
)
returns bool as $$ begin
  return exists(
    select *
    from information_schema.referential_constraints as r
    where r.constraint_name = reference_name
  );
end; $$ language plpgsql;


create or replace function tools.is_employment_end_valid(
  user_id int, employment_start date, employment_end date
)
returns bool immutable as
  $$
  declare
    is_user_dead bool;
  begin
    select usr."user".is_dead into is_user_dead from usr."user" where id = user_id;
    return ((employment_start < employment_end) AND ((NOT is_user_dead) OR (employment_end <= now()))); -- (emp_start < emp_end) and (user_dead) -> (emp_end <= now())
end; $$ language plpgsql;


create or replace function tools.is_inventory_item_valid_for_sale(
  item_id int
)
returns bool immutable as
  $$
  begin
    return exists(
      select *
      from inventory.inventory_items as ii
      where ii.id            = item_id
        and ii.is_consumable = true
        and ii.category      = 'Pharmacy item'
    );
end; $$ language plpgsql;


create or replace function tools.can_staff_make_item_request(staff_id int)
returns bool immutable as $$ begin
  return exists(
    select *
    from usr.users_roles as ur
    where ur.is_doctor or ur.is_nurse or ur.is_lab_technician or ur.is_admin
  );
end; $$ language plpgsql;


create or replace function tools.can_patient_stay_at_in_patient_clinic(
  new_patient_id         int,
  new_place_id           int,
  new_check_in_datetime  timestamp,
  new_check_out_datetime timestamp
)
returns bool immutable as $$ begin
  return not exists(
    -- the given place is not occupied at the given time
    -- or
    -- the given person does not occupy some place at the given time
    select *
    from ipc.in_patient_clinic_stay as s
    where (s.place_id = new_place_id or s.occupied_by = new_patient_id)
      and (s.check_in_datetime, s.check_out_datetime) overlaps
          (new_check_in_datetime, coalesce(new_check_out_datetime, timestamp 'infinity'))
  );
end; $$ language plpgsql;

create or replace function tools.is_in_patient_service_valid(
  stay_id int,
  datetime timestamp
)
returns bool immutable as $$ begin
  return exists(
    select *
    from ipc.in_patient_clinic_stay as s
    where s.id = stay_id
      and datetime between s.check_in_datetime and coalesce(s.check_out_datetime, timestamp 'infinity')
  );
end; $$ language plpgsql;
