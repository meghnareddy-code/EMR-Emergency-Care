USE emergencyehr2;


-- delete Clinical Info for a patient(only admin and doctor who treated can delete the record)
DELIMITER //
CREATE PROCEDURE delete_clinical_info(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_visit_id INT
)
BEGIN
    DECLARE user_role VARCHAR(50);
    DECLARE provider_first_name VARCHAR(50);
    DECLARE provider_id INT;
    DECLARE user_id_value INT;
    DECLARE previous_value VARCHAR(100);
    DECLARE new_value VARCHAR(100);

    SELECT role, user_id INTO user_role, user_id_value FROM USERS WHERE username = p_username;

    IF user_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: User does not exist.';
    ELSE
        SELECT COUNT(*) INTO @password_matched
        FROM USERS
        WHERE username = p_username AND password = p_password;

        IF @password_matched = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid password.';
        ELSEIF user_role = 'admin_doctor' THEN
            SELECT JSON_OBJECT('discharge_diagnosis', IFNULL(discharge_diagnosis, '')) INTO previous_value FROM CLINICAL_INFORMATION WHERE visit_id = p_visit_id;
            DELETE FROM CLINICAL_INFORMATION WHERE visit_id = p_visit_id;
            SELECT user_id INTO user_id_value FROM USERS WHERE username = p_username;
            INSERT INTO LOGT (user_id, table_name, action_type, action_time, previous_value, new_value) VALUES (user_id_value, 'CLINICAL_INFORMATION', 'DELETE', NOW(), previous_value, NULL);
            SELECT CONCAT('Clinical information with visit_id = ', p_visit_id, ' deleted successfully.') AS message;
        ELSE
            SELECT p.first_name INTO provider_first_name
            FROM PROVIDERS p
            INNER JOIN VISITS v ON p.provider_id = v.provider_id
            WHERE v.visit_id = p_visit_id;

            IF provider_first_name IS NULL THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Visit does not exist.';
            ELSEIF provider_first_name = p_username THEN
                SELECT JSON_OBJECT('discharge_diagnosis', IFNULL(discharge_diagnosis, '')) INTO previous_value FROM CLINICAL_INFORMATION WHERE visit_id = p_visit_id;
                DELETE FROM CLINICAL_INFORMATION WHERE visit_id = p_visit_id;
                SELECT user_id INTO user_id_value FROM USERS WHERE username = p_username;
                INSERT INTO LOGT (user_id, table_name, action_type, action_time, previous_value, new_value) VALUES (user_id_value, 'CLINICAL_INFORMATION', 'DELETE', NOW(), previous_value, NULL);
                SELECT CONCAT('Clinical information with visit_id = ', p_visit_id, ' deleted successfully.') AS message;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: User is not authorized to perform this action.';
            END IF;
        END IF;
    END IF;
END//

DELIMITER ;
CALL delete_clinical_info('admin', 'meghnaadmin', 1);
CALL delete_clinical_info('Bob', 'password6', 9);


-- Create a Procedure to fetch provider information(only admin and doctor can see the results)
DELIMITER //
CREATE PROCEDURE fetch_provider_info(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_provider_id INT
)
BEGIN
    DECLARE v_user_id INT;
    SELECT user_id INTO v_user_id
    FROM USERS
    WHERE username = p_username AND password = p_password and role like '%doctor';

    IF v_user_id IS NOT NULL THEN
        SELECT * FROM PROVIDERS WHERE provider_id = p_provider_id;
    ELSE
        SELECT 'Access Denied' AS Message;
    END IF;
END //
DELIMITER ;
call emergencyehr2.fetch_provider_info('admin', 'meghnaadmin', 1);
call emergencyehr2.fetch_provider_info('Meghna', 'password1', 2);
call emergencyehr2.fetch_provider_info('Sahithi', 'password2', 5);








-- Create a procedure to check a user is authorized or not.
DELIMITER //
CREATE PROCEDURE CheckUserAuthorization(
  IN p_username VARCHAR(50),
  IN p_password VARCHAR(50)
)
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) INTO v_count
  FROM USERS
  WHERE username = p_username AND password = p_password;

  IF v_count > 0 THEN
    SELECT 'User is authorized' AS message;
  ELSE
    SELECT 'User is not authorized' AS message;
  END IF;
  
END //
DELIMITER ;
call emergencyehr2.CheckUserAuthorization('admin', 'meghnaadmin');
call emergencyehr2.CheckUserAuthorization('Meghna', 'password1');
call emergencyehr2.CheckUserAuthorization('Sahithi', 'password2');

