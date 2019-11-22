-- Query 1
select a.*
from usr.patients as p
cross join meeting.patients_last_appointments_for_query_1(p.id, '(L|M)%', '(L|M)%') as a;

-- Query 2
select r.*
from meeting.doctors_appointments_report('2018-12-01', '2019-12-01') as r;

-- Query 3
select *
from usr.frequent_patients((now() - interval '1 month')::date,'now'::date);

-- Query 4
select * from finance.get_possible_profit_last_month() as profit_last_month;

-- Query 5
select * from usr.get_experiences_doctors();
