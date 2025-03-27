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