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
    emergency_contact_name NVARCHAR(255),
    emergency_contact_number NVARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Medical_conditions (
    condition_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    condition_name NVARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Allergies (
    allergy_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    allergy_name NVARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Medications (
    medication_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    medication_details NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Health_info (
    user_id INT PRIMARY KEY,
    current_doctor NVARCHAR(255),
    prescription_path NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);



INSERT INTO Users (email, password)
VALUES ('user@example.com', 'plaintextpassword');


select * from Users


CREATE TABLE Diseases (
    disease_id INT PRIMARY KEY IDENTITY(1,1),
    disease_name NVARCHAR(255) UNIQUE NOT NULL,
    precaution_1 NVARCHAR(255),
    precaution_2 NVARCHAR(255),
    precaution_3 NVARCHAR(255),
    precaution_4 NVARCHAR(255)
);

CREATE TABLE Symptoms (
    disease_id INT NOT NULL,
    disease_name NVARCHAR(255) NOT NULL,
    symptom_1 NVARCHAR(255),
    symptom_2 NVARCHAR(255),
    symptom_3 NVARCHAR(255),
    symptom_4 NVARCHAR(255),
    symptom_5 NVARCHAR(255),
    symptom_6 NVARCHAR(255),
    symptom_7 NVARCHAR(255),
    symptom_8 NVARCHAR(255),
    symptom_9 NVARCHAR(255),
    symptom_10 NVARCHAR(255),
    symptom_11 NVARCHAR(255),
    symptom_12 NVARCHAR(255),
    symptom_13 NVARCHAR(255),
    symptom_14 NVARCHAR(255),
    symptom_15 NVARCHAR(255),
    symptom_16 NVARCHAR(255),
    symptom_17 NVARCHAR(255),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id)
);


CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    designation NVARCHAR(255),
    speciality NVARCHAR(255) NOT NULL,
    location NVARCHAR(255),
    fee DECIMAL(10,2)
);

CREATE TABLE Doc_to_Dis (
    speciality NVARCHAR(255) NOT NULL,
    disease_id INT NOT NULL,
    disease_name NVARCHAR(255) NOT NULL,
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id)
);