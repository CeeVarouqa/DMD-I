create or replace function meeting.patients_last_appointments(pat_id integer)
  returns table
          (
            appointment_id integer,
            doctor_id integer,
            patient_id integer,
            appointment_datetime timestamp,
            appointment_location varchar(255)
          )
  immutable
  language plpgsql
as
$$
begin
  return query
    with ranked_appointments as (
      select a.id
           , a.doctor_id
           , a.patient_id
           , a.datetime
           , a.location
           , rank() over (order by a.datetime::date desc) as rank
      from meeting.appointments as a
      where a.patient_id = pat_id
    )
    select ra.id, ra.doctor_id, ra.patient_id, ra.datetime, ra.location
    from ranked_appointments as ra
    where ra.rank = 1;
end;
$$;


create or replace function meeting.patients_last_appointments_for_query_1(pat_id integer, first_name_pat text,
  last_name_pat text)
  returns table
          (
            appointment_id int
          , doctor_id int
          , patient_id int
          , appointment_datetime timestamp
          , appointment_location varchar
          , first_name varchar
          , last_name varchar
          , is_dead bool
          , email varchar
          , clinic_number varchar
          )
  immutable
  language plpgsql
as
$$
begin
  return query
    select a.appointment_id, a.doctor_id, a.patient_id, a.appointment_datetime, a.appointment_location,
           u.first_name, u.last_name, u.is_dead, u.email, d.clinic_number
    from meeting.patients_last_appointments(pat_id) as a
    join usr.users as u
      on u.id = a.doctor_id
    join usr.doctors as d
      on d.id = a.doctor_id
    where tools.xor(
       u.first_name similar to first_name_pat,
       u.last_name  similar to last_name_pat
    );
end;
$$;

create or replace function meeting.doctors_appointments_report(begin_date date, end_date date)
  returns table
          (
            doctor_id int
          , visits_total_number int
          , avg_visits_per_week numeric
          )
  immutable
  language plpgsql
as
$$
begin
  return query
    with doctors_weeks as
    (
      select a.doctor_id
           , tools.absolute_number_of_weeks(datetime::date) as abs_weeks
      from meeting.appointments as a
      where a.datetime::date between begin_date and end_date
    ),
    doctors_visits as
    (
      select distinct dw.doctor_id
           , dw.abs_weeks
           , count(*) over(partition by dw.doctor_id) as visits_total_number
           , count(*) over(partition by dw.doctor_id, dw.abs_weeks) as visits_per_week
      from doctors_weeks as dw
    )
    select dv.doctor_id
         , dv.visits_total_number::int
         , avg(dv.visits_per_week) as avg_visits_per_week
    from doctors_visits as dv
    group by dv.doctor_id, dv.visits_total_number;
end;
$$;

create or replace function finance.get_possible_profit_last_month()
  returns money
  language sql
as
$$
with
  appointment_counts as
    (
      select
        patient_id
      , count(id) as appointments_count
      from
        meeting.appointments
      where
        datetime between date_trunc('month', current_date - interval '1 month') and date_trunc('month', current_date)
      group by
        patient_id
    ),
  collapsed_data as
    (
      select
        a.patient_id
      , a.appointments_count
      , tools.get_age(u.birth_date) as age
      from
        appointment_counts as a
          join usr.users as u on a.patient_id = u.id
    )
select sum(tools.charge(age, appointments_count))
from
  collapsed_data;
$$;
