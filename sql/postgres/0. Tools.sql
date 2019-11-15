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


create or replace function tools.can_staff_make_item_request(staff_id int)
returns bool immutable as $$ begin
  return exists(
    select *
    from usr.users_roles as ur
    where ur.is_doctor or ur.is_nurse or ur.is_lab_technician or ur.is_admin
  );
end; $$ language plpgsql;
