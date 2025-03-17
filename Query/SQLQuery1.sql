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