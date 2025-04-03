-- Clear all tables in proper order to maintain referential integrity
DELETE FROM UserEmergencySettings;
DBCC CHECKIDENT ('UserEmergencySettings', RESEED, 0);
DELETE FROM HealthTips;
DBCC CHECKIDENT ('HealthTips', RESEED, 0);
DELETE FROM Orders;
DBCC CHECKIDENT ('Orders', RESEED, 0);
DELETE FROM Appointments;
DBCC CHECKIDENT ('Appointments', RESEED, 0);
DELETE FROM Treatments;
DBCC CHECKIDENT ('Treatments', RESEED, 0);
DELETE FROM SymptomCondition;
DELETE FROM SymptomsNormalized;
DBCC CHECKIDENT ('SymptomsNormalized', RESEED, 0);
DELETE FROM Diseases;
DBCC CHECKIDENT ('Diseases', RESEED, 0);
DELETE FROM Health_info;
DELETE FROM DoctorAvailability;
DBCC CHECKIDENT ('DoctorAvailability', RESEED, 0);
DELETE FROM Doctors;
DBCC CHECKIDENT ('Doctors', RESEED, 0);
DELETE FROM Medications;
DBCC CHECKIDENT ('Medications', RESEED, 0);
DELETE FROM UserAllergy;
DELETE FROM Allergies;
DBCC CHECKIDENT ('Allergies', RESEED, 0);
DELETE FROM UserMedicalCondition;
DELETE FROM Medical_conditions;
DBCC CHECKIDENT ('Medical_conditions', RESEED, 0);
DELETE FROM EmergencyContact;
DBCC CHECKIDENT ('EmergencyContact', RESEED, 0);
DELETE FROM User_details;
DELETE FROM Users;
DBCC CHECKIDENT ('Users', RESEED, 0);

-- Insert Users with guaranteed unique emails
INSERT INTO Users (email, password) VALUES
('patient01@health.com', 'SecurePass1!'),
('patient02@health.com', 'SecurePass2@'),
('patient03@health.com', 'SecurePass3#'),
('patient04@health.com', 'SecurePass4$'),
('patient05@health.com', 'SecurePass5%'),
('patient06@health.com', 'SecurePass6^'),
('patient07@health.com', 'SecurePass7&'),
('patient08@health.com', 'SecurePass8*'),
('patient09@health.com', 'SecurePass9('),
('patient10@health.com', 'SecurePass0)');

-- Insert User_details
INSERT INTO User_details (user_id, full_name, age, gender, phone_number, house_no, city, area, weight, height, disability) VALUES
(1, 'John Smith', 35, 'Male', '0300-1111111', '12-A', 'Karachi', 'Clifton', 75.5, 175.0, NULL),
(2, 'Sarah Johnson', 28, 'Female', '0300-2222222', '45-B', 'Karachi', 'Defence', 62.0, 165.0, 'None'),
(3, 'Ali Khan', 45, 'Male', '0300-3333333', '78-C', 'Karachi', 'Gulshan', 80.0, 180.0, 'Asthma'),
(4, 'Fatima Ahmed', 22, 'Female', '0300-4444444', '90-D', 'Karachi', 'North Nazimabad', 55.0, 160.0, NULL),
(5, 'Ahmed Raza', 50, 'Male', '0300-5555555', '123-E', 'Karachi', 'Gulistan-e-Johar', 90.0, 170.0, 'Diabetes'),
(6, 'Ayesha Malik', 31, 'Female', '0300-6666666', '456-F', 'Karachi', 'PECHS', 60.0, 162.0, NULL),
(7, 'Bilal Akhtar', 40, 'Male', '0300-7777777', '789-G', 'Karachi', 'Saddar', 85.0, 178.0, 'Hypertension'),
(8, 'Zainab Hassan', 27, 'Female', '0300-8888888', '112-H', 'Karachi', 'Malir', 58.0, 158.0, NULL),
(9, 'Kamran Siddiqui', 33, 'Male', '0300-9999999', '131-I', 'Karachi', 'Korangi', 70.0, 172.0, 'None'),
(10, 'Sana Farooq', 29, 'Female', '0300-0000000', '415-J', 'Karachi', 'Landhi', 63.0, 167.0, NULL);

-- Insert EmergencyContact
INSERT INTO EmergencyContact (user_id, name, number) VALUES
(1, 'Ali Ahmed', '0301-1111111'),
(2, 'Hassan Raza', '0301-2222222'),
(3, 'Saima Khan', '0301-3333333'),
(4, 'Bilal Akhtar', '0301-4444444'),
(5, 'Farhan Malik', '0301-5555555'),
(6, 'Zara Shah', '0301-6666666'),
(7, 'Imran Ali', '0301-7777777'),
(8, 'Nadia Hussain', '0301-8888888'),
(9, 'Omar Farooq', '0301-9999999'),
(10, 'Fariha Kamran', '0301-0000000');

-- Insert Medical_conditions
INSERT INTO Medical_conditions (condition_name) VALUES
('Diabetes Type 2'),
('Essential Hypertension'),
('Bronchial Asthma'),
('Rheumatoid Arthritis'),
('Chronic Migraine'),
('Generalized Epilepsy'),
('Graves Disease'),
('Osteoporosis'),
('Chronic Bronchitis'),
('Coronary Artery Disease');

-- Insert UserMedicalCondition
INSERT INTO UserMedicalCondition (user_id, condition_id) VALUES
(1, 1),
(2, 3),
(3, 2),
(4, 5),
(5, 1),
(6, 4),
(7, 2),
(8, 6),
(9, 7),
(10, 9);

-- Insert Allergies
INSERT INTO Allergies (allergy_name) VALUES
('Penicillin Antibiotics'),
('Tree Pollen'),
('House Dust Mites'),
('Crustacean Shellfish'),
('Peanuts'),
('Natural Rubber Latex'),
('Cat Hair'),
('Chicken Eggs'),
('Soy Products'),
('Wheat Gluten');

-- Insert UserAllergy
INSERT INTO UserAllergy (user_id, allergy_id) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 2),
(5, 4),
(6, 6),
(7, 7),
(8, 9),
(9, 10),
(10, 8);

-- Insert Medications
INSERT INTO Medications (user_id, name, dosage, frequency, next_dose, supply_remaining) VALUES
(1, 'Metformin HCl', '500mg', 'Twice daily', DATEADD(day, 1, GETDATE()), 60),
(2, 'Salbutamol Inhaler', '100mcg/dose', 'As needed', DATEADD(day, 2, GETDATE()), 1),
(3, 'Lisinopril', '10mg', 'Once daily', DATEADD(day, 1, GETDATE()), 30),
(4, 'Sumatriptan', '50mg', 'As needed', GETDATE(), 9),
(5, 'Insulin Glargine', '10 units', 'Daily at bedtime', DATEADD(day, 1, GETDATE()), 15),
(6, 'Ibuprofen', '400mg', 'Every 6 hours as needed', DATEADD(day, 3, GETDATE()), 20),
(7, 'Amlodipine Besylate', '5mg', 'Once daily', DATEADD(day, 1, GETDATE()), 30),
(8, 'Levetiracetam', '500mg', 'Twice daily', DATEADD(day, 2, GETDATE()), 60),
(9, 'Methimazole', '10mg', 'Once daily', DATEADD(day, 1, GETDATE()), 30),
(10, 'Tiotropium Bromide', '18mcg', 'Once daily', DATEADD(day, 1, GETDATE()), 30);

-- Insert Doctors
INSERT INTO Doctors (name, specialization, location, fees) VALUES
('Dr. Ahmed Khan', 'Cardiology', 'Aga Khan University Hospital', 5000),
('Dr. Sara Ali', 'Dermatology', 'South City Hospital', 3000),
('Dr. Farhan Siddiqui', 'Endocrinology', 'Liaquat National Hospital', 4000),
('Dr. Zainab Shah', 'Neurology', 'Ziauddin Hospital North', 4500),
('Dr. Bilal Hassan', 'Orthopedic Surgery', 'Indus Hospital', 3500),
('Dr. Ayesha Malik', 'Pediatrics', 'National Medical Center', 2500),
('Dr. Omar Farooq', 'Oncology', 'Dow University Hospital', 6000),
('Dr. Nadia Akhtar', 'Psychiatry', 'Jinnah Postgraduate Medical Center', 3200),
('Dr. Imran Raza', 'Gastroenterology', 'PNS Shifa Hospital', 4200),
('Dr. Sana Kamran', 'Pulmonology', 'Altamash General Hospital', 3800);

-- Insert DoctorAvailability
INSERT INTO DoctorAvailability (doctor_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '09:00', '17:00'),
(1, 'Wednesday', '09:00', '17:00'),
(2, 'Tuesday', '10:00', '18:00'),
(2, 'Thursday', '10:00', '18:00'),
(3, 'Wednesday', '08:00', '16:00'),
(4, 'Thursday', '11:00', '19:00'),
(5, 'Friday', '07:00', '15:00'),
(6, 'Saturday', '09:30', '17:30'),
(7, 'Monday', '08:30', '16:30'),
(8, 'Wednesday', '10:00', '18:00');

-- Insert Health_info
INSERT INTO Health_info (user_id, doctor_id, prescription_path) VALUES
(1, 3, '/prescriptions/user1_metformin.pdf'),
(2, 6, '/prescriptions/user2_ventolin.pdf'),
(3, 1, '/prescriptions/user3_lisinopril.pdf'),
(4, 4, '/prescriptions/user4_sumatriptan.pdf'),
(5, 3, '/prescriptions/user5_insulin.pdf'),
(6, 5, '/prescriptions/user6_ibuprofen.pdf'),
(7, 7, '/prescriptions/user7_amlodipine.pdf'),
(8, 8, '/prescriptions/user8_keppra.pdf'),
(9, 9, '/prescriptions/user9_methimazole.pdf'),
(10, 10, '/prescriptions/user10_spiriva.pdf');

-- Insert Diseases
INSERT INTO Diseases (disease_name) VALUES
('Type 2 Diabetes Mellitus'),
('Essential Hypertension'),
('Bronchial Asthma'),
('Chronic Migraine'),
('Rheumatoid Arthritis'),
('Generalized Epilepsy'),
('Graves Disease (Hyperthyroidism)'),
('Chronic Obstructive Pulmonary Disease'),
('Coronary Artery Disease'),
('Gastroesophageal Reflux Disease');

-- Insert SymptomsNormalized
INSERT INTO SymptomsNormalized (description) VALUES
('Excessive thirst (Polydipsia)'),
('Frequent urination (Polyuria)'),
('Chest pain or discomfort'),
('Shortness of breath (Dyspnea)'),
('Severe headache with aura'),
('Joint pain and stiffness'),
('Tonic-clonic seizures'),
('Unintentional weight loss'),
('Chronic productive cough'),
('Burning chest pain (Heartburn)');

-- Insert SymptomCondition
INSERT INTO SymptomCondition (disease_id, symptom_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 3);

-- Insert Treatments
INSERT INTO Treatments (disease_id, description, type) VALUES
(1, 'Oral hypoglycemics and dietary control', 'Medical'),
(2, 'ACE inhibitors and low-sodium diet', 'Medical'),
(3, 'Inhaled corticosteroids and bronchodilators', 'Medical'),
(4, 'Triptans and lifestyle modifications', 'Medical'),
(5, 'DMARDs and physical therapy', 'Medical'),
(6, 'Antiepileptic drug therapy', 'Medical'),
(7, 'Antithyroid medications and beta-blockers', 'Medical'),
(8, 'Bronchodilators and pulmonary rehab', 'Medical'),
(9, 'Antiplatelets and coronary angioplasty', 'Surgical'),
(10, 'Proton pump inhibitors and diet changes', 'Medical');

-- Insert Appointments
INSERT INTO Appointments (user_id, doctor_id, date, time, status) VALUES
(1, 3, '2023-12-15', '10:00', 'Booked'),
(2, 6, '2023-12-16', '11:30', 'Completed'),
(3, 1, '2023-12-17', '14:00', 'Booked'),
(4, 4, '2023-12-18', '15:30', 'Cancelled'),
(5, 3, '2023-12-19', '09:00', 'Completed'),
(6, 5, '2023-12-20', '10:30', 'Booked'),
(7, 7, '2023-12-21', '13:00', 'Completed'),
(8, 8, '2023-12-22', '16:00', 'Booked'),
(9, 9, '2023-12-23', '11:00', 'Cancelled'),
(10, 10, '2023-12-24', '17:30', 'Booked');

-- Insert Orders
INSERT INTO Orders (user_id, medication_id, quantity, delivery_method, order_date) VALUES
(1, 1, 2, 'Home Delivery', GETDATE()),
(2, 2, 1, 'Pharmacy Pickup', GETDATE()),
(3, 3, 3, 'Home Delivery', GETDATE()),
(4, 4, 5, 'Express Delivery', GETDATE()),
(5, 5, 1, 'Pharmacy Pickup', GETDATE()),
(6, 6, 2, 'Home Delivery', GETDATE()),
(7, 7, 4, 'Express Delivery', GETDATE()),
(8, 8, 1, 'Pharmacy Pickup', GETDATE()),
(9, 9, 2, 'Home Delivery', GETDATE()),
(10, 10, 3, 'Express Delivery', GETDATE());

-- Insert HealthTips
INSERT INTO HealthTips (title, content, type, valid_from, valid_to) VALUES
('Hydration Importance', 'Drink at least 2 liters of water daily for optimal body function', 'General', '2023-01-01', '2023-12-31'),
('Winter Skin Care', 'Use moisturizer regularly to prevent dry skin in cold weather', 'Seasonal', '2023-11-01', '2024-02-28'),
('Daily Exercise', '30 minutes of moderate exercise 5 days a week improves cardiovascular health', 'General', '2023-01-01', '2023-12-31'),
('Flu Season Prep', 'Get vaccinated against influenza before winter season starts', 'Seasonal', '2023-10-01', '2024-03-31'),
('Balanced Diet', 'Follow the plate method: 50% vegetables, 25% protein, 25% whole grains', 'General', '2023-01-01', '2023-12-31'),
('Sun Protection', 'Apply SPF 30+ sunscreen every 2 hours when outdoors', 'Seasonal', '2023-05-01', '2023-09-30'),
('Stress Reduction', 'Practice mindfulness meditation for 10 minutes daily', 'General', '2023-01-01', '2023-12-31'),
('Diabetes Management', 'Monitor blood glucose levels regularly and maintain a food diary', 'General', '2023-01-01', '2023-12-31'),
('Heart Healthy Habits', 'Limit saturated fats and increase omega-3 fatty acids in diet', 'General', '2023-01-01', '2023-12-31'),
('Sleep Recommendations', 'Maintain consistent sleep schedule with 7-9 hours nightly', 'General', '2023-01-01', '2023-12-31');

-- Insert UserEmergencySettings
INSERT INTO UserEmergencySettings (user_id, check_in_frequency, last_check_in) VALUES
(1, 'Daily', GETDATE()),
(2, 'Weekly', GETDATE()),
(3, 'Daily', GETDATE()),
(4, 'Monthly', GETDATE()),
(5, 'Weekly', GETDATE()),
(6, 'Daily', GETDATE()),
(7, 'Monthly', GETDATE()),
(8, 'Weekly', GETDATE()),
(9, 'Daily', GETDATE()),
(10, 'Monthly', GETDATE());


-- Display Users table
SELECT 'Users Table' AS TableName;
SELECT * FROM Users;
GO

-- Display User_details table
SELECT 'User_details Table' AS TableName;
SELECT * FROM User_details;
GO

-- Display EmergencyContact table
SELECT 'EmergencyContact Table' AS TableName;
SELECT * FROM EmergencyContact;
GO

-- Display Medical_conditions table
SELECT 'Medical_conditions Table' AS TableName;
SELECT * FROM Medical_conditions;
GO

-- Display UserMedicalCondition table
SELECT 'UserMedicalCondition Table' AS TableName;
SELECT * FROM UserMedicalCondition;
GO

-- Display Allergies table
SELECT 'Allergies Table' AS TableName;
SELECT * FROM Allergies;
GO

-- Display UserAllergy table
SELECT 'UserAllergy Table' AS TableName;
SELECT * FROM UserAllergy;
GO

-- Display Medications table
SELECT 'Medications Table' AS TableName;
SELECT * FROM Medications;
GO

-- Display Doctors table
SELECT 'Doctors Table' AS TableName;
SELECT * FROM Doctors;
GO

-- Display DoctorAvailability table
SELECT 'DoctorAvailability Table' AS TableName;
SELECT * FROM DoctorAvailability;
GO

-- Display Health_info table
SELECT 'Health_info Table' AS TableName;
SELECT * FROM Health_info;
GO

-- Display Diseases table
SELECT 'Diseases Table' AS TableName;
SELECT * FROM Diseases;
GO

-- Display SymptomsNormalized table
SELECT 'SymptomsNormalized Table' AS TableName;
SELECT * FROM SymptomsNormalized;
GO

-- Display SymptomCondition table
SELECT 'SymptomCondition Table' AS TableName;
SELECT * FROM SymptomCondition;
GO

-- Display Treatments table
SELECT 'Treatments Table' AS TableName;
SELECT * FROM Treatments;
GO

-- Display Appointments table
SELECT 'Appointments Table' AS TableName;
SELECT * FROM Appointments;
GO

-- Display Orders table
SELECT 'Orders Table' AS TableName;
SELECT * FROM Orders;
GO

-- Display HealthTips table
SELECT 'HealthTips Table' AS TableName;
SELECT * FROM HealthTips;
GO

-- Display UserEmergencySettings table
SELECT 'UserEmergencySettings Table' AS TableName;
SELECT * FROM UserEmergencySettings;
GO