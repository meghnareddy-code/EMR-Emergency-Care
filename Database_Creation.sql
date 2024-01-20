CREATE DATABASE emergencyehr;

USE emergencyehr;



CREATE TABLE ADDRESSES (
  address_id INT PRIMARY KEY AUTO_INCREMENT,
  street_address VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code VARCHAR(20)
);

CREATE TABLE INSURANCES (
  insurance_id INT PRIMARY KEY AUTO_INCREMENT,
  insurance_company_name VARCHAR(100),
  policy_number VARCHAR(50)
);

CREATE TABLE PROVIDERS (
  provider_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  specialty VARCHAR(100)
);

CREATE TABLE FACILITIES (
  facility_id INT PRIMARY KEY AUTO_INCREMENT,
  facility_name VARCHAR(100),
  facility_type VARCHAR(50)
);

CREATE TABLE PATIENTS (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  date_of_birth DATE,
  gender VARCHAR(10),
  address_id INT,
  insurance_id INT,
  FOREIGN KEY (address_id) REFERENCES ADDRESSES(address_id),
  FOREIGN KEY (insurance_id) REFERENCES INSURANCES(insurance_id)
);

CREATE TABLE VISITS (
  visit_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  provider_id INT,
  visit_time DATETIME,
  facility_id INT,
  FOREIGN KEY (patient_id) REFERENCES PATIENTS(patient_id),
  FOREIGN KEY (provider_id) REFERENCES PROVIDERS(provider_id),
  FOREIGN KEY (facility_id) REFERENCES FACILITIES(facility_id)
);

CREATE TABLE CLINICAL_INFORMATION (
  clinical_info_id INT PRIMARY KEY,
  visit_id INT,
  symptom VARCHAR(100),
  discharge_diagnosis VARCHAR(100),
  prescription VARCHAR(100),
  FOREIGN KEY (visit_id) REFERENCES VISITS(visit_id)
);

CREATE TABLE APPOINTMENTS (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  provider_id INT,
  appointment_time DATETIME,
  facility_id INT,
  FOREIGN KEY (patient_id) REFERENCES PATIENTS(patient_id),
  FOREIGN KEY (provider_id) REFERENCES PROVIDERS(provider_id),
  FOREIGN KEY (facility_id) REFERENCES FACILITIES(facility_id)
);

CREATE TABLE ORDERS (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  visit_id INT,
  test_name VARCHAR(100),
  test_result VARCHAR(100),
  FOREIGN KEY (visit_id) REFERENCES VISITS(visit_id)
);

CREATE TABLE BEDS (
  bed_id INT PRIMARY KEY AUTO_INCREMENT,
  facility_id INT,
  bed_number VARCHAR(50),
  bed_type VARCHAR(50),
  FOREIGN KEY (facility_id) REFERENCES FACILITIES(facility_id)
);

CREATE TABLE SUPPLIES (
  supply_id INT PRIMARY KEY AUTO_INCREMENT,
  facility_id INT,
  supply_name VARCHAR(100),
  supply_quantity INT,
  FOREIGN KEY (facility_id) REFERENCES FACILITIES(facility_id)
);

CREATE TABLE BILLING (
  billing_id INT PRIMARY KEY AUTO_INCREMENT,
  visit_id INT,
  billing_amount DECIMAL(10,2),
  FOREIGN KEY (visit_id) REFERENCES VISITS(visit_id)
);






