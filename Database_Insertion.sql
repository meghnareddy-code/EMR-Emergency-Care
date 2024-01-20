USE emergencyehr;

INSERT INTO ADDRESSES  VALUES
(1,'123 Main St', 'Los Angeles', 'CA', '90001'),
(2,'456 Elm St', 'New York', 'NY', '10001'),
(3,'789 Oak St', 'Chicago', 'IL', '60601'),
(4,'101 Pine St', 'San Francisco', 'CA', '94101'),
(5,'222 Maple St', 'Boston', 'MA', '02101'),
(6,'333 Cedar St', 'Seattle', 'WA', '98101'),
(7,'444 Birch St', 'Miami', 'FL', '33101'),
(8,'555 Redwood St', 'Dallas', 'TX', '75201'),
(9,'666 Willow St', 'Denver', 'CO', '80201'),
(10,'777 Spruce St', 'Phoenix', 'AZ', '85001'),
(11,'888 Oakwood St', 'Philadelphia', 'PA', '19101'),
(12,'999 Forest St', 'Atlanta', 'GA', '30301'),
(13, '111 Walnut St', 'Houston', 'TX', '77001'),
(14,'222 Sequoia St', 'Detroit', 'MI', '48201'),
(15,'333 Red Oak St', 'Minneapolis', 'MN', '55401'),
(16, '444 Cedar Elm St', 'San Diego', 'CA', '92101'),
(17,'555 Sycamore St', 'Portland', 'OR', '97201'),
(18, '666 Willow Oak St', 'Las Vegas', 'NV', '89101'),
(19, '777 Chestnut St', 'New Orleans', 'LA', '70101'),
(20,'888 Aspen St', 'Salt Lake City', 'UT', '84101');

select * from ADDRESSES;


INSERT INTO INSURANCES
VALUES (1,"A Company",10000100),
(2,"B Company",10000200),
(3,"C Company",10000300),
(4,"D Company",10000400),
(5,"E Company",10000500),
(6,"F Company",10000600),
(7,"G Company",10000700),
(8,"H Company",10000800),
(9,"I Company",10000900),
(10,"J Company",10000110);
select * from INSURANCES;

INSERT INTO PROVIDERS
VALUES (1,"Meghna","Reddy","Neurosurgery"),
(2,"Sahithi","Talluri","Thoracic surgery"),
(3,"Shiny","Pidugu","Orthopedic surgery "),
(4,"Vaishnavi","Dygala","Plastic surgery"),
(5,"Thanishq","Kanuru","Vascular surgery"),
(6,"Bob","Smith","Cardiology"),
(7,"Vamsi","Verma","Radiology"),
(8,"Dev","D","Urology"),
(9,"Saurabh","Singh","Dermatology"),
(10,"Koushik","K","Anesthesiology");
select * from PROVIDERS;

INSERT INTO FACILITIES
VALUES (1,"Neurosurgery Clinic",80100),
(2,"Thoracic surgery Center",80200),
(3,"Orthopedic surgery Center",80300),
(4,"Plastic surgery Center",80400),
(5,"Vascular surgery Center",80500),
(6,"Cardiology Clinic",80600),
(7,"Radiology Clinic",80700),
(8,"Urology Center",80800),
(9,"Dermatology Clinic",80900),
(10,"Anesthesiology Center",80110);
select * from FACILITIES;

INSERT INTO PATIENTS
VALUES 
(1,'John', 'Doe', '1990-01-15', 'Male', 1, 1),
(2,'Jane', 'Smith', '1985-05-20', 'Female', 2, 2),
(3,'Michael', 'Johnson', '1978-09-10', 'Male', 3, 3),
(4,'Emily', 'Williams', '1995-03-30', 'Female', 4, 4),
(5,'David', 'Brown', '1980-11-05', 'Male', 5, 5),
(6,'Sarah', 'Jones', '1992-07-12', 'Female', 6, 6),
(7,'Daniel', 'Wilson', '1987-04-25', 'Male', 7, 7),
(8,'Linda', 'Martinez', '1972-12-18', 'Female', 8, 8),
(9,'William', 'Anderson', '1998-08-22', 'Male', 9, 9),
(10,'Amanda', 'Taylor', '1983-06-15', 'Female', 10, 10);
select * from PATIENTS;


INSERT INTO VISITS
VALUES (1, 3, 8, '2023-09-10 10:00:00', 8),
(2, 1, 4, '2023-09-11 11:30:00', 4),
(3, 5, 7, '2023-09-12 14:15:00', 7),
(4, 7, 2, '2023-09-13 08:45:00', 2),
(5, 2, 5, '2023-09-14 09:30:00', 5),
(6, 9, 1, '2023-09-15 13:00:00', 1),
(7, 8, 3, '2023-09-16 10:45:00', 3),
(8, 6, 10, '2023-09-17 12:30:00', 10),
(9, 4, 6, '2023-09-18 15:00:00', 6),
(10, 10, 9, '2023-09-19 16:15:00', 9),
(11, 2, 8, '2023-09-20 09:30:00', 8),
(12, 5, 1, '2023-09-21 11:00:00', 1),
(13, 8, 7, '2023-09-22 14:45:00', 7),
(14, 3, 4, '2023-09-23 08:00:00', 4),
(15, 6, 2, '2023-09-24 10:30:00', 2),
(16, 1, 10, '2023-09-25 13:15:00', 10),
(17, 9, 5, '2023-09-26 15:30:00', 5),
(18, 7, 3, '2023-09-27 09:45:00', 3),
(19, 4, 6, '2023-09-28 12:00:00', 6),
(20, 10, 1, '2023-09-29 14:30:00', 1),
(21, 2, 4, '2023-10-10 16:45:00', 4),
(22, 5, 7, '2023-10-11 10:15:00', 7),
(23, 8, 2, '2023-10-12 12:30:00', 2),
(24, 3, 5, '2023-10-13 14:45:00', 5),
(25, 6, 1, '2023-10-14 08:00:00', 1),
(26, 1, 3, '2023-10-15 10:30:00', 3);
select * from VISITS;

INSERT INTO CLINICAL_INFORMATION (clinical_info_id, visit_id, symptom, discharge_diagnosis, prescription)
VALUES(1, 1, 'Urinary incontinence', 'Benign prostatic hyperplasia', 'Alpha-blockers'),
(2, 2, 'Breathing difficulty', 'Pulmonary embolism', 'Anticoagulants'),
(3, 3, 'Chest pain', 'Lung cancer', 'Chemotherapy'),
(4, 4, 'Chest tightness', 'Coronary artery disease', 'Angioplasty'),
(5, 5, 'Abdominal pain', 'Abdominal aortic aneurysm', 'Surgery'),
(6, 6, 'Headache', 'Cerebral aneurysm', 'Surgery'),
(7, 7, 'Joint pain', 'Arthritis', 'Physical therapy'),
(8, 8, 'Nausea', 'General anesthesia', 'Anti-nausea medication'),
(9, 9, 'Chest pain', 'Myocardial infarction', 'Aspirin, nitroglycerin'),
(10, 10, 'Acne', 'Acne vulgaris', 'Topical retinoids'),
(11, 11, 'Bladder pain', 'Urinary tract infection', 'Antibiotics'),
(12, 12, 'Head injury', 'Traumatic brain injury', 'Surgery'),
(13, 13, 'Bone fracture', 'Femur fracture', 'Surgery'),
(14, 14, 'Scar revision', 'Hypertrophic scar', 'Surgery'),
(15, 15, 'Chest pain', 'Pulmonary embolism', 'Anticoagulants'),
(16, 16, 'Nausea', 'General anesthesia', 'Anti-nausea medication'),
(17, 17, 'Abdominal pain', 'Abdominal aortic aneurysm', 'Surgery'),
(18, 18, 'Joint pain', 'Osteoarthritis', 'NSAIDs'),
(19, 19, 'Chest pain', 'Myocardial infarction', 'Aspirin, nitroglycerin'),
(20, 20, 'Headache', 'Migraine', 'Triptans'),
(21, 21, 'Scar revision', 'Keloid', 'Surgery'),
(22, 22, 'Bone fracture', 'Clavicle fracture', 'Sling'),
(23, 23, 'Breathing difficulty', 'Pulmonary embolism', 'Anticoagulants'),
(24, 24, 'Abdominal pain', 'Mesenteric ischemia', 'Surgery'),
(25, 25, 'Headache', 'Meningioma', 'Surgery'),
(26, 26, 'Joint pain', 'Osteoporosis', 'Calcium, vitamin D supplements');
select * from CLINICAL_INFORMATION;

INSERT INTO APPOINTMENTS (appointment_id, patient_id, provider_id, appointment_time, facility_id)
VALUES (1, 3, 8, '2023-09-10 10:00:00', 8),
  (2, 1, 4, '2023-09-11 11:30:00', 4),
  (3, 5, 7, '2023-09-12 14:15:00', 7),
  (4, 7, 2, '2023-09-13 08:45:00', 2),
  (5, 2, 5, '2023-09-14 09:30:00', 5),
  (6, 9, 1, '2023-09-15 13:00:00', 1),
  (7, 8, 3, '2023-09-16 10:45:00', 3),
  (8, 6, 10, '2023-09-17 12:30:00', 10),
  (9, 4, 6, '2023-09-18 15:00:00', 6),
  (10, 10, 9, '2023-09-19 16:15:00', 9),
  (11, 2, 8, '2023-09-20 09:30:00', 8),
  (12, 5, 1, '2023-09-21 11:00:00', 1),
  (13, 8, 7, '2023-09-22 14:45:00', 7),
  (14, 3, 4, '2023-09-23 08:00:00', 4),
  (15, 6, 2, '2023-09-24 10:30:00', 2),
  (16, 1, 10, '2023-09-25 13:15:00', 10),
  (17, 9, 5, '2023-09-26 15:30:00', 5),
  (18, 7, 3, '2023-09-27 09:45:00', 3),
  (19, 4, 6, '2023-09-28 12:00:00', 6),
  (20, 10, 1, '2023-09-29 14:30:00', 1),
  (21, 2, 4, '2023-10-10 16:45:00', 4),
  (22, 5, 7, '2023-10-11 10:15:00', 7),
  (23, 8, 2, '2023-10-12 12:30:00', 2),
  (24, 3, 5, '2023-10-13 14:45:00', 5),
  (25, 6, 1, '2023-10-14 08:00:00', 1),
  (26, 1, 3, '2023-10-15 10:30:00', 3);
  select * from APPOINTMENTS;
  
  INSERT INTO ORDERS
VALUES (1, 1, 'Urinalysis', 'Normal'),
(2, 2, 'Chest X-ray', 'Clear'),
(3, 3, 'MRI', 'No significant findings'),
(4, 4, 'CT scan', 'Clear'),
(5, 5, 'Angiography', 'Blocked artery'),
(6, 6, 'ECG', 'Irregular heartbeat'),
(7, 7, 'X-ray', 'Fracture'),
(8, 8, 'Blood test', 'Normal'),
(9, 9, 'Echo', 'Normal'),
(10, 10, 'Skin biopsy', 'Malignant'),
(11, 11, 'Ultrasound', 'Normal'),
(12, 12, 'CT scan', 'Tumor'),
(13, 13, 'MRI', 'No significant findings'),
(14, 14, 'Plastic surgery', 'Successful'),
(15, 15, 'X-ray', 'Clear'),
(16, 16, 'Blood test', 'Normal'),
(17, 17, 'Angiography', 'Blocked artery'),
(18, 18, 'Orthopedic surgery', 'Successful'),
(19, 19, 'Echo', 'Irregular heartbeat'),
(20, 20, 'CT scan', 'Tumor'),
(21, 21, 'Plastic surgery', 'Successful'),
(22, 22, 'MRI', 'No significant findings'),
(23, 23, 'Chest X-ray', 'Clear'),
(24, 24, 'Angiography', 'Blocked artery'),
(25, 25, 'CT scan', 'Tumor'),
(26, 26, 'Orthopedic surgery', 'Successful');
select * from ORDERS;


INSERT INTO BEDS
VALUES (1, 1, 'B001', 'Single'),
(2, 1, 'B002', 'Single'),
(3, 1, 'B003', 'Double'),
(4, 1, 'B004', 'Double'),
(5, 2, 'B001', 'Single'),
(6, 2, 'B002', 'Single'),
(9, 3, 'B001', 'Single'),
(10, 3, 'B002', 'Single'),
(11, 3, 'B003', 'Double'),
(12, 3, 'B004', 'Double'),
(13, 4, 'B001', 'Single'),
(14, 4, 'B002', 'Single'),
(15, 4, 'B003', 'Double'),
(16, 4, 'B004', 'Double'),
(17, 5, 'B001', 'Single'),
(18, 5, 'B002', 'Single'),
(19, 5, 'B003', 'Double'),
(20, 5, 'B004', 'Double'),
(21, 6, 'B001', 'Single'),
(22, 6, 'B002', 'Single'),
(23, 6, 'B003', 'Double'),
(24, 6, 'B004', 'Double'),
(25, 7, 'B001', 'Single'),
(26, 7, 'B002', 'Single'),
(27, 7, 'B003', 'Double'),
(28, 7, 'B004', 'Double'),
(29, 8, 'B001', 'Single'),
(30, 8, 'B002', 'Single'),
(31, 8, 'B003', 'Double'),
(32, 8, 'B004', 'Double'),
(33, 9, 'B001', 'Single'),
(34, 9, 'B002', 'Single'),
(35, 9, 'B003', 'Double'),
(36, 9, 'B004', 'Double'),
(37, 10, 'B001', 'Single'),
(38, 10, 'B002', 'Single'),
(39, 10, 'B003', 'Double'),
(40, 10, 'B004', 'Double');
select * from BEDS;

INSERT INTO SUPPLIES
VALUES (1, 1, 'Neurosurgery supplies', 50),
(2, 2, 'Thoracic surgery supplies', 75),
(3, 3, 'Orthopedic surgery supplies', 100),
(4, 4, 'Plastic surgery supplies', 80),
(5, 5, 'Vascular surgery supplies', 60),
(6, 6, 'Cardiology supplies', 90),
(7, 7, 'Radiology supplies', 120),
(8, 8, 'Urology supplies', 70),
(9, 9, 'Dermatology supplies', 110),
(10, 10, 'Anesthesiology supplies', 95);
select * from SUPPLIES;

INSERT INTO BILLING 
VALUES (1, 1, 1000.00),
(2, 2, 5000.00),
(3, 3, 2500.00),
(4, 4, 3000.00),
(5, 5, 1500.00),
(6, 6, 2000.00),
(7, 7, 10000.00),
(8, 8, 750.00),
(9, 9, 4500.00),
(10, 10, 900.00),
(11, 11, 1100.00),
(12, 12, 4000.00),
(13, 13, 8500.00),
(14, 14, 2000.00),
(15, 15, 3000.00),
(16, 16, 1250.00),
(17, 17, 5000.00),
(18, 18, 600.00),
(19, 19, 800.00),
(20, 20, 4000.00),
(21, 21, 1500.00),
(22, 22, 2000.00),
(23, 23, 3000.00),
(24, 24, 2500.00),
(25, 25, 5000.00),
(26, 26, 4000.00);
select * from BILLING;


