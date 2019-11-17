-- Query 1
select a.*
from usr.patients as p
cross join meeting.patients_last_appointments_for_query_1(p.id, '(L|M)%', '(L|M)%') as a