-- Create  a procedure to update the patient city if the user was admin
DELIMITER //
CREATE PROCEDURE update_patient_city_Authorization (IN patient_id INT, IN new_city VARCHAR(50), IN admin_username VARCHAR(50), IN admin_password VARCHAR(50))
BEGIN
  DECLARE admin_count INT;
  DECLARE previous_city VARCHAR(50);
  SELECT COUNT(*) INTO admin_count
  FROM USERS
  WHERE username = admin_username AND password = admin_password AND role = 'admin_doctor';

  IF admin_count > 0 THEN
    SELECT city INTO previous_city
    FROM ADDRESSES
    JOIN PATIENTS ON ADDRESSES.address_id = PATIENTS.address_id
    WHERE PATIENTS.patient_id = patient_id;

    UPDATE ADDRESSES
    JOIN PATIENTS ON ADDRESSES.address_id = PATIENTS.address_id
    SET ADDRESSES.city = new_city
    WHERE PATIENTS.patient_id = patient_id;

    INSERT INTO LOGT (user_id, table_name, previous_value, new_value, action_type, action_time)
    SELECT user_id, 'PATIENTS', JSON_OBJECT('patient_id', patient_id, 'city', previous_city), JSON_OBJECT('patient_id', patient_id, 'city', new_city), 'UPDATE', NOW()
    FROM USERS
    WHERE username = admin_username;

    SELECT 'Patient city updated successfully' AS message;
  ELSE
    SELECT 'Only the admin is allowed to update the patient city' AS message;
  END IF;
END //
DELIMITER ;
call emergencyehr2.update_patient_city_Authorization(1, 'St.Lousis', 'admin', 'meghnaadmin');


-- create a procedure to delete bed if the user was admin 
DELIMITER //
CREATE PROCEDURE delete_bed(
  IN p_username VARCHAR(50),
  IN p_password VARCHAR(50),
  IN p_bed_id INT
)
BEGIN
    DECLARE user_role VARCHAR(50);
    DECLARE prev_bed JSON;
    DECLARE new_bed JSON;
    SELECT role INTO user_role FROM users WHERE username = p_username AND password = p_password;
    IF user_role = 'admin_doctor' THEN
        SELECT JSON_OBJECT('bed_id', bed_id, 'facility_id', facility_id, 'bed_number', bed_number, 'bed_type', bed_type) INTO prev_bed
        FROM BEDS
        WHERE bed_id = p_bed_id;
        DELETE FROM BEDS WHERE bed_id = p_bed_id;
        SET new_bed = NULL;
        INSERT INTO LOGT (user_id, table_name, action_type, previous_value, new_value, action_time)
        VALUES ((SELECT user_id FROM USERS WHERE username = p_username AND password = p_password),'BEDS','DELETE',prev_bed,new_bed,NOW());
        SELECT 'Bed deleted successfully' AS message;
    ELSE
        SELECT 'User does not have sufficient privileges to delete bed' AS message;
    END IF;
END //
DELIMITER ;
call emergencyehr2.delete_bed('Meghna', 'Password1', 5);


-- only Doctors and admin can see the patient details
DELIMITER //
CREATE PROCEDURE view_patient_details(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_patient_id INT
)
BEGIN
    DECLARE v_user_id INT;
    SELECT user_id INTO v_user_id
    FROM USERS
    WHERE username = p_username AND password = p_password and role like '%doctor';
    IF v_user_id IS NOT NULL THEN
        SELECT *
        FROM PATIENTS
        WHERE patient_id = p_patient_id;
    ELSE
        SELECT 'Access Denied. Invalid username or password.' AS Message;
    END IF;
END //
DELIMITER ;
call emergencyehr2.view_patient_details('admin', 'meghnaadmin', 1);
call emergencyehr2.view_patient_details('Shiny', 'password3', 2);
call emergencyehr2.view_patient_details('Sahithi', 'password2', 5);


-- Calculate the total patient Bill amount(only admin and doctor can see the results)
DELIMITER //

CREATE PROCEDURE calculate_patient_billing(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_patient_id INT
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_total_amount DECIMAL(10, 2);
    SELECT user_id INTO v_user_id
    FROM USERS
    WHERE username = p_username AND password = p_password AND role LIKE '%doctor';

    IF v_user_id IS NOT NULL THEN
        SELECT SUM(billing_amount) INTO v_total_amount
        FROM BILLING
        INNER JOIN VISITS ON BILLING.visit_id = VISITS.visit_id
        WHERE VISITS.patient_id = p_patient_id;
        SELECT v_total_amount AS total_amount;
    ELSE
        SELECT 'Access Denied.' AS Message;
    END IF;
END //
DELIMITER ;
call emergencyehr2.calculate_patient_billing('admin', 'meghnaadmin', 1);
call emergencyehr2.calculate_patient_billing('Sahithi', 'password2', 2);
call emergencyehr2.calculate_patient_billing('Shiny', 'password3', 3);


-- create a procedure to update symptom of a patient (only admin and doctor can update the symptoms)
DELIMITER //

CREATE PROCEDURE updateSymptom(
  IN username VARCHAR(50),
  IN password VARCHAR(50),
  IN clinical_info_id INT,
  IN new_symptom VARCHAR(100)
)
BEGIN
  DECLARE user_id INT;
  DECLARE old_symptom VARCHAR(100);

  SELECT u.user_id INTO user_id
  FROM USERS u
  WHERE u.username = username AND u.password = password AND u.role LIKE '%doctor'
  LIMIT 1;

  IF user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid username or password. Access denied.';
  END IF;

  SELECT symptom INTO old_symptom
  FROM CLINICAL_INFORMATION
  WHERE clinical_info_id = clinical_info_id
  LIMIT 1;

  UPDATE CLINICAL_INFORMATION
  SET symptom = new_symptom
  WHERE clinical_info_id = clinical_info_id
  LIMIT 1;

  INSERT INTO LOGT (user_id, table_name, action_type, previous_value, new_value, action_time)
  VALUES (user_id,'CLINICAL_INFORMATION','UPDATE',JSON_OBJECT('clinical_info_id', clinical_info_id,'symptom', old_symptom),JSON_OBJECT('clinical_info_id', clinical_info_id,'symptom', new_symptom),NOW());

END //
DELIMITER ;
call emergencyehr2.updateSymptom('admin', 'meghnaadmin', 2, 'new_sym');
call emergencyehr2.updateSymptom('Shiny', 'password3', 3, 'updated_new_symptom');


-- Create a procedure to update Billing amount(only admin and biller can can update the billing amount)
DELIMITER //
CREATE PROCEDURE updateBillingAmount(
  IN username VARCHAR(50),
  IN password VARCHAR(50),
  IN billing_id INT,
  IN new_amount DECIMAL(10, 2)
)
BEGIN
  DECLARE user_id INT;
  DECLARE old_amount DECIMAL(10, 2);

  SELECT u.user_id INTO user_id
  FROM USERS u
  WHERE u.username = username AND u.password = password AND (u.role = 'admin_doctor' OR u.role = 'biller')
  LIMIT 1;

  IF user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid username or password. Access denied.';
  END IF;

  SELECT billing_amount INTO old_amount
  FROM BILLING
  WHERE billing_id = billing_id
  LIMIT 1;

  UPDATE BILLING
  SET billing_amount = new_amount
  WHERE billing_id = billing_id
  LIMIT 1;

  INSERT INTO LOGT (user_id, table_name, action_type, previous_value, new_value, action_time)
  VALUES (user_id,'BILLING','UPDATE',JSON_OBJECT('billing_id', billing_id,'billing_amount', old_amount),JSON_OBJECT('billing_id', billing_id,'billing_amount', new_amount),NOW());
END //
DELIMITER ;

call emergencyehr2.updateBillingAmount('admin', 'meghnaadmin', 1, 101010);
call emergencyehr2.updateBillingAmount('ram', 'password15', 2, 81118);


-- Triggers

DELIMITER //
CREATE TRIGGER INSERT_TRIGGER1
AFTER INSERT ON visits
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Visits', 'INSERT', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DELETE_TRIGGER1
AFTER DELETE ON visits
FOR EACH ROW
BEGIN
    INSERT INTO LOGT(log_id, table_name, action_type, action_time) 
    VALUES (@log_id, 'Visits', 'DELETE', NOW());
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER INSERT_TRIGGER2
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Appointments', 'INSERT', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DELETE_TRIGGER2
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    INSERT INTO LOGT(log_id, table_name, action_type, action_time) 
    VALUES (@log_id, 'Appointments', 'DELETE', NOW());
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER INSERT_TRIGGER3
AFTER INSERT ON facilities
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Facilities', 'INSERT', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DELETE_TRIGGER3
AFTER DELETE ON facilities
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Facilities', 'DELETE', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER INSERT_TRIGGER4
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Orders', 'INSERT', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DELETE_TRIGGER4
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Orders', 'DELETE', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER INSERT_TRIGGER5
AFTER INSERT ON supplies
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Supplies', 'INSERT', NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DELETE_TRIGGER5
AFTER DELETE ON supplies
FOR EACH ROW
BEGIN
INSERT INTO LOGT (log_id, table_name, action_type, action_time)
VALUES (@log_id, 'Supplies', 'DELETE', NOW());
END//
DELIMITER ;

-- Index for the address_id column in the ADDRESSES table
CREATE INDEX idx_addresses_address_id1 ON ADDRESSES (address_id);

-- Index for the insurance_id column in the INSURANCES table
CREATE INDEX idx_insurances_insurance_id1 ON INSURANCES (insurance_id);

-- Index for the provider_id column in the PROVIDERS table
CREATE INDEX idx_providers_provider_id1 ON PROVIDERS (provider_id);

-- Index for the facility_id column in the FACILITIES table
CREATE INDEX idx_facilities_facility_id1 ON FACILITIES (facility_id);

-- Index for the patient_id column in the PATIENTS table
CREATE INDEX idx_patients_patient_id1 ON PATIENTS (patient_id);

-- Index for the visit_id column in the VISITS table
CREATE INDEX idx_visits_visit_id1 ON VISITS (visit_id);

-- Index for the visit_id column in the CLINICAL_INFORMATION table
CREATE INDEX idx_clinical_info_visit_id1 ON CLINICAL_INFORMATION (visit_id);

-- Index for the patient_id column in the APPOINTMENTS table
CREATE INDEX idx_appointments_patient_id1 ON APPOINTMENTS (patient_id);

-- Index for the provider_id column in the APPOINTMENTS table
CREATE INDEX idx_appointments_provider_id1 ON APPOINTMENTS (provider_id);

-- Index for the facility_id column in the APPOINTMENTS table
CREATE INDEX idx_appointments_facility_id1 ON APPOINTMENTS (facility_id);

-- Index for the visit_id column in the ORDERS table
CREATE INDEX idx_orders_visit_id1 ON ORDERS (visit_id);

-- Index for the facility_id column in the BEDS table
CREATE INDEX idx_beds_facility_id1 ON BEDS (facility_id);

-- Index for the facility_id column in the SUPPLIES table
CREATE INDEX idx_supplies_facility_id1 ON SUPPLIES (facility_id);

-- Index for the visit_id column in the BILLING table
CREATE INDEX idx_billing_visit_id1 ON BILLING (visit_id);

-- Index for the user_id column in the LOGT table
CREATE INDEX idx_logt_user_id1 ON LOGT (user_id);




-- View to check patient vists and facility
CREATE VIEW PATIENT_VISITS_VIEW AS
SELECT PATIENTS.first_name, PATIENTS.last_name, VISITS.visit_time, FACILITIES.facility_name
FROM PATIENTS
INNER JOIN VISITS ON PATIENTS.patient_id = VISITS.patient_id
INNER JOIN FACILITIES ON VISITS.facility_id = FACILITIES.facility_id;
SELECT * FROM emergencyehr2.patient_visits_view;













-- View to retrieve patient information along with their address and insurance details
CREATE VIEW patient_info AS
SELECT P.patient_id,P.first_name,P.last_name,P.date_of_birth,P.gender,A.street_address,A.city,A.state,A.zip_code,I.insurance_company_name,I.policy_number
FROM
  PATIENTS P
  INNER JOIN ADDRESSES A ON P.address_id = A.address_id
  INNER JOIN INSURANCES I ON P.insurance_id = I.insurance_id;
SELECT * FROM emergencyehr2.patient_info;





-- View to show visit details along with patient and provider information
CREATE VIEW visit_details AS
SELECT v.visit_id, v.visit_time, p.first_name AS patient_first_name, p.last_name AS patient_last_name, pr.first_name AS provider_first_name, pr.last_name AS provider_last_name
FROM VISITS v
JOIN PATIENTS p ON v.patient_id = p.patient_id
JOIN PROVIDERS pr ON v.provider_id = pr.provider_id;
SELECT * FROM emergencyehr2.visit_details;





-- View to show facility details along with the number of beds available:
CREATE VIEW facility_beds AS
SELECT f.facility_id, f.facility_name, f.facility_type, COUNT(b.bed_id) AS beds_available
FROM FACILITIES f
LEFT JOIN BEDS b ON f.facility_id = b.facility_id
GROUP BY f.facility_id, f.facility_name, f.facility_type;
SELECT * FROM emergencyehr2.facility_beds;





-- View to show log details along with the username of the user who performed the action
CREATE VIEW log_details AS
SELECT l.log_id, u.username, l.table_name, l.action_type, l.action_time
FROM LOGT l
JOIN USERS u ON l.user_id = u.user_id;
SELECT * FROM emergencyehr2.log_details;


