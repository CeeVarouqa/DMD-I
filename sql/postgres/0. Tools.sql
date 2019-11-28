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

create or replace function tools.xor(x bool, y bool)
returns bool immutable as $$ begin
  return (not x and y) or (x and not y);
end; $$ language plpgsql;


create or replace function tools.implication(x bool, y bool)
returns bool immutable as $$ begin
  return (not x) or y;
end; $$ language plpgsql;

create or replace function tools.is_chat_private(chat_id integer)
    returns bool
    immutable as
$$
begin
  return exists(
    select 1 as res
    from msg.chats
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
    select is_dead into is_user_dead from usr.users where id = user_id;
    return ((employment_start < employment_end) AND (tools.implication(is_user_dead, employment_end <= now())));
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
    where ur.user_id = staff_id
      and (ur.is_doctor or ur.is_nurse or ur.is_lab_technician or ur.is_admin)
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

create or replace function tools.number_of_weeks_between(begin_date date, end_date date)
returns int immutable as $$ begin
  return (end_date - begin_date) / 7;
end; $$ language plpgsql;


create or replace function tools.absolute_number_of_weeks(end_date date)
returns int immutable as $$ begin
  return tools.number_of_weeks_between('epoch'::date, end_date);
end; $$ language plpgsql;


create or replace function tools.get_age(birth_date date)
returns int as $$ begin
  return date_part('year', age(birth_date));
end; $$ language plpgsql;


create or replace function tools.charge(age int, appointment_count int)
returns money as $$ begin
return
  case
    when age < 50 and appointment_count < 3 then money(200)
    when age < 50 and appointment_count >= 3 then money(250)
    when age >= 50 and appointment_count < 3 then money(400)
    when age >= 50 and appointment_count >= 3 then money(500)
  end;
end; $$ language plpgsql;


create or replace function tools.time_slots_for_range(begin_time timestamp, end_time timestamp, time_slot_size interval)
  returns table
    (
      time_slot_begin timestamp
    , time_slot_end timestamp
    )
  immutable
  language plpgsql
as
$$
begin
  return query
    with recursive time_slots_recursive as
    (
      select begin_time as time_slot_begin
           , begin_time + time_slot_size as time_slot_end

      union

      select r.time_slot_end as time_slot_begin
           , r.time_slot_end + time_slot_size as time_slot_end
      from time_slots_recursive as r
      where (r.time_slot_end + time_slot_size) <= end_time
    )
    select t.time_slot_begin
         , t.time_slot_end
    from time_slots_recursive as t;
end;
$$;

create or replace function tools.is_int(number numeric)
  returns bool
  immutable
  language plpgsql
as
$$
begin
  return number = number::int;
end;
$$;

create or replace function tools.is_item_quantity_valid_for_unit(number numeric, unit types.UnitType)
  returns bool
  immutable
  language plpgsql
as
$$
begin
  return
    case
      when number is null then False
      when unit is null then False
      when unit = 'Items' then tools.is_int(number)
      else True
      end;
end;
$$;

create or replace function tools.is_item_quantity_valid(number numeric, item_id int)
  returns bool
  immutable
  language plpgsql
as
$$
declare
  unit_type types.UnitType;
begin
  select
    units
  into unit_type
  from
    inventory.inventory_items
  where
    id = item_id;

  return tools.is_item_quantity_valid_for_unit(number, unit_type);
end;
$$;

create or replace function tools.can_item_be_taken(requested_amount numeric, item_id int)
  returns bool
  immutable
  language plpgsql
as
$$
declare
  available_amount numeric;
begin
  select
    quantity
  into available_amount
  from
    inventory.inventory_items
  where
    id = item_id;

  return available_amount <= requested_amount;
end;
$$;