-- Drop all existing tables (if any)
DROP TABLE IF EXISTS DoctorAvailability;
DROP TABLE IF EXISTS EmergencyContact;
DROP TABLE IF EXISTS HealthTips;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS SymptomCondition;
DROP TABLE IF EXISTS SymptomsNormalized;
DROP TABLE IF EXISTS Diseases;
DROP TABLE IF EXISTS Health_info;
DROP TABLE IF EXISTS Medications;
DROP TABLE IF EXISTS UserAllergy;
DROP TABLE IF EXISTS UserMedicalCondition;
DROP TABLE IF EXISTS Allergies;
DROP TABLE IF EXISTS Medical_conditions;
DROP TABLE IF EXISTS User_details;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Doctors;

-- Create Tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL
);

CREATE TABLE User_details (
    user_id INT PRIMARY KEY,
    full_name NVARCHAR(255) NOT NULL,
    age INT,
    gender NVARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone_number NVARCHAR(20),
    house_no NVARCHAR(50),
    city NVARCHAR(100) DEFAULT 'Karachi',
    area NVARCHAR(100),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    disability NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE EmergencyContact (
    contact_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Medical_conditions (
    condition_id INT PRIMARY KEY IDENTITY(1,1),
    condition_name NVARCHAR(255) NOT NULL
);

CREATE TABLE UserMedicalCondition (
    user_id INT NOT NULL,
    condition_id INT NOT NULL,
    PRIMARY KEY (user_id, condition_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (condition_id) REFERENCES Medical_conditions(condition_id)
);

CREATE TABLE Allergies (
    allergy_id INT PRIMARY KEY IDENTITY(1,1),
    allergy_name NVARCHAR(255) NOT NULL
);

CREATE TABLE UserAllergy (
    user_id INT NOT NULL,
    allergy_id INT NOT NULL,
    PRIMARY KEY (user_id, allergy_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (allergy_id) REFERENCES Allergies(allergy_id)
);

CREATE TABLE Medications (
    medication_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    dosage NVARCHAR(100),
    frequency NVARCHAR(100),
    next_dose DATETIME,
    supply_remaining INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    specialization NVARCHAR(255) NOT NULL,
    location NVARCHAR(255) NOT NULL,
    fees DECIMAL(10,2)
);

CREATE TABLE DoctorAvailability (
    availability_id INT PRIMARY KEY IDENTITY(1,1),
    doctor_id INT NOT NULL,
    day_of_week NVARCHAR(10) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Health_info (
    user_id INT PRIMARY KEY,
    doctor_id INT,
    prescription_path NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Diseases (
    disease_id INT PRIMARY KEY IDENTITY(1,1),
    disease_name NVARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE SymptomsNormalized (
    symptom_id INT PRIMARY KEY IDENTITY(1,1),
    description NVARCHAR(255) NOT NULL
);

CREATE TABLE SymptomCondition (
    disease_id INT NOT NULL,
    symptom_id INT NOT NULL,
    PRIMARY KEY (disease_id, symptom_id),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id),
    FOREIGN KEY (symptom_id) REFERENCES SymptomsNormalized(symptom_id)
);

CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY IDENTITY(1,1),
    disease_id INT NOT NULL,
    description NVARCHAR(MAX),
    type NVARCHAR(50),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status NVARCHAR(50) CHECK (status IN ('Booked', 'Completed', 'Cancelled')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL,
    delivery_method NVARCHAR(50),
    order_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

CREATE TABLE HealthTips (
    tip_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    type NVARCHAR(50) CHECK (type IN ('Seasonal', 'General')),
    valid_from DATE,
    valid_to DATE
);

CREATE TABLE UserEmergencySettings (
    user_id INT PRIMARY KEY,
    check_in_frequency NVARCHAR(50),
    last_check_in DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert Sample Data
INSERT INTO Users (email, password) VALUES
('user1@example.com', 'password123'),
('user2@example.com', 'securepass321');

INSERT INTO User_details (user_id, full_name, age, gender, city) VALUES
(1, 'Ghulam Mustufa', 35, 'Male', 'Karachi'),
(2, 'Ayesha Khan', 28, 'Female', 'Lahore');

INSERT INTO EmergencyContact (user_id, name, number) VALUES
(1, 'Ali Ahmed', '+921234567890'),
(2, 'Zainab Malik', '+929876543210');

INSERT INTO Medical_conditions (condition_name) VALUES
('Hypertension'), ('Diabetes'), ('Asthma');

INSERT INTO UserMedicalCondition (user_id, condition_id) VALUES
(1, 1), (2, 2);

INSERT INTO Medications (user_id, name, dosage, frequency, next_dose) VALUES
(1, 'Paracetamol', '500mg', 'Every 6 hours', '2023-10-25 09:00:00'),
(2, 'Metformin', '850mg', 'Daily', '2023-10-25 08:00:00');

INSERT INTO Doctors (name, specialization, location, fees) VALUES
('Dr. Sarah Miller', 'General Practitioner', '123 Health Street, Karachi', 1500),
('Dr. John Smith', 'Dermatologist', '456 Wellness Road, Lahore', 2500);

INSERT INTO DoctorAvailability (doctor_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '09:00', '17:00'),
(1, 'Wednesday', '09:00', '17:00');

INSERT INTO HealthTips (title, content, type, valid_from, valid_to) VALUES
('Flu Season Alert', 'Get your flu shots and wash hands regularly!', 'Seasonal', '2023-11-01', '2023-12-31'),
('Stay Hydrated', 'Drink 8 glasses of water daily in summer.', 'Seasonal', '2023-05-01', '2023-08-31');

-- Verify
SELECT * FROM Users;
SELECT * FROM Medications WHERE user_id = 1;







---------------------------------------------------------------------------------------


-- Insert Users
INSERT INTO Users (email, password) VALUES
('user1@example.com', 'password1'),
('user2@example.com', 'password2'),
('user3@example.com', 'password3'),
('user4@example.com', 'password4'),
('user5@example.com', 'password5'),
('user6@example.com', 'password6'),
('user7@example.com', 'password7'),
('user8@example.com', 'password8'),
('user9@example.com', 'password9'),
('user10@example.com', 'password10');

-- Insert User_details
INSERT INTO User_details (user_id, full_name, age, gender, phone_number, house_no, city, area, weight, height, disability) VALUES
(1, 'John Doe', 35, 'Male', '0300-1234567', '12-A', 'Karachi', 'Clifton', 75.5, 175.0, NULL),
(2, 'Sarah Smith', 28, 'Female', '0311-2345678', '45-B', 'Karachi', 'Defence', 62.0, 165.0, 'None'),
(3, 'Ali Khan', 45, 'Male', '0322-3456789', '78-C', 'Karachi', 'Gulshan', 80.0, 180.0, 'Asthma'),
(4, 'Fatima Ahmed', 22, 'Female', '0333-4567890', '90-D', 'Karachi', 'North Nazimabad', 55.0, 160.0, NULL),
(5, 'Ahmed Raza', 50, 'Male', '0344-5678901', '123-E', 'Karachi', 'Gulistan-e-Johar', 90.0, 170.0, 'Diabetes'),
(6, 'Ayesha Malik', 31, 'Female', '0355-6789012', '456-F', 'Karachi', 'PECHS', 60.0, 162.0, NULL),
(7, 'Bilal Akhtar', 40, 'Male', '0366-7890123', '789-G', 'Karachi', 'Saddar', 85.0, 178.0, 'Hypertension'),
(8, 'Zainab Hassan', 27, 'Female', '0377-8901234', '112-H', 'Karachi', 'Malir', 58.0, 158.0, NULL),
(9, 'Kamran Siddiqui', 33, 'Male', '0388-9012345', '131-I', 'Karachi', 'Korangi', 70.0, 172.0, 'None'),
(10, 'Sana Farooq', 29, 'Female', '0399-0123456', '415-J', 'Karachi', 'Landhi', 63.0, 167.0, NULL);

-- Insert EmergencyContact
INSERT INTO EmergencyContact (user_id, name, number) VALUES
(1, 'Ali Ahmed', '0300-7654321'),
(2, 'Hassan Raza', '0311-8765432'),
(3, 'Saima Khan', '0322-9876543'),
(4, 'Bilal Akhtar', '0333-0987654'),
(5, 'Farhan Malik', '0344-1098765'),
(6, 'Zara Shah', '0355-2109876'),
(7, 'Imran Ali', '0366-3210987'),
(8, 'Nadia Hussain', '0377-4321098'),
(9, 'Omar Farooq', '0388-5432109'),
(10, 'Fariha Kamran', '0399-6543210');

-- Insert Medical_conditions
INSERT INTO Medical_conditions (condition_name) VALUES
('Diabetes'),
('Hypertension'),
('Asthma'),
('Arthritis'),
('Migraine'),
('Epilepsy'),
('Hyperthyroidism'),
('Osteoporosis'),
('COPD'),
('Heart Disease');

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
('Penicillin'),
('Pollen'),
('Dust Mites'),
('Shellfish'),
('Peanuts'),
('Latex'),
('Cat Dander'),
('Eggs'),
('Soy'),
('Wheat');

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
(1, 'Metformin', '500mg', 'Twice daily', GETDATE()+1, 60),
(2, 'Ventolin', '2 puffs', 'As needed', GETDATE()+2, 1),
(3, 'Lisinopril', '10mg', 'Once daily', GETDATE()+1, 30),
(4, 'Sumatriptan', '50mg', 'As needed', GETDATE(), 9),
(5, 'Insulin', '10 units', 'Daily', GETDATE()+1, 15),
(6, 'Ibuprofen', '400mg', 'Every 6 hours', GETDATE()+3, 20),
(7, 'Amlodipine', '5mg', 'Once daily', GETDATE()+1, 30),
(8, 'Keppra', '500mg', 'Twice daily', GETDATE()+2, 60),
(9, 'Methimazole', '10mg', 'Once daily', GETDATE()+1, 30),
(10, 'Spiriva', '18mcg', 'Once daily', GETDATE()+1, 30);

-- Insert Doctors
INSERT INTO Doctors (name, specialization, location, fees) VALUES
('Dr. Ahmed Khan', 'Cardiology', 'Aga Khan Hospital', 5000),
('Dr. Sara Ali', 'Dermatology', 'South City Hospital', 3000),
('Dr. Farhan Siddiqui', 'Endocrinology', 'Liaquat National Hospital', 4000),
('Dr. Zainab Shah', 'Neurology', 'Ziauddin Hospital', 4500),
('Dr. Bilal Hassan', 'Orthopedics', 'Indus Hospital', 3500),
('Dr. Ayesha Malik', 'Pediatrics', 'National Medical Center', 2500),
('Dr. Omar Farooq', 'Oncology', 'Dow University Hospital', 6000),
('Dr. Nadia Akhtar', 'Psychiatry', 'Jinnah Postgraduate Medical Center', 3200),
('Dr. Imran Raza', 'Gastroenterology', 'PNS Shifa Hospital', 4200),
('Dr. Sana Kamran', 'Pulmonology', 'Altamash Hospital', 3800);

-- Insert DoctorAvailability
INSERT INTO DoctorAvailability (doctor_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '09:00', '17:00'),
(2, 'Tuesday', '10:00', '18:00'),
(3, 'Wednesday', '08:00', '16:00'),
(4, 'Thursday', '11:00', '19:00'),
(5, 'Friday', '07:00', '15:00'),
(6, 'Saturday', '09:30', '17:30'),
(7, 'Monday', '08:30', '16:30'),
(8, 'Wednesday', '10:00', '18:00'),
(9, 'Friday', '09:00', '17:00'),
(10, 'Sunday', '12:00', '20:00');

-- Insert Health_info
INSERT INTO Health_info (user_id, doctor_id, prescription_path) VALUES
(1, 3, '/prescriptions/user1.pdf'),
(2, 6, '/prescriptions/user2.pdf'),
(3, 1, '/prescriptions/user3.pdf'),
(4, 4, '/prescriptions/user4.pdf'),
(5, 3, '/prescriptions/user5.pdf'),
(6, 5, '/prescriptions/user6.pdf'),
(7, 7, '/prescriptions/user7.pdf'),
(8, 8, '/prescriptions/user8.pdf'),
(9, 9, '/prescriptions/user9.pdf'),
(10, 10, '/prescriptions/user10.pdf');

-- Insert Diseases
INSERT INTO Diseases (disease_name) VALUES
('Diabetes Mellitus'),
('Hypertension'),
('Asthma'),
('Migraine'),
('Osteoarthritis'),
('Epilepsy'),
('Hyperthyroidism'),
('Chronic Obstructive Pulmonary Disease'),
('Coronary Artery Disease'),
('Gastroesophageal Reflux Disease');

-- Insert SymptomsNormalized
INSERT INTO SymptomsNormalized (description) VALUES
('Increased thirst'),
('Frequent urination'),
('Chest pain'),
('Shortness of breath'),
('Headache'),
('Joint pain'),
('Seizures'),
('Weight loss'),
('Chronic cough'),
('Heartburn');

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
(1, 'Lifestyle modification and oral hypoglycemics', 'Medical'),
(2, 'ACE inhibitors and dietary changes', 'Medical'),
(3, 'Inhaled corticosteroids and bronchodilators', 'Medical'),
(4, 'Triptans and NSAIDs', 'Medical'),
(5, 'Physical therapy and pain management', 'Physical'),
(6, 'Anticonvulsant medications', 'Medical'),
(7, 'Antithyroid medications', 'Medical'),
(8, 'Pulmonary rehabilitation and oxygen therapy', 'Physical'),
(9, 'Cardiac catheterization and stenting', 'Surgical'),
(10, 'PPIs and dietary modifications', 'Medical');

-- Insert Appointments
INSERT INTO Appointments (user_id, doctor_id, date, time, status) VALUES
(1, 3, '2023-12-01', '10:00', 'Booked'),
(2, 6, '2023-12-02', '11:30', 'Completed'),
(3, 1, '2023-12-03', '14:00', 'Booked'),
(4, 4, '2023-12-04', '15:30', 'Cancelled'),
(5, 3, '2023-12-05', '09:00', 'Completed'),
(6, 5, '2023-12-06', '10:30', 'Booked'),
(7, 7, '2023-12-07', '13:00', 'Completed'),
(8, 8, '2023-12-08', '16:00', 'Booked'),
(9, 9, '2023-12-09', '11:00', 'Cancelled'),
(10, 10, '2023-12-10', '17:30', 'Booked');

-- Insert Orders
INSERT INTO Orders (user_id, medication_id, quantity, delivery_method) VALUES
(1, 1, 2, 'Home Delivery'),
(2, 2, 1, 'Pharmacy Pickup'),
(3, 3, 3, 'Home Delivery'),
(4, 4, 5, 'Express Delivery'),
(5, 5, 1, 'Pharmacy Pickup'),
(6, 6, 2, 'Home Delivery'),
(7, 7, 4, 'Express Delivery'),
(8, 8, 1, 'Pharmacy Pickup'),
(9, 9, 2, 'Home Delivery'),
(10, 10, 3, 'Express Delivery');

-- Insert HealthTips
INSERT INTO HealthTips (title, content, type, valid_from, valid_to) VALUES
('Stay Hydrated', 'Drink at least 8 glasses of water daily', 'General', '2023-01-01', '2023-12-31'),
('Winter Care', 'Protect yourself from cold weather', 'Seasonal', '2023-11-01', '2024-02-28'),
('Exercise Regularly', '30 minutes of daily exercise improves health', 'General', '2023-01-01', '2023-12-31'),
('Flu Prevention', 'Get annual flu vaccination', 'Seasonal', '2023-10-01', '2024-03-31'),
('Healthy Eating', 'Increase fruits and vegetables in diet', 'General', '2023-01-01', '2023-12-31'),
('Sun Protection', 'Use sunscreen with SPF 30+', 'Seasonal', '2023-05-01', '2023-09-30'),
('Stress Management', 'Practice meditation and yoga', 'General', '2023-01-01', '2023-12-31'),
('Diabetes Care', 'Monitor blood sugar regularly', 'General', '2023-01-01', '2023-12-31'),
('Heart Health', 'Limit saturated fats and cholesterol', 'General', '2023-01-01', '2023-12-31'),
('Sleep Hygiene', 'Maintain regular sleep schedule', 'General', '2023-01-01', '2023-12-31');

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