-- Query 1
select a.*
from usr.patients as p
cross join meeting.patients_last_appointments_for_query_1(p.id, '(L|M)%', '(L|M)%') as a;

-- Query 2
select
  u.first_name
, u.last_name
, r.*
from
  meeting.doctors_appointments_report((current_date - interval '1 year')::date, current_date) as r
    join usr.users as u on r.doctor_id = u.id
order by
  doctor_id, day_of_week, time_slot;

-- Query 3
select *
from usr.frequent_patients((now() - interval '1 month')::date,'now'::date);

-- Query 4
select * from finance.get_possible_profit_last_month() as profit_last_month;

-- Query 5
select * from usr.get_experiences_doctors(
  patients_per_year := 5,
  patients_total := 100,
  years_period := 10
  );
