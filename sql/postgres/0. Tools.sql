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
