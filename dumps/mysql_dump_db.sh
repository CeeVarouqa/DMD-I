mysqldump -ppass --routines mysql users staff hrs doctors nurses doctors_nurses inventory_managers pharmacists lab_technicians receptionists paramedics paramedic_groups paramedic_group_divisions patients admins users_roles chats chats_messages chats_participants logs board_messages board_modifications invoices payments appointments redirections in_patient_directions in_patient_clinic_places in_patient_clinic_stay in_patient_clinic_services in_patient_clinic_provided_services inventory_items inventory_items_requests item_sales medical_records medical_record_modifications prescriptions prescription_allowances ambulance_calls analyses > /tmp/mysql_db_dump.sql
