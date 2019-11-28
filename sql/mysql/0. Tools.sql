SET GLOBAL log_bin_trust_function_creators = 1;

drop function if exists implication;
create function implication(x bool, y bool)
    returns bool deterministic
    return (not x) or y;

drop function if exists is_chat_private;
create function is_chat_private(chat_id integer)
    returns bool
begin
    return exists(
            select 1 as res
            from chats
            where id = chat_id
              and chat_type = 'private'
        );
end;

drop function if exists exists_reference;
create function exists_reference(
    reference_name varchar(64)
)
    returns bool
begin
    return exists(
            select *
            from information_schema.referential_constraints as r
            where r.constraint_name = reference_name
        );
end;

drop function if exists is_employment_end_valid;
create function is_employment_end_valid(user_id int, employment_start date, employment_end date)
    returns bool
begin
    declare is_user_dead bool;
    select is_dead into is_user_dead from users where id = user_id;
    return ((employment_start < employment_end) AND (implication(is_user_dead, employment_end <= now())));
end;

drop function if exists is_inventory_item_valid_for_sale;
create function is_inventory_item_valid_for_sale(
    item_id int
)
    returns bool
begin
    return exists(
            select *
            from inventory_items as ii
            where ii.id = item_id
              and ii.is_consumable = true
              and ii.category = 'Pharmacy item'
        );
end;

drop function if exists can_staff_make_item_request;
create function can_staff_make_item_request(staff_id int)
    returns bool
begin
    return exists(
            select *
            from users_roles as ur
            where ur.user_id = staff_id
              and (ur.is_doctor or ur.is_nurse or ur.is_lab_technician or ur.is_admin)
        );
end;

drop function if exists cpsaips;
# can_patient_stay_at_in_patient_clinic
create function cpsaips(new_patient_id int,
                        new_place_id int,
                        new_check_in_datetime timestamp,
                        new_check_out_datetime timestamp)
    returns bool
begin
    return not exists(
        -- the given place is not occupied at the given time
        -- or
        -- the given person does not occupy some place at the given time
            select *
            from in_patient_clinic_stay as s
            where (s.place_id = new_place_id or s.occupied_by = new_patient_id)
              and not
                ((s.check_in_datetime <= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                  s.check_out_datetime >= new_check_in_datetime)
                    OR (s.check_in_datetime >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        s.check_in_datetime <= new_check_in_datetime AND s.check_out_datetime <= new_check_in_datetime)
                    OR (s.check_out_datetime <= new_check_in_datetime AND
                        s.check_out_datetime >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        s.check_in_datetime <= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')))
                    OR (start_date >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        start_date <= new_check_in_datetime))
        );
end;


drop function if exists is_in_patient_service_valid;
create function is_in_patient_service_valid(stay_id int,
                                            datetime timestamp)
    returns bool
begin
    return exists(
            select *
            from in_patient_clinic_stay as s
            where s.id = stay_id
              and datetime between s.check_in_datetime and coalesce(s.check_out_datetime, timestamp('9999-12-31 23:59:59'))
        );
end;

drop function if exists number_of_weeks_between;
create function number_of_weeks_between(begin_date date, end_date date)
    returns int
begin
    return (end_date - begin_date) / 7;
end;


drop function if exists absolute_number_of_weeks;
create function absolute_number_of_weeks(end_date date)
    returns int
begin
    return number_of_weeks_between(FROM_UNIXTIME(UNIX_TIMESTAMP(0)), end_date);
end;


drop function if exists get_age;
create function get_age(birth_date date)
    returns int
begin
    return timestampdiff(year, birth_date, now());
end;


drop function if exists charge;
create function charge(age int, appointment_count int)
    returns decimal(15, 2)
begin
    return
        case
            when age < 50 and appointment_count < 3 then cast(200 as decimal(15, 2))
            when age < 50 and appointment_count >= 3 then cast(250 as decimal(15, 2))
            when age >= 50 and appointment_count < 3 then cast(450 as decimal(15, 2))
            when age >= 50 and appointment_count >= 3 then cast(500 as decimal(15, 2))
            end;
end;


# drop function if exists time_slots_for_range;
# create function time_slots_for_range(begin_time timestamp, end_time timestamp, time_slot_size interval)
#   returns table
# (
#     time_slot_begin timestamp
#     , time_slot_end timestamp
# );
# begin
#   return query
#     with recursive time_slots_recursive as
#     (
#       select begin_time as time_slot_begin
#            , begin_time + time_slot_size as time_slot_end
#
#       union
#
#       select r.time_slot_end as time_slot_begin
#            , r.time_slot_end + time_slot_size as time_slot_end
#       from time_slots_recursive as r
#       where (r.time_slot_end + time_slot_size) <= end_time
#     )
#     select t.time_slot_begin
#          , t.time_slot_end
#     from time_slots_recursive as t;
# end;
# $$;

drop function if exists is_int;
create function is_int(number numeric)
    returns bool
begin
    return number = floor(number);
end;


drop function if exists is_item_quantity_valid_for_unit;
create function is_item_quantity_valid_for_unit(number numeric, unit text)
    returns bool
begin
    return
        case
            when number is null then False
            when unit is null then False
            when unit = 'Items' then is_int(number)
            else True
            end;
end;

drop function if exists is_item_quantity_valid;
create function is_item_quantity_valid(number numeric, item_id int)
    returns bool
begin
    declare
        unit_type text;
    select units
    into unit_type
    from inventory.inventory_items
    where id = item_id;

    return is_item_quantity_valid_for_unit(number, unit_type);
end;

drop function if exists can_item_be_taken;
create function can_item_be_taken(requested_amount numeric, item_id int)
    returns bool
begin
    declare
        available_amount numeric;
    select quantity
    into available_amount
    from inventory.inventory_items
    where id = item_id;

    return available_amount <= requested_amount;
end;
