



DROP TABLE IF EXISTS RemedyDetail;
DROP TABLE IF EXISTS Remedy;
DROP TABLE IF EXISTS Medicine;
DROP TABLE IF EXISTS PersonalizedHealthTips;
DROP TABLE IF EXISTS HealthAlerts;
DROP TABLE IF EXISTS HealthTips;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS SymptomCondition;
DROP TABLE IF EXISTS SymptomsNormalized;
DROP TABLE IF EXISTS DoctorDiseases;
DROP TABLE IF EXISTS Diseases;
DROP TABLE IF EXISTS DoctorAvailability;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Medications;
DROP TABLE IF EXISTS UserAllergy;
DROP TABLE IF EXISTS Allergies;
DROP TABLE IF EXISTS UserMedicalCondition;
DROP TABLE IF EXISTS Medical_conditions;
DROP TABLE IF EXISTS EmergencyContact;
DROP TABLE IF EXISTS User_details;
DROP TABLE IF EXISTS Users;










-- 1. Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL
);

-- 2. User_details
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

-- 3. EmergencyContact
CREATE TABLE EmergencyContact (
    contact_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    number NVARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 4. Medical_conditions
CREATE TABLE Medical_conditions (
    condition_id INT PRIMARY KEY IDENTITY(1,1),
    condition_name NVARCHAR(255) NOT NULL
);

-- 5. UserMedicalCondition
CREATE TABLE UserMedicalCondition (
    user_id INT NOT NULL,
    condition_id INT NOT NULL,
    PRIMARY KEY (user_id, condition_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (condition_id) REFERENCES Medical_conditions(condition_id)
);

-- 6. Allergies
CREATE TABLE Allergies (
    allergy_id INT PRIMARY KEY IDENTITY(1,1),
    allergy_name NVARCHAR(255) NOT NULL
);

-- 7. UserAllergy
CREATE TABLE UserAllergy (
    user_id INT NOT NULL,
    allergy_id INT NOT NULL,
    PRIMARY KEY (user_id, allergy_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (allergy_id) REFERENCES Allergies(allergy_id)
);

-- 8. Medications
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

-- 9. Doctors
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    specialization NVARCHAR(255) NOT NULL,
    location NVARCHAR(255) NOT NULL,
    fees DECIMAL(10,2)
);

-- 10. DoctorAvailability
CREATE TABLE DoctorAvailability (
    availability_id INT PRIMARY KEY IDENTITY(1,1),
    doctor_id INT NOT NULL,
    day_of_week NVARCHAR(10) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 11. Diseases
CREATE TABLE Diseases (
    disease_id INT PRIMARY KEY IDENTITY(1,1),
    disease_name NVARCHAR(255) UNIQUE NOT NULL
);

-- 12. DoctorDiseases (Now valid since Doctors & Diseases exist)
CREATE TABLE DoctorDiseases (
    doctor_id INT,
    disease_id INT,
    PRIMARY KEY (doctor_id, disease_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id)
);


-- 13. SymptomsNormalized
CREATE TABLE SymptomsNormalized (
    symptom_id INT PRIMARY KEY IDENTITY(1,1),
    description NVARCHAR(255) NOT NULL
);

-- 14. SymptomCondition
CREATE TABLE SymptomCondition (
    disease_id INT NOT NULL,
    symptom_id INT NOT NULL,
    PRIMARY KEY (disease_id, symptom_id),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id),
    FOREIGN KEY (symptom_id) REFERENCES SymptomsNormalized(symptom_id)
);



-- 15. Treatments
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY IDENTITY(1,1),
    disease_id INT NOT NULL,
    description NVARCHAR(MAX),
    type NVARCHAR(50),
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id)
);

-- 16. Appointments
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

-- 17. Orders
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

-- 18. HealthTips
CREATE TABLE HealthTips (
    tip_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    type NVARCHAR(50) CHECK (type IN ('Seasonal', 'General')),
    valid_from DATE,
    valid_to DATE
);

-- 19. HealthAlerts
CREATE TABLE HealthAlerts (
    alert_id INT PRIMARY KEY IDENTITY(1,1),
    day INT CHECK (day BETWEEN 1 AND 30),
    alert_short NVARCHAR(255) NOT NULL,
    alert_detailed NVARCHAR(MAX)
);

-- 20. PersonalizedHealthTips
CREATE TABLE PersonalizedHealthTips (
    personal_tip_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    condition_id INT NOT NULL,
    tip NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (condition_id) REFERENCES Medical_conditions(condition_id)
);

-- 21. Medicine
CREATE TABLE Medicine (
    medicine_id INT PRIMARY KEY IDENTITY(1,1),
    symptom_id INT NOT NULL,
    use_case NVARCHAR(MAX),
    dosage NVARCHAR(100),
    frequency NVARCHAR(100),
    FOREIGN KEY (symptom_id) REFERENCES SymptomsNormalized(symptom_id)
);

-- 22. Remedy
CREATE TABLE Remedy (
    remedy_id INT PRIMARY KEY IDENTITY(1,1),
    symptom_id INT NOT NULL,
    home_remedy NVARCHAR(255),
    instruction NVARCHAR(MAX),
    FOREIGN KEY (symptom_id) REFERENCES SymptomsNormalized(symptom_id)
);

-- 23. RemedyDetail
CREATE TABLE RemedyDetail (
    remedy_id INT PRIMARY KEY,
    full_remedy NVARCHAR(MAX),
    FOREIGN KEY (remedy_id) REFERENCES Remedy(remedy_id)
);


------------------------------------------------------------------------------------------------------------

INSERT INTO Users (email, password) VALUES
('john.doe@example.com', 'password123'),
('jane.smith@example.com', 'securepass'),
('michael.johnson@example.com', 'myp@ssword'),
('sarah.williams@example.com', 'sarah123'),
('robert.brown@example.com', 'brownie'),
('emily.davis@example.com', 'emily2023'),
('david.miller@example.com', 'davidpass'),
('jessica.wilson@example.com', 'jessica1'),
('thomas.moore@example.com', 'thomasT'),
('linda.taylor@example.com', 'lindapass'),
('richard.anderson@example.com', 'richard1'),
('susan.jackson@example.com', 'susanJ'),
('charles.white@example.com', 'charlesW'),
('patricia.harris@example.com', 'patriciaH'),
('christopher.martin@example.com', 'chrisM'),
('mary.thompson@example.com', 'maryT'),
('daniel.garcia@example.com', 'danielG'),
('jennifer.martinez@example.com', 'jennyM'),
('matthew.robinson@example.com', 'mattR'),
('lisa.clark@example.com', 'lisaC'),
('kevin.rodriguez@example.com', 'kevinR'),
('nancy.lewis@example.com', 'nancyL'),
('steven.lee@example.com', 'stevenL'),
('angela.walker@example.com', 'angelaW'),
('george.hall@example.com', 'georgeH'),
('karen.allen@example.com', 'karenA'),
('edward.young@example.com', 'edwardY'),
('betty.hernandez@example.com', 'bettyH'),
('ronald.king@example.com', 'ronaldK'),
('dorothy.wright@example.com', 'dorothyW'),
('anthony.lopez@example.com', 'anthonyL'),
('helen.hill@example.com', 'helenH'),
('donald.scott@example.com', 'donaldS'),
('carol.green@example.com', 'carolG'),
('paul.adams@example.com', 'paulA'),
('michelle.baker@example.com', 'michelleB'),
('mark.gonzalez@example.com', 'markG'),
('laura.nelson@example.com', 'lauraN'),
('james.carter@example.com', 'jamesC'),
('donna.mitchell@example.com', 'donnaM'),
('george.perez@example.com', 'georgeP'),
('rebecca.roberts@example.com', 'rebeccaR'),
('joseph.turner@example.com', 'josephT'),
('cynthia.phillips@example.com', 'cynthiaP'),
('kenneth.campbell@example.com', 'kennethC'),
('sandra.parker@example.com', 'sandraP'),
('timothy.evans@example.com', 'timothyE'),
('shirley.edwards@example.com', 'shirleyE'),
('brian.collins@example.com', 'brianC'),
('pamela.stewart@example.com', 'pamelaS');


INSERT INTO User_details (user_id, full_name, age, gender, phone_number, house_no, city, area, weight, height, disability) VALUES
(1, 'John Doe', 35, 'Male', '03001234567', '123', 'Karachi', 'Clifton', 75.5, 175.0, NULL),
(2, 'Jane Smith', 28, 'Female', '03011234567', '456', 'Karachi', 'Defence', 62.0, 165.0, NULL),
(3, 'Michael Johnson', 42, 'Male', '03021234567', '789', 'Lahore', 'Gulberg', 80.2, 180.0, 'Asthma'),
(4, 'Sarah Williams', 31, 'Female', '03031234567', '101', 'Karachi', 'North Nazimabad', 58.5, 162.0, NULL),
(5, 'Robert Brown', 50, 'Male', '03041234567', '202', 'Islamabad', 'F-7', 90.0, 185.0, 'Diabetes'),
(6, 'Emily Davis', 25, 'Female', '03051234567', '303', 'Karachi', 'PECHS', 55.0, 160.0, NULL),
(7, 'David Miller', 38, 'Male', '03061234567', '404', 'Lahore', 'Model Town', 78.0, 178.0, NULL),
(8, 'Jessica Wilson', 29, 'Female', '03071234567', '505', 'Karachi', 'Gulshan', 60.0, 167.0, NULL),
(9, 'Thomas Moore', 45, 'Male', '03081234567', '606', 'Karachi', 'Saddar', 85.0, 182.0, 'Hypertension'),
(10, 'Linda Taylor', 33, 'Female', '03091234567', '707', 'Karachi', 'Korangi', 63.5, 168.0, NULL),
(11, 'Richard Anderson', 40, 'Male', '03101234567', '808', 'Lahore', 'Johar Town', 82.0, 179.0, NULL),
(12, 'Susan Jackson', 27, 'Female', '03111234567', '909', 'Karachi', 'Malir', 59.0, 164.0, NULL),
(13, 'Charles White', 52, 'Male', '03121234567', '1010', 'Islamabad', 'G-9', 88.0, 183.0, 'Arthritis'),
(14, 'Patricia Harris', 36, 'Female', '03131234567', '1111', 'Karachi', 'Gulistan-e-Johar', 65.0, 170.0, NULL),
(15, 'Christopher Martin', 41, 'Male', '03141234567', '1212', 'Karachi', 'Bahadurabad', 79.5, 177.0, NULL),
(16, 'Mary Thompson', 30, 'Female', '03151234567', '1313', 'Lahore', 'Cantt', 61.0, 166.0, NULL),
(17, 'Daniel Garcia', 34, 'Male', '03161234567', '1414', 'Karachi', 'FB Area', 77.0, 176.0, NULL),
(18, 'Jennifer Martinez', 26, 'Female', '03171234567', '1515', 'Karachi', 'Lyari', 57.0, 163.0, 'Epilepsy'),
(19, 'Matthew Robinson', 39, 'Male', '03181234567', '1616', 'Karachi', 'Orangi', 83.0, 181.0, NULL),
(20, 'Lisa Clark', 32, 'Female', '03191234567', '1717', 'Karachi', 'Landhi', 64.0, 169.0, NULL),
(21, 'Kevin Rodriguez', 37, 'Male', '03201234567', '1818', 'Lahore', 'DHA', 81.0, 180.0, NULL),
(22, 'Nancy Lewis', 28, 'Female', '03211234567', '1919', 'Karachi', 'Gulshan-e-Iqbal', 58.0, 165.0, NULL),
(23, 'Steven Lee', 44, 'Male', '03221234567', '2020', 'Karachi', 'SITE', 86.0, 182.0, 'Heart Disease'),
(24, 'Angela Walker', 31, 'Female', '03231234567', '2121', 'Karachi', 'North Karachi', 62.5, 167.0, NULL),
(25, 'George Hall', 48, 'Male', '03241234567', '2222', 'Islamabad', 'F-8', 89.0, 184.0, NULL),
(26, 'Karen Allen', 29, 'Female', '03251234567', '2323', 'Karachi', 'Surjani Town', 60.0, 166.0, NULL),
(27, 'Edward Young', 35, 'Male', '03261234567', '2424', 'Karachi', 'Nazimabad', 76.0, 175.0, NULL),
(28, 'Betty Hernandez', 40, 'Female', '03271234567', '2525', 'Lahore', 'Shadman', 66.0, 171.0, 'Asthma'),
(29, 'Ronald King', 43, 'Male', '03281234567', '2626', 'Karachi', 'Gulshan-e-Maymar', 84.0, 181.0, NULL),
(30, 'Dorothy Wright', 33, 'Female', '03291234567', '2727', 'Karachi', 'Shah Faisal', 63.0, 168.0, NULL),
(31, 'Anthony Lopez', 38, 'Male', '03301234567', '2828', 'Karachi', 'Gulzar-e-Hijri', 80.0, 179.0, NULL),
(32, 'Helen Hill', 27, 'Female', '03311234567', '2929', 'Karachi', 'Kharadar', 59.0, 164.0, NULL),
(33, 'Donald Scott', 50, 'Male', '03321234567', '3030', 'Lahore', 'Iqbal Town', 90.0, 185.0, 'Diabetes'),
(34, 'Carol Green', 36, 'Female', '03331234567', '3131', 'Karachi', 'Gulberg', 64.5, 169.0, NULL),
(35, 'Paul Adams', 41, 'Male', '03341234567', '3232', 'Karachi', 'Saddar', 82.0, 180.0, NULL),
(36, 'Michelle Baker', 30, 'Female', '03351234567', '3333', 'Islamabad', 'G-10', 61.0, 166.0, NULL),
(37, 'Mark Gonzalez', 34, 'Male', '03361234567', '3434', 'Karachi', 'Gulshan-e-Iqbal', 78.0, 177.0, NULL),
(38, 'Laura Nelson', 29, 'Female', '03371234567', '3535', 'Karachi', 'Defence', 57.5, 163.0, NULL),
(39, 'James Carter', 45, 'Male', '03381234567', '3636', 'Karachi', 'Clifton', 85.0, 182.0, 'Hypertension'),
(40, 'Donna Mitchell', 32, 'Female', '03391234567', '3737', 'Lahore', 'Garden Town', 65.0, 170.0, NULL),
(41, 'George Perez', 39, 'Male', '03401234567', '3838', 'Karachi', 'Korangi', 83.0, 181.0, NULL),
(42, 'Rebecca Roberts', 28, 'Female', '03411234567', '3939', 'Karachi', 'Malir', 58.0, 165.0, NULL),
(43, 'Joseph Turner', 42, 'Male', '03421234567', '4040', 'Karachi', 'North Nazimabad', 87.0, 183.0, NULL),
(44, 'Cynthia Phillips', 31, 'Female', '03431234567', '4141', 'Karachi', 'PECHS', 62.0, 167.0, NULL),
(45, 'Kenneth Campbell', 47, 'Male', '03441234567', '4242', 'Islamabad', 'F-6', 88.0, 184.0, 'Arthritis'),
(46, 'Sandra Parker', 30, 'Female', '03451234567', '4343', 'Karachi', 'Gulistan-e-Johar', 60.0, 166.0, NULL),
(47, 'Timothy Evans', 35, 'Male', '03461234567', '4444', 'Karachi', 'FB Area', 79.0, 178.0, NULL),
(48, 'Shirley Edwards', 40, 'Female', '03471234567', '4545', 'Lahore', 'Model Town', 67.0, 172.0, NULL),
(49, 'Brian Collins', 36, 'Male', '03481234567', '4646', 'Karachi', 'Gulshan', 81.0, 180.0, NULL),
(50, 'Pamela Stewart', 29, 'Female', '03491234567', '4747', 'Karachi', 'Saddar', 59.0, 164.0, NULL);


INSERT INTO EmergencyContact (user_id, name, number) VALUES
(1, 'Mary Doe', '03009876543'),
(2, 'John Smith', '03019876543'),
(3, 'Lisa Johnson', '03029876543'),
(4, 'Mark Williams', '03039876543'),
(5, 'Susan Brown', '03049876543'),
(6, 'James Davis', '03059876543'),
(7, 'Jennifer Miller', '03069876543'),
(8, 'Richard Wilson', '03079876543'),
(9, 'Sarah Moore', '03089876543'),
(10, 'Michael Taylor', '03099876543'),
(11, 'Jessica Anderson', '03109876543'),
(12, 'Thomas Jackson', '03119876543'),
(13, 'Patricia White', '03129876543'),
(14, 'Charles Harris', '03139876543'),
(15, 'Nancy Martin', '03149876543'),
(16, 'Daniel Thompson', '03159876543'),
(17, 'Karen Garcia', '03169876543'),
(18, 'Edward Martinez', '03179876543'),
(19, 'Betty Robinson', '03189876543'),
(20, 'Ronald Clark', '03199876543'),
(21, 'Dorothy Rodriguez', '03209876543'),
(22, 'Anthony Lewis', '03219876543'),
(23, 'Helen Lee', '03229876543'),
(24, 'Donald Walker', '03239876543'),
(25, 'Carol Hall', '03249876543'),
(26, 'Paul Allen', '03259876543'),
(27, 'Michelle Young', '03269876543'),
(28, 'Mark Hernandez', '03279876543'),
(29, 'Laura King', '03289876543'),
(30, 'James Wright', '03299876543'),
(31, 'Donna Lopez', '03309876543'),
(32, 'George Hill', '03319876543'),
(33, 'Rebecca Scott', '03329876543'),
(34, 'Joseph Green', '03339876543'),
(35, 'Cynthia Adams', '03349876543'),
(36, 'Kenneth Baker', '03359876543'),
(37, 'Sandra Gonzalez', '03369876543'),
(38, 'Timothy Nelson', '03379876543'),
(39, 'Shirley Carter', '03389876543'),
(40, 'Brian Mitchell', '03399876543'),
(41, 'Pamela Perez', '03409876543'),
(42, 'Kevin Roberts', '03419876543'),
(43, 'Angela Turner', '03429876543'),
(44, 'Steven Phillips', '03439876543'),
(45, 'Lisa Campbell', '03449876543'),
(46, 'Robert Parker', '03459876543'),
(47, 'Emily Evans', '03469876543'),
(48, 'David Edwards', '03479876543'),
(49, 'Mary Collins', '03489876543'),
(50, 'John Stewart', '03499876543');


INSERT INTO Medical_conditions (condition_name) VALUES
('Hypertension'),
('Diabetes Type 1'),
('Diabetes Type 2'),
('Asthma'),
('Chronic Obstructive Pulmonary Disease'),
('Coronary Artery Disease'),
('Heart Failure'),
('Arrhythmia'),
('Hyperlipidemia'),
('Osteoarthritis'),
('Rheumatoid Arthritis'),
('Osteoporosis'),
('Gout'),
('Chronic Kidney Disease'),
('End Stage Renal Disease'),
('Peptic Ulcer Disease'),
('Gastroesophageal Reflux Disease'),
('Irritable Bowel Syndrome'),
('Crohn''s Disease'),
('Ulcerative Colitis'),
('Cirrhosis'),
('Hepatitis B'),
('Hepatitis C'),
('HIV/AIDS'),
('Hypothyroidism'),
('Hyperthyroidism'),
('Cushing''s Syndrome'),
('Addison''s Disease'),
('Migraine'),
('Epilepsy'),
('Parkinson''s Disease'),
('Alzheimer''s Disease'),
('Multiple Sclerosis'),
('Amyotrophic Lateral Sclerosis'),
('Schizophrenia'),
('Bipolar Disorder'),
('Major Depressive Disorder'),
('Generalized Anxiety Disorder'),
('Obsessive-Compulsive Disorder'),
('Post-Traumatic Stress Disorder'),
('Autism Spectrum Disorder'),
('Attention Deficit Hyperactivity Disorder'),
('Chronic Fatigue Syndrome'),
('Fibromyalgia'),
('Lupus'),
('Scleroderma'),
('Psoriasis'),
('Eczema'),
('Anemia'),
('Hemophilia'),
('Leukemia');


INSERT INTO UserMedicalCondition (user_id, condition_id) VALUES
(1, 1), (1, 9),
(2, 3),
(3, 4),
(4, 38),
(5, 2), (5, 1),
(6, 29),
(7, 10),
(8, 37),
(9, 1),
(10, 48),
(11, 15),
(12, 30),
(13, 10), (13, 12),
(14, 17),
(15, 5),
(16, 36),
(17, 9),
(18, 30),
(19, 1), (19, 9),
(20, 39),
(21, 22),
(22, 37),
(23, 6),
(24, 17),
(25, 3),
(26, 29),
(27, 10),
(28, 4),
(29, 1), (29, 9),
(30, 48),
(31, 15),
(32, 30),
(33, 2), (33, 1),
(34, 17),
(35, 5),
(36, 36),
(37, 9),
(38, 30),
(39, 1), (39, 9),
(40, 39),
(41, 22),
(42, 37),
(43, 6),
(44, 17),
(45, 10), (45, 12),
(46, 29),
(47, 10),
(48, 4),
(49, 1), (49, 9),
(50, 48);


INSERT INTO Allergies (allergy_name) VALUES
('Penicillin'),
('Sulfa Drugs'),
('Aspirin'),
('Ibuprofen'),
('Naproxen'),
('Codeine'),
('Morphine'),
('Latex'),
('Pollen'),
('Dust Mites'),
('Mold'),
('Pet Dander'),
('Eggs'),
('Milk'),
('Peanuts'),
('Tree Nuts'),
('Soy'),
('Wheat'),
('Fish'),
('Shellfish'),
('Sesame'),
('Mustard'),
('Celery'),
('Lupin'),
('Sulfites'),
('Nickel'),
('Fragrance'),
('Formaldehyde'),
('Balsam of Peru'),
('Cobalt'),
('Chromium'),
('Neomycin'),
('Bacitracin'),
('Polymyxin B'),
('Thimerosal'),
('Chlorhexidine'),
('Propylene Glycol'),
('Lanolin'),
('Coconut Oil'),
('Aloe Vera'),
('Tea Tree Oil'),
('Bee Stings'),
('Wasp Stings'),
('Fire Ant Stings'),
('Jellyfish Stings'),
('Mosquito Bites'),
('Cockroaches'),
('Rodent Dander'),
('Grass Pollen'),
('Ragweed Pollen'),
('Birch Pollen');


INSERT INTO UserAllergy (user_id, allergy_id) VALUES
(1, 1),
(2, 15),
(3, 9),
(4, 5),
(5, 2),
(6, 41),
(7, 3),
(8, 16),
(9, 1),
(10, 19),
(11, 42),
(12, 17),
(13, 4),
(14, 20),
(15, 10),
(16, 43),
(17, 5),
(18, 21),
(19, 11),
(20, 44),
(21, 6),
(22, 22),
(23, 12),
(24, 45),
(25, 7),
(26, 23),
(27, 13),
(28, 46),
(29, 8),
(30, 24),
(31, 14),
(32, 47),
(33, 25),
(34, 26),
(35, 15),
(36, 48),
(37, 16),
(38, 27),
(39, 17),
(40, 49),
(41, 18),
(42, 28),
(43, 19),
(44, 50),
(45, 20),
(46, 29),
(47, 21),
(48, 30),
(49, 22),
(50, 31);


INSERT INTO Medications (user_id, name, dosage, frequency, next_dose, supply_remaining) VALUES
(1, 'Lisinopril', '10mg', 'Once daily', '2023-06-15 08:00:00', 30),
(1, 'Atorvastatin', '20mg', 'Once at bedtime', '2023-06-15 22:00:00', 30),
(2, 'Metformin', '500mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(3, 'Albuterol Inhaler', '90mcg/spray', 'As needed', '2023-06-15 12:00:00', 100),
(4, 'Sertraline', '50mg', 'Once daily', '2023-06-15 09:00:00', 30),
(5, 'Insulin Glargine', '20 units', 'Once at bedtime', '2023-06-15 22:00:00', 15),
(5, 'Lisinopril', '5mg', 'Once daily', '2023-06-15 08:00:00', 30),
(6, 'Sumatriptan', '50mg', 'As needed for migraine', '2023-06-15 14:00:00', 9),
(7, 'Ibuprofen', '400mg', 'Every 6 hours as needed', '2023-06-15 13:00:00', 20),
(8, 'Venlafaxine', '75mg', 'Once daily', '2023-06-15 10:00:00', 30),
(9, 'Amlodipine', '5mg', 'Once daily', '2023-06-15 08:00:00', 30),
(10, 'Hydrocortisone Cream', '1%', 'Apply twice daily', '2023-06-15 08:00:00', 1),
(11, 'Furosemide', '40mg', 'Once daily', '2023-06-15 09:00:00', 30),
(12, 'Levetiracetam', '500mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(13, 'Acetaminophen', '500mg', 'Every 6 hours as needed', '2023-06-15 12:00:00', 24),
(14, 'Omeprazole', '20mg', 'Once daily', '2023-06-15 08:00:00', 30),
(15, 'Tiotropium Inhaler', '18mcg', 'Once daily', '2023-06-15 08:00:00', 30),
(16, 'Lithium', '300mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(17, 'Rosuvastatin', '10mg', 'Once daily', '2023-06-15 20:00:00', 30),
(18, 'Valproic Acid', '500mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(19, 'Losartan', '50mg', 'Once daily', '2023-06-15 08:00:00', 30),
(19, 'Atorvastatin', '40mg', 'Once daily', '2023-06-15 20:00:00', 30),
(20, 'Fluoxetine', '20mg', 'Once daily', '2023-06-15 09:00:00', 30),
(21, 'Entecavir', '0.5mg', 'Once daily', '2023-06-15 08:00:00', 30),
(22, 'Duloxetine', '60mg', 'Once daily', '2023-06-15 10:00:00', 30),
(23, 'Clopidogrel', '75mg', 'Once daily', '2023-06-15 08:00:00', 30),
(24, 'Pantoprazole', '40mg', 'Once daily', '2023-06-15 08:00:00', 30),
(25, 'Glimepiride', '2mg', 'Once daily', '2023-06-15 08:00:00', 30),
(26, 'Rizatriptan', '10mg', 'As needed for migraine', '2023-06-15 14:00:00', 6),
(27, 'Meloxicam', '7.5mg', 'Once daily', '2023-06-15 08:00:00', 30),
(28, 'Fluticasone Inhaler', '110mcg', 'Twice daily', '2023-06-15 08:00:00', 60),
(29, 'Carvedilol', '12.5mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(29, 'Atorvastatin', '20mg', 'Once daily', '2023-06-15 20:00:00', 30),
(30, 'Tacrolimus Ointment', '0.1%', 'Apply twice daily', '2023-06-15 08:00:00', 1),
(31, 'Spironolactone', '25mg', 'Once daily', '2023-06-15 09:00:00', 30),
(32, 'Lamotrigine', '100mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(33, 'Insulin Aspart', 'Variable', 'With meals', '2023-06-15 12:00:00', 30),
(33, 'Lisinopril', '10mg', 'Once daily', '2023-06-15 08:00:00', 30),
(34, 'Esomeprazole', '40mg', 'Once daily', '2023-06-15 08:00:00', 30),
(35, 'Umeclidinium Inhaler', '62.5mcg', 'Once daily', '2023-06-15 08:00:00', 30),
(36, 'Quetiapine', '200mg', 'At bedtime', '2023-06-15 22:00:00', 30),
(37, 'Pravastatin', '40mg', 'At bedtime', '2023-06-15 22:00:00', 30),
(38, 'Carbamazepine', '200mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(39, 'Hydrochlorothiazide', '25mg', 'Once daily', '2023-06-15 08:00:00', 30),
(39, 'Simvastatin', '20mg', 'At bedtime', '2023-06-15 22:00:00', 30),
(40, 'Paroxetine', '20mg', 'Once daily', '2023-06-15 09:00:00', 30),
(41, 'Tenofovir', '300mg', 'Once daily', '2023-06-15 08:00:00', 30),
(42, 'Bupropion', '150mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(43, 'Aspirin', '81mg', 'Once daily', '2023-06-15 08:00:00', 30),
(44, 'Ranitidine', '150mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(45, 'Celecoxib', '200mg', 'Once daily', '2023-06-15 08:00:00', 30),
(46, 'Zolmitriptan', '2.5mg', 'As needed for migraine', '2023-06-15 14:00:00', 6),
(47, 'Diclofenac', '50mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(48, 'Salmeterol Inhaler', '50mcg', 'Twice daily', '2023-06-15 08:00:00', 60),
(49, 'Metoprolol', '50mg', 'Twice daily', '2023-06-15 08:00:00', 60),
(49, 'Rosuvastatin', '10mg', 'Once daily', '2023-06-15 20:00:00', 30),
(50, 'Pimecrolimus Cream', '1%', 'Apply twice daily', '2023-06-15 08:00:00', 1);




INSERT INTO Doctors (name, specialization, location, fees) VALUES
('Dr. Imran Siddiqui', 'Neurology', 'Liaquat National Hospital, Karachi', 2517),
('Dr. Nida Khalid', 'Psychiatry', 'South City Hospital, Karachi', 2452),
('Dr. Tehmina Sheikh', 'Oncology', 'Jinnah Postgraduate Medical Center, Karachi', 2913),
('Dr. Rabia Hassan', 'Neurology', 'Liaquat National Hospital, Karachi', 3582),
('Dr. Asim Malik', 'Neurology', 'Jinnah Postgraduate Medical Center, Karachi', 2879),
('Dr. Omar Khalid', 'Orthopedics', 'Jinnah Postgraduate Medical Center, Karachi', 3022),
('Dr. Kiran Sheikh', 'Cardiology', 'PNS Shifa, Karachi', 3071),
('Dr. Ali Hassan', 'Cardiology', 'Aga Khan Hospital, Karachi', 4418),
('Dr. Tehmina Qureshi', 'Pulmonology', 'Aga Khan Hospital, Karachi', 4430),
('Dr. Omar Ali', 'Pulmonology', 'South City Hospital, Karachi', 3793),
('Dr. Sara Hassan', 'Cardiology', 'Aga Khan Hospital, Karachi', 2213),
('Dr. Rabia Jamal', 'Dermatology', 'Ziauddin Hospital, Karachi', 3421),
('Dr. Ayesha Tariq', 'Cardiology', 'Ziauddin Hospital, Karachi', 2297),
('Dr. Saad Raza', 'Psychiatry', 'South City Hospital, Karachi', 2875),
('Dr. Haroon Javed', 'Nephrology', 'Jinnah Postgraduate Medical Center, Karachi', 4115),
('Dr. Noreen Sheikh', 'Orthopedics', 'Ziauddin Hospital, Karachi', 2163),
('Dr. Bilal Jamal', 'Pulmonology', 'PNS Shifa, Karachi', 4372),
('Dr. Leena Rehman', 'Oncology', 'Ziauddin Hospital, Karachi', 2669),
('Dr. Usman Tariq', 'Neurology', 'Jinnah Postgraduate Medical Center, Karachi', 2403),
('Dr. Beenish Ali', 'Dermatology', 'South City Hospital, Karachi', 2244),
('Dr. Hina Raza', 'Psychiatry', 'PNS Shifa, Karachi', 3673),
('Dr. Salman Javed', 'Oncology', 'Aga Khan Hospital, Karachi', 4128),
('Dr. Waleed Qureshi', 'Nephrology', 'Ziauddin Hospital, Karachi', 4306),
('Dr. Zubair Farooq', 'Cardiology', 'Liaquat National Hospital, Karachi', 4083),
('Dr. Adeel Malik', 'Endocrinology', 'Liaquat National Hospital, Karachi', 2728),
('Dr. Sana Akhtar', 'Orthopedics', 'Aga Khan Hospital, Karachi', 3001),
('Dr. Lubna Tariq', 'Neurology', 'South City Hospital, Karachi', 4420),
('Dr. Talha Khan', 'Gastroenterology', 'PNS Shifa, Karachi', 2366),
('Dr. Iqra Rehman', 'Gastroenterology', 'Ziauddin Hospital, Karachi', 2630),
('Dr. Faisal Ali', 'Orthopedics', 'Jinnah Postgraduate Medical Center, Karachi', 2704),
('Dr. Yasmin Malik', 'Pulmonology', 'PNS Shifa, Karachi', 3604),
('Dr. Hina Khan', 'Dermatology', 'Aga Khan Hospital, Karachi', 2606),
('Dr. Waleed Siddiqui', 'Cardiology', 'South City Hospital, Karachi', 2781),
('Dr. Zara Qureshi', 'Endocrinology', 'Liaquat National Hospital, Karachi', 3129),
('Dr. Khalid Ahmed', 'Psychiatry', 'Jinnah Postgraduate Medical Center, Karachi', 3847),
('Dr. Saima Riaz', 'Neurology', 'PNS Shifa, Karachi', 4376),
('Dr. Noman Akhtar', 'Gastroenterology', 'Aga Khan Hospital, Karachi', 3274),
('Dr. Jawad Butt', 'Endocrinology', 'Ziauddin Hospital, Karachi', 2582),
('Dr. Zainab Farooq', 'Pulmonology', 'Liaquat National Hospital, Karachi', 4027),
('Dr. Mariam Iqbal', 'Nephrology', 'South City Hospital, Karachi', 3081),
('Dr. Asad Raza', 'Orthopedics', 'Ziauddin Hospital, Karachi', 2453),
('Dr. Kirtan Sheikh', 'Cardiology', 'Aga Khan Hospital, Karachi', 3487),
('Dr. Mehwish Siddiqui', 'Endocrinology', 'South City Hospital, Karachi', 2242),
('Dr. Shahid Khan', 'Psychiatry', 'Liaquat National Hospital, Karachi', 4321),
('Dr. Ayesha Naz', 'Dermatology', 'Jinnah Postgraduate Medical Center, Karachi', 2388),
('Dr. Noor Ahmed', 'Oncology', 'PNS Shifa, Karachi', 4260),
('Dr. Farah Malik', 'Gastroenterology', 'South City Hospital, Karachi', 4107),
('Dr. Rehman Tariq', 'Nephrology', 'Jinnah Postgraduate Medical Center, Karachi', 4084),
('Dr. Fatima Jamal', 'Cardiology', 'Ziauddin Hospital, Karachi', 3643),
('Dr. Noman Sheikh', 'Orthopedics', 'PNS Shifa, Karachi', 2401);


INSERT INTO DoctorAvailability (doctor_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '09:00', '17:00'),
(1, 'Wednesday', '09:00', '13:00'),
(2, 'Tuesday', '10:00', '16:00'),
(2, 'Friday', '14:00', '18:00'),
(3, 'Thursday', '08:00', '12:00'),
(4, 'Monday', '11:00', '19:00'),
(5, 'Wednesday', '09:30', '17:30'),
(6, 'Friday', '08:00', '16:00'),
(7, 'Tuesday', '13:00', '21:00'),
(8, 'Saturday', '10:00', '14:00'),
(9, 'Monday', '08:30', '16:30'),
(10, 'Thursday', '09:00', '18:00'),
(11, 'Wednesday', '10:00', '15:00'),
(12, 'Friday', '07:00', '12:00'),
(13, 'Tuesday', '09:00', '17:00'),
(14, 'Sunday', '10:00', '16:00'),
(15, 'Monday', '12:00', '20:00'),
(16, 'Thursday', '08:00', '14:00'),
(17, 'Saturday', '09:00', '13:00'),
(18, 'Wednesday', '14:00', '18:00'),
(19, 'Friday', '10:00', '16:00'),
(20, 'Tuesday', '08:30', '16:30'),
(21, 'Monday', '09:00', '17:00'),
(22, 'Thursday', '11:00', '19:00'),
(23, 'Wednesday', '08:00', '12:00'),
(24, 'Sunday', '09:00', '15:00'),
(25, 'Friday', '13:00', '21:00'),
(26, 'Tuesday', '10:00', '18:00'),
(27, 'Monday', '07:00', '15:00'),
(28, 'Saturday', '09:00', '17:00'),
(29, 'Wednesday', '08:30', '16:30'),
(30, 'Thursday', '14:00', '22:00'),
(31, 'Friday', '09:00', '17:00'),
(32, 'Monday', '10:00', '18:00'),
(33, 'Tuesday', '08:00', '16:00'),
(34, 'Sunday', '12:00', '20:00'),
(35, 'Wednesday', '07:30', '15:30'),
(36, 'Thursday', '09:00', '17:00'),
(37, 'Saturday', '10:00', '18:00'),
(38, 'Friday', '08:00', '16:00'),
(39, 'Monday', '11:00', '19:00'),
(40, 'Tuesday', '09:00', '17:00'),
(41, 'Wednesday', '14:00', '22:00'),
(42, 'Thursday', '08:00', '12:00'),
(43, 'Sunday', '09:00', '15:00'),
(44, 'Friday', '10:00', '18:00'),
(45, 'Monday', '07:00', '15:00'),
(46, 'Tuesday', '08:30', '16:30'),
(47, 'Wednesday', '09:00', '17:00'),
(48, 'Saturday', '10:00', '18:00'),
(49, 'Thursday', '11:00', '19:00'),
(50, 'Friday', '08:00', '16:00');



INSERT INTO Diseases (disease_name) VALUES
('Hypertension'),
('Type 1 Diabetes'),
('Type 2 Diabetes'),
('Bronchial Asthma'),
('Chronic Obstructive Pulmonary Disease'),
('Coronary Artery Disease'),
('Congestive Heart Failure'),
('Atrial Fibrillation'),
('Hypercholesterolemia'),
('Osteoarthritis'),
('Rheumatoid Arthritis'),
('Osteoporosis'),
('Gout'),
('Chronic Kidney Disease'),
('End-Stage Renal Disease'),
('Peptic Ulcer Disease'),
('Gastroesophageal Reflux Disease'),
('Irritable Bowel Syndrome'),
('Crohn''s Disease'),
('Ulcerative Colitis'),
('Alcoholic Cirrhosis'),
('Hepatitis B'),
('Hepatitis C'),
('HIV/AIDS'),
('Hypothyroidism'),
('Hyperthyroidism'),
('Migraine'),
('Epilepsy'),
('Parkinson''s Disease'),
('Alzheimer''s Disease'),
('Multiple Sclerosis'),
('Major Depressive Disorder'),
('Bipolar Disorder'),
('Generalized Anxiety Disorder'),
('Obsessive-Compulsive Disorder'),
('Schizophrenia'),
('Psoriasis'),
('Eczema'),
('Systemic Lupus Erythematosus'),
('Fibromyalgia'),
('Chronic Fatigue Syndrome'),
('Malaria'),
('Dengue Fever'),
('Tuberculosis'),
('Pneumonia'),
('Influenza'),
('COVID-19'),
('Chickenpox'),
('Measles'),
('Hepatitis A'),
('Yellow Fever');


INSERT INTO DoctorDiseases (doctor_id, disease_id) VALUES
(1, 1), (1, 6), (1, 7),
(2, 2), (2, 3), (2, 24),
(3, 4), (3, 5),
(4, 32), (4, 33), (4, 34),
(5, 16), (5, 17),
(6, 27), (6, 28),
(7, 10), (7, 11),
(8, 37), (8, 38),
(9, 13), (9, 14),
(10, 39), (10, 40),
(11, 1), (11, 8),
(12, 3), (12, 24),
(13, 4), (13, 45),
(14, 33), (14, 35),
(15, 16), (15, 18),
(16, 27), (16, 29),
(17, 10), (17, 12),
(18, 37), (18, 47),
(19, 14), (19, 15),
(20, 40), (20, 48),
(21, 6), (21, 7),
(22, 24), (22, 25),
(23, 5), (23, 45),
(24, 34), (24, 35),
(25, 17), (25, 19),
(26, 28), (26, 30),
(27, 11), (27, 12),
(28, 38), (28, 47),
(29, 15), (29, 49),
(30, 41), (30, 50),
(31, 8), (31, 9),
(32, 25), (32, 26),
(33, 45), (33, 46),
(34, 35), (34, 36),
(35, 19), (35, 20),
(36, 30), (36, 31),
(37, 12), (37, 13),
(38, 47), (38, 48),
(39, 49), (39, 50),
(40, 41), (40, 42),
(41, 9), (41, 1),
(42, 26), (42, 27),
(43, 46), (43, 47),
(44, 36), (44, 37),
(45, 20), (45, 21),
(46, 31), (46, 32),
(47, 13), (47, 14),
(48, 48), (48, 49),
(49, 50), (49, 42),
(50, 43), (50, 44);



INSERT INTO SymptomsNormalized (description) VALUES
('Chest pain'),
('Shortness of breath'),
('Persistent cough'),
('Wheezing'),
('Fatigue'),
('Palpitations'),
('High blood pressure'),
('Excessive thirst'),
('Frequent urination'),
('Unexplained weight loss'),
('Blurred vision'),
('Tingling in hands/feet'),
('Chronic cough'),
('Phlegm production'),
('Chest tightness'),
('Joint pain'),
('Joint swelling'),
('Morning stiffness'),
('Back pain'),
('Loss of height over time'),
('Sudden joint pain'),
('Redness in joints'),
('Swollen big toe'),
('Decreased urine output'),
('Swelling in legs'),
('Nausea'),
('Heartburn'),
('Abdominal pain'),
('Diarrhea'),
('Blood in stool'),
('Jaundice'),
('Abdominal swelling'),
('Fever'),
('Night sweats'),
('Skin rash'),
('Depressed mood'),
('Mania episodes'),
('Excessive worry'),
('Obsessive thoughts'),
('Hallucinations'),
('Delusions'),
('Scaly skin patches'),
('Itchy skin'),
('Butterfly-shaped facial rash'),
('Muscle pain'),
('Persistent tiredness'),
('High fever'),
('Severe headache'),
('Muscle aches'),
('Runny nose'),
('Skin blisters');


INSERT INTO SymptomCondition (disease_id, symptom_id) VALUES
(1, 7), (1, 5), (1, 2),  -- Hypertension: High BP, Fatigue, Shortness of breath
(2, 8), (2, 9), (2, 10), -- Type 1 Diabetes: Thirst, Frequent urination, Weight loss
(3, 8), (3, 9), (3, 12), -- Type 2 Diabetes: Thirst, Frequent urination, Tingling
(4, 3), (4, 4), (4, 15), -- Asthma: Cough, Wheezing, Chest tightness
(5, 3), (5, 14), (5, 15), -- COPD: Cough, Phlegm, Chest tightness
(6, 1), (6, 2), (6, 6),  -- CAD: Chest pain, Shortness, Palpitations
(7, 2), (7, 5), (7, 25), -- CHF: Shortness, Fatigue, Leg swelling
(8, 6), (8, 1), (8, 5),  -- A-fib: Palpitations, Chest pain, Fatigue
(9, 7), (9, 5),          -- High cholesterol: High BP, Fatigue
(10, 16), (10, 17), (10, 19), -- Osteoarthritis: Joint pain, swelling, Back pain
(11, 16), (11, 17), (11, 18), -- Rheumatoid Arthritis: Joint pain, swelling, stiffness
(12, 19), (12, 20),       -- Osteoporosis: Back pain, Height loss
(13, 21), (13, 22), (13, 23), -- Gout: Sudden pain, Redness, Swollen toe
(14, 24), (14, 25), (14, 5),  -- CKD: Low urine, Swelling, Fatigue
(15, 24), (15, 25), (15, 26), -- ESRD: Low urine, Swelling, Nausea
(16, 27), (16, 28),       -- PUD: Heartburn, Abdominal pain
(17, 27), (17, 28), (17, 3),  -- GERD: Heartburn, Abdominal pain, Cough
(18, 28), (18, 29),       -- IBS: Abdominal pain, Diarrhea
(19, 28), (19, 29), (19, 30), -- Crohn's: Abdominal pain, Diarrhea, Bloody stool
(20, 28), (20, 29), (20, 30), -- UC: Abdominal pain, Diarrhea, Bloody stool
(21, 31), (21, 32),       -- Cirrhosis: Jaundice, Abdominal swelling
(22, 31), (22, 33), (22, 5),  -- Hep B: Jaundice, Fever, Fatigue
(23, 31), (23, 33), (23, 5),  -- Hep C: Jaundice, Fever, Fatigue
(24, 33), (24, 34), (24, 5),  -- HIV: Fever, Night sweats, Fatigue
(25, 5), (25, 35), (25, 10),  -- Hypothyroid: Fatigue, Skin rash, Weight gain
(26, 6), (26, 10), (26, 35),  -- Hyperthyroid: Palpitations, Weight loss, Skin rash
(27, 47), (27, 48), (27, 26), -- Migraine: Headache, Muscle aches, Nausea
(28, 39), (28, 40),       -- Epilepsy: Hallucinations, Delusions
(29, 16), (29, 39), (29, 40), -- Parkinson's: Joint pain, Hallucinations, Delusions
(30, 35), (30, 39), (30, 40), -- Alzheimer's: Skin rash, Hallucinations, Delusions
(31, 16), (31, 17), (31, 5),  -- MS: Joint pain, swelling, Fatigue
(32, 35), (32, 5), (32, 36),  -- Depression: Skin rash, Fatigue, Depressed mood
(33, 35), (33, 37), (33, 36), -- Bipolar: Skin rash, Mania, Depression
(34, 38), (34, 39),       -- Anxiety: Obsessive thoughts, Hallucinations
(35, 38), (35, 39), (35, 40), -- OCD: Obsessions, Hallucinations, Delusions
(36, 39), (36, 40),       -- Schizophrenia: Hallucinations, Delusions
(37, 41), (37, 42), (37, 43), -- Psoriasis: Scaly skin, Itching, Butterfly rash
(38, 42), (38, 43),       -- Eczema: Itching, Butterfly rash
(39, 43), (39, 44), (39, 5),  -- Lupus: Butterfly rash, Muscle pain, Fatigue
(40, 44), (40, 45),       -- Fibromyalgia: Muscle pain, Fatigue
(41, 45), (41, 5),        -- CFS: Fatigue, Persistent tiredness
(42, 33), (42, 46), (42, 47), -- Malaria: Fever, High fever, Headache
(43, 33), (43, 46), (43, 48), -- Dengue: Fever, High fever, Muscle aches
(44, 3), (44, 33), (44, 14),  -- TB: Cough, Fever, Phlegm
(45, 3), (45, 47), (45, 49),  -- Pneumonia: Cough, Headache, Runny nose
(46, 33), (46, 47), (46, 50), -- Flu: Fever, Headache, Blisters
(47, 42), (47, 43), (47, 50), -- Chickenpox: Itching, Rash, Blisters
(48, 42), (48, 44), (48, 50), -- Measles: Itching, Muscle pain, Blisters
(49, 31), (49, 32), (49, 33), -- Hep A: Jaundice, Swelling, Fever
(50, 33), (50, 49), (50, 48); -- Yellow Fever: Fever, Runny nose, Muscle aches


INSERT INTO Treatments (disease_id, description, type) VALUES
(1, 'Lisinopril (ACE inhibitor), Amlodipine (calcium channel blocker), Hydrochlorothiazide (diuretic), DASH diet', 'Medication'),
(2, 'Insulin injections (rapid/long-acting), Continuous glucose monitoring, Carbohydrate counting', 'Medication'),
(3, 'Metformin, SGLT2 inhibitors (Empagliflozin), GLP-1 agonists (Liraglutide), Dietary modifications', 'Medication'),
(4, 'Salbutamol inhaler (rescue), Fluticasone-salmeterol (preventive), Montelukast (leukotriene modifier)', 'Medication'),
(5, 'Tiotropium (Spiriva), Roflumilast (PDE4 inhibitor), Pulmonary rehabilitation, Oxygen therapy', 'Medication'),
(6, 'Atorvastatin (statin), Clopidogrel (antiplatelet), Coronary angioplasty with stent placement', 'Surgery'),
(7, 'Furosemide (diuretic), Carvedilol (beta-blocker), Sacubitril-valsartan (ARNI)', 'Medication'),
(8, 'Apixaban (anticoagulant), Metoprolol (rate control), Electrical cardioversion', 'Procedure'),
(9, 'Rosuvastatin, Ezetimibe, Therapeutic lifestyle changes', 'Medication'),
(10, 'Acetaminophen, Celecoxib (COX-2 inhibitor), Hyaluronic acid injections, Knee replacement', 'Surgery'),
(11, 'Methotrexate, Adalimumab (TNF inhibitor), Physical therapy', 'Medication'),
(12, 'Alendronate (bisphosphonate), Denosumab (RANKL inhibitor), Calcium/Vitamin D supplementation', 'Medication'),
(13, 'Colchicine (acute), Allopurinol (chronic), Febuxostat (XOI)', 'Medication'),
(14, 'ACE inhibitors (renal protection), Sodium bicarbonate (metabolic acidosis), Hemodialysis', 'Procedure'),
(15, 'Hemodialysis 3x/week, Peritoneal dialysis, Kidney transplantation', 'Surgery'),
(16, 'Omeprazole (PPI), Clarithromycin+Amoxicillin (H. pylori eradication)', 'Medication'),
(17, 'Pantoprazole (PPI), Lifestyle modifications (elevate head, avoid late meals)', 'Medication'),
(18, 'Psyllium husk (fiber), Dicyclomine (antispasmodic), Low FODMAP diet', 'Medication'),
(19, 'Infliximab (anti-TNF), Budesonide (steroid), Strictureplasty surgery', 'Surgery'),
(20, 'Mesalamine (5-ASA), Vedolizumab (integrin inhibitor), Total colectomy', 'Surgery'),
(21, 'Alcohol cessation, Spironolactone+Furosemide (diuretics), Liver transplant', 'Surgery'),
(22, 'Tenofovir disoproxil, Entecavir, Regular LFT monitoring', 'Medication'),
(23, 'Sofosbuvir-Velpatasvir (direct-acting antivirals), Fibroscan monitoring', 'Medication'),
(24, 'HAART (Tenofovir+Emtricitabine+Dolutegravir), Pneumocystis pneumonia prophylaxis', 'Medication'),
(25, 'Levothyroxine (T4 replacement), TSH monitoring every 6-12 weeks', 'Medication'),
(26, 'Methimazole (thionamide), Radioactive iodine ablation, Thyroidectomy', 'Surgery'),
(27, 'Sumatriptan (5-HT1 agonist), Topiramate (prophylaxis), CGRP antagonists', 'Medication'),
(28, 'Levetiracetam, Lamotrigine, Vagus nerve stimulation', 'Procedure'),
(29, 'Levodopa-Carbidopa, Pramipexole (dopamine agonist), Deep brain stimulation', 'Surgery'),
(30, 'Donepezil (cholinesterase inhibitor), Memantine (NMDA antagonist), Cognitive therapy', 'Therapy'),
(31, 'Interferon-beta, Ocrelizumab (CD20 inhibitor), Physical rehabilitation', 'Medication'),
(32, 'Escitalopram (SSRI), Venlafaxine (SNRI), Cognitive behavioral therapy', 'Therapy'),
(33, 'Lithium carbonate, Quetiapine (mood stabilizer), Psychoeducation', 'Therapy'),
(34, 'Sertraline (SSRI), Buspirone (anxiolytic), Exposure therapy', 'Therapy'),
(35, 'Fluoxetine (SSRI), Clomipramine (TCA), Exposure-response prevention', 'Therapy'),
(36, 'Olanzapine, Risperidone, Social skills training', 'Therapy'),
(37, 'Topical calcipotriol (vitamin D analog), Secukinumab (IL-17 inhibitor), Phototherapy', 'Medication'),
(38, 'Topical tacrolimus (calcineurin inhibitor), Dupilumab (IL-4/13 inhibitor), Wet wrap therapy', 'Medication'),
(39, 'Hydroxychloroquine, Belimumab (BAFF inhibitor), Sun protection', 'Medication'),
(40, 'Pregabalin (alpha-2-delta ligand), Duloxetine (SNRI), Graded exercise', 'Therapy'),
(41, 'Cognitive behavioral therapy, Graded exercise therapy, Sleep hygiene', 'Therapy'),
(42, 'Artemether-Lumefantrine (ACT), IV quinine for severe cases', 'Medication'),
(43, 'Supportive care (hydration), Platelet transfusion if <20,000', 'Medication'),
(44, 'Rifampin+Isoniazid+Pyrazinamide+Ethambutol (2 months), then Rifampin+Isoniazid (4 months)', 'Medication'),
(45, 'Amoxicillin-Clavulanate (community-acquired), Azithromycin (atypical), Oxygen support', 'Medication'),
(46, 'Oseltamivir (neuraminidase inhibitor), Zanamivir (inhaled), Annual vaccination', 'Medication'),
(47, 'Nirmatrelvir-Ritonavir (Paxlovid), Dexamethasone (severe cases)', 'Medication'),
(48, 'Acyclovir (antiviral), Valacyclovir (prophylaxis in immunocompromised)', 'Medication'),
(49, 'MMR vaccine (prevention), Ribavirin (for complications)', 'Medication'),
(50, 'Hepatitis A vaccine, Supportive care (no specific antiviral)', 'Medication'),
(51, 'Yellow fever vaccine (17D strain), Supportive care (avoid aspirin)', 'Medication');


INSERT INTO Appointments (user_id, doctor_id, date, time, status) VALUES
(1, 1, '2023-06-15', '10:00', 'Booked'),
(2, 5, '2023-06-14', '14:30', 'Completed'),
(3, 12, '2023-06-13', '11:15', 'Cancelled'),
(4, 8, '2023-06-16', '09:45', 'Booked'),
(5, 3, '2023-06-12', '16:00', 'Completed'),
(6, 19, '2023-06-17', '13:30', 'Booked'),
(7, 25, '2023-06-15', '10:45', 'Booked'),
(8, 32, '2023-06-14', '15:20', 'Completed'),
(9, 7, '2023-06-18', '08:30', 'Booked'),
(10, 41, '2023-06-13', '12:00', 'Cancelled'),
(11, 15, '2023-06-16', '17:15', 'Booked'),
(12, 28, '2023-06-14', '10:00', 'Completed'),
(13, 9, '2023-06-19', '14:45', 'Booked'),
(14, 36, '2023-06-15', '11:30', 'Booked'),
(15, 22, '2023-06-20', '09:00', 'Booked'),
(16, 44, '2023-06-14', '16:45', 'Completed'),
(17, 11, '2023-06-21', '13:15', 'Booked'),
(18, 50, '2023-06-16', '10:30', 'Booked'),
(19, 6, '2023-06-22', '15:00', 'Booked'),
(20, 17, '2023-06-15', '12:45', 'Completed'),
(21, 2, '2023-06-23', '08:15', 'Booked'),
(22, 13, '2023-06-14', '14:00', 'Completed'),
(23, 45, '2023-06-24', '10:15', 'Booked'),
(24, 29, '2023-06-16', '11:00', 'Completed'),
(25, 4, '2023-06-25', '13:45', 'Booked'),
(26, 37, '2023-06-15', '16:30', 'Completed'),
(27, 10, '2023-06-26', '09:30', 'Booked'),
(28, 21, '2023-06-17', '14:15', 'Completed'),
(29, 33, '2023-06-27', '08:45', 'Booked'),
(30, 48, '2023-06-18', '12:30', 'Completed'),
(31, 14, '2023-06-28', '15:15', 'Booked'),
(32, 26, '2023-06-19', '10:45', 'Completed'),
(33, 38, '2023-06-29', '11:30', 'Booked'),
(34, 16, '2023-06-20', '13:00', 'Completed'),
(35, 40, '2023-06-30', '14:45', 'Booked'),
(36, 23, '2023-06-21', '09:15', 'Completed'),
(37, 49, '2023-07-01', '16:00', 'Booked'),
(38, 18, '2023-06-22', '10:30', 'Completed'),
(39, 31, '2023-07-02', '08:00', 'Booked'),
(40, 42, '2023-06-23', '12:15', 'Completed'),
(41, 24, '2023-07-03', '14:30', 'Booked'),
(42, 35, '2023-06-24', '11:45', 'Completed'),
(43, 47, '2023-07-04', '09:00', 'Booked'),
(44, 20, '2023-06-25', '15:45', 'Completed'),
(45, 34, '2023-07-05', '10:00', 'Booked'),
(46, 27, '2023-06-26', '13:30', 'Completed'),
(47, 39, '2023-07-06', '08:45', 'Booked'),
(48, 30, '2023-06-27', '16:15', 'Completed'),
(49, 43, '2023-07-07', '12:00', 'Booked'),
(50, 46, '2023-06-28', '09:30', 'Completed');



INSERT INTO Orders (user_id, medication_id, quantity, delivery_method, order_date) VALUES
(1, 1, 2, 'Home Delivery', '2023-06-01 09:15:00'),
(2, 3, 1, 'Pharmacy Pickup', '2023-06-01 10:30:00'),
(3, 5, 3, 'Home Delivery', '2023-06-02 11:45:00'),
(4, 7, 1, 'Express Delivery', '2023-06-02 14:20:00'),
(5, 9, 2, 'Pharmacy Pickup', '2023-06-03 08:10:00'),
(6, 11, 1, 'Home Delivery', '2023-06-03 16:35:00'),
(7, 13, 4, 'Standard Delivery', '2023-06-04 09:25:00'),
(8, 15, 2, 'Pharmacy Pickup', '2023-06-04 12:40:00'),
(9, 17, 1, 'Home Delivery', '2023-06-05 10:15:00'),
(10, 19, 3, 'Express Delivery', '2023-06-05 15:50:00'),
(11, 21, 2, 'Standard Delivery', '2023-06-06 11:30:00'),
(12, 23, 1, 'Pharmacy Pickup', '2023-06-06 13:20:00'),
(13, 25, 2, 'Home Delivery', '2023-06-07 08:45:00'),
(14, 27, 1, 'Express Delivery', '2023-06-07 14:10:00'),
(15, 29, 4, 'Standard Delivery', '2023-06-08 09:55:00'),
(16, 31, 2, 'Pharmacy Pickup', '2023-06-08 12:25:00'),
(17, 33, 1, 'Home Delivery', '2023-06-09 10:40:00'),
(18, 35, 3, 'Express Delivery', '2023-06-09 16:05:00'),
(19, 37, 2, 'Standard Delivery', '2023-06-10 11:15:00'),
(20, 39, 1, 'Pharmacy Pickup', '2023-06-10 13:45:00'),
(21, 41, 2, 'Home Delivery', '2023-06-11 09:30:00'),
(22, 43, 1, 'Express Delivery', '2023-06-11 15:20:00'),
(23, 45, 4, 'Standard Delivery', '2023-06-12 10:05:00'),
(24, 47, 2, 'Pharmacy Pickup', '2023-06-12 12:50:00'),
(25, 49, 1, 'Home Delivery', '2023-06-13 08:20:00'),
(26, 2, 3, 'Express Delivery', '2023-06-13 14:35:00'),
(27, 4, 2, 'Standard Delivery', '2023-06-14 11:25:00'),
(28, 6, 1, 'Pharmacy Pickup', '2023-06-14 13:15:00'),
(29, 8, 2, 'Home Delivery', '2023-06-15 09:50:00'),
(30, 10, 1, 'Express Delivery', '2023-06-15 16:30:00'),
(31, 12, 4, 'Standard Delivery', '2023-06-16 10:45:00'),
(32, 14, 2, 'Pharmacy Pickup', '2023-06-16 12:20:00'),
(33, 16, 1, 'Home Delivery', '2023-06-17 08:30:00'),
(34, 18, 3, 'Express Delivery', '2023-06-17 15:40:00'),
(35, 20, 2, 'Standard Delivery', '2023-06-18 11:10:00'),
(36, 22, 1, 'Pharmacy Pickup', '2023-06-18 13:50:00'),
(37, 24, 2, 'Home Delivery', '2023-06-19 09:25:00'),
(38, 26, 1, 'Express Delivery', '2023-06-19 14:15:00'),
(39, 28, 4, 'Standard Delivery', '2023-06-20 10:30:00'),
(40, 30, 2, 'Pharmacy Pickup', '2023-06-20 12:40:00'),
(41, 32, 1, 'Home Delivery', '2023-06-21 08:50:00'),
(42, 34, 3, 'Express Delivery', '2023-06-21 16:20:00'),
(43, 36, 2, 'Standard Delivery', '2023-06-22 11:35:00'),
(44, 38, 1, 'Pharmacy Pickup', '2023-06-22 13:25:00'),
(45, 40, 2, 'Home Delivery', '2023-06-23 09:40:00'),
(46, 42, 1, 'Express Delivery', '2023-06-23 15:10:00'),
(47, 44, 4, 'Standard Delivery', '2023-06-24 10:55:00'),
(48, 46, 2, 'Pharmacy Pickup', '2023-06-24 12:30:00'),
(49, 48, 1, 'Home Delivery', '2023-06-25 08:15:00'),
(50, 50, 3, 'Express Delivery', '2023-06-25 14:50:00');


INSERT INTO HealthTips (title, content, type, valid_from, valid_to) VALUES
('Stay Hydrated', 'Drink at least 8 glasses of water daily to maintain proper body function.', 'General', '2023-01-01', '2023-12-31'),
('Summer Heat Protection', 'Wear sunscreen with SPF 30+ and stay in shade during peak sun hours (10am-4pm).', 'Seasonal', '2023-05-01', '2023-08-31'),
('Winter Flu Prevention', 'Get your flu shot and wash hands frequently to prevent seasonal influenza.', 'Seasonal', '2023-10-01', '2024-02-28'),
('Heart-Healthy Diet', 'Eat more fruits, vegetables, and whole grains while limiting saturated fats.', 'General', '2023-01-01', '2023-12-31'),
('Spring Allergy Management', 'Use antihistamines and keep windows closed during high pollen days.', 'Seasonal', '2023-03-15', '2023-05-31'),
('Daily Exercise', 'Aim for 30 minutes of moderate exercise like brisk walking most days.', 'General', '2023-01-01', '2023-12-31'),
('Cold Weather Joint Care', 'Keep joints warm and do gentle stretches to prevent stiffness in winter.', 'Seasonal', '2023-11-01', '2024-02-28'),
('Stress Management', 'Practice mindfulness meditation for 10 minutes daily to reduce stress.', 'General', '2023-01-01', '2023-12-31'),
('Mosquito Protection', 'Use DEET repellent and eliminate standing water to prevent mosquito bites.', 'Seasonal', '2023-06-01', '2023-10-15'),
('Back Pain Prevention', 'Maintain good posture and lift heavy objects with your legs, not back.', 'General', '2023-01-01', '2023-12-31'),
('Healthy Sleep Habits', 'Aim for 7-9 hours of sleep and maintain consistent bedtime routine.', 'General', '2023-01-01', '2023-12-31'),
('Fall Fitness Motivation', 'Take advantage of cooler weather for outdoor activities like hiking.', 'Seasonal', '2023-09-01', '2023-11-30'),
('Diabetes Management', 'Monitor blood sugar regularly and follow your meal plan consistently.', 'General', '2023-01-01', '2023-12-31'),
('Summer Food Safety', 'Keep perishables refrigerated and avoid leaving food out in hot weather.', 'Seasonal', '2023-05-15', '2023-09-15'),
('Quit Smoking', 'Talk to your doctor about smoking cessation programs and nicotine replacement.', 'General', '2023-01-01', '2023-12-31'),
('Winter Skin Care', 'Use moisturizer regularly and avoid long hot showers to prevent dry skin.', 'Seasonal', '2023-11-15', '2024-03-15'),
('Blood Pressure Control', 'Limit sodium intake to less than 2,300mg daily and monitor BP regularly.', 'General', '2023-01-01', '2023-12-31'),
('Spring Fitness Routine', 'Start outdoor activities gradually after winter inactivity to prevent injury.', 'Seasonal', '2023-03-01', '2023-05-31'),
('Healthy Aging', 'Stay socially active and engage in brain-stimulating activities regularly.', 'General', '2023-01-01', '2023-12-31'),
('Summer Hydration', 'Increase water intake during hot weather and watch for signs of dehydration.', 'Seasonal', '2023-06-01', '2023-09-15'),
('Cancer Prevention', 'Get recommended screenings and maintain healthy weight and diet.', 'General', '2023-01-01', '2023-12-31'),
('Fall Allergy Relief', 'Shower after being outdoors to remove pollen and use air purifiers indoors.', 'Seasonal', '2023-08-15', '2023-11-15'),
('Mental Health Awareness', 'Recognize signs of depression and anxiety and seek help when needed.', 'General', '2023-01-01', '2023-12-31'),
('Winter Vitamin D', 'Consider vitamin D supplements during months with limited sunlight exposure.', 'Seasonal', '2023-10-15', '2024-03-15'),
('Cholesterol Management', 'Choose healthy fats like olive oil and avocados over saturated fats.', 'General', '2023-01-01', '2023-12-31'),
('Spring Cleaning Safety', 'Use proper ventilation when cleaning with chemicals and wear gloves.', 'Seasonal', '2023-03-01', '2023-05-31'),
('Bone Health', 'Get enough calcium and vitamin D and do weight-bearing exercises.', 'General', '2023-01-01', '2023-12-31'),
('Summer Eye Protection', 'Wear UV-blocking sunglasses to protect eyes from sun damage.', 'Seasonal', '2023-05-15', '2023-09-15'),
('Stress Reduction', 'Practice deep breathing exercises for 5 minutes when feeling stressed.', 'General', '2023-01-01', '2023-12-31'),
('Fall Immunizations', 'Get updated on all recommended vaccines including COVID and flu shots.', 'Seasonal', '2023-09-01', '2023-11-30'),
('Healthy Gut', 'Eat probiotic-rich foods like yogurt and fermented vegetables regularly.', 'General', '2023-01-01', '2023-12-31'),
('Winter Workout Tips', 'Try indoor exercises like swimming or gym workouts during cold months.', 'Seasonal', '2023-12-01', '2024-02-28'),
('Heart Attack Prevention', 'Know warning signs of heart attack and call emergency services immediately.', 'General', '2023-01-01', '2023-12-31'),
('Spring Gardening Safety', 'Wear gloves and knee pads to protect joints while gardening.', 'Seasonal', '2023-04-01', '2023-06-15'),
('Diabetes Foot Care', 'Check feet daily for cuts or sores if you have diabetes.', 'General', '2023-01-01', '2023-12-31'),
('Summer Heat Stroke', 'Recognize symptoms like confusion and rapid pulse in hot weather.', 'Seasonal', '2023-06-01', '2023-09-15'),
('Healthy Weight', 'Focus on gradual weight loss through diet and exercise changes.', 'General', '2023-01-01', '2023-12-31'),
('Fall Back Pain', 'Use proper techniques when raking leaves to prevent back strain.', 'Seasonal', '2023-10-01', '2023-11-30'),
('Stroke Prevention', 'Control blood pressure and quit smoking to reduce stroke risk.', 'General', '2023-01-01', '2023-12-31'),
('Winter Holiday Eating', 'Enjoy treats in moderation and balance with healthy choices.', 'Seasonal', '2023-12-01', '2024-01-05'),
('Vision Health', 'Get regular eye exams and protect eyes from UV light and screens.', 'General', '2023-01-01', '2023-12-31'),
('Spring Sports Safety', 'Warm up properly and use appropriate protective gear for sports.', 'Seasonal', '2023-03-15', '2023-06-15'),
('Arthritis Management', 'Stay active with low-impact exercises like swimming or cycling.', 'General', '2023-01-01', '2023-12-31'),
('Summer Sun Protection', 'Reapply sunscreen every 2 hours when outdoors, especially swimming.', 'Seasonal', '2023-05-15', '2023-09-15'),
('Sleep Apnea Awareness', 'Talk to your doctor if you snore loudly or feel tired after sleeping.', 'General', '2023-01-01', '2023-12-31'),
('Fall Depression', 'Be aware of seasonal affective disorder as daylight hours decrease.', 'Seasonal', '2023-09-15', '2023-12-15'),
('Kidney Health', 'Stay hydrated and limit NSAID use to protect kidney function.', 'General', '2023-01-01', '2023-12-31'),
('Winter Driving Safety', 'Prepare car emergency kit with blankets and supplies for winter weather.', 'Seasonal', '2023-11-01', '2024-03-15'),
('Oral Health', 'Brush twice daily, floss, and get regular dental checkups.', 'General', '2023-01-01', '2023-12-31'),
('Spring Asthma', 'Have rescue inhaler available as pollen counts rise in spring.', 'Seasonal', '2023-03-01', '2023-05-31');


INSERT INTO HealthAlerts (day, alert_short, alert_detailed) VALUES
(1, 'Check BP', 'Monitor your blood pressure today and record the readings'),
(2, 'Hydration Reminder', 'Increase water intake if you have kidney stones history'),
(3, 'Medication Review', 'Review all medications with your pharmacist'),
(4, 'Diabetes Check', 'Test blood sugar levels before meals today'),
(5, 'Exercise Goal', 'Aim for 30 minutes of physical activity today'),
(6, 'Mental Health Check', 'Assess stress levels and practice relaxation techniques'),
(7, 'Vaccine Due', 'Check if any vaccinations are due or overdue'),
(8, 'Skin Check', 'Examine skin for any new or changing moles'),
(9, 'Cholesterol Test', 'Schedule lipid profile test if due'),
(10, 'Eye Exam', 'Book annual eye exam if you have diabetes'),
(11, 'Dental Visit', 'Schedule dental cleaning if overdue'),
(12, 'Cancer Screening', 'Check if any cancer screenings are due'),
(13, 'Allergy Prep', 'Check pollen count if you have seasonal allergies'),
(14, 'Asthma Review', 'Check inhaler technique with healthcare provider'),
(15, 'Bone Density', 'Schedule bone density test if at risk for osteoporosis'),
(16, 'Thyroid Test', 'Check TSH levels if on thyroid medication'),
(17, 'Sleep Review', 'Assess sleep quality and duration'),
(18, 'Foot Check', 'Examine feet carefully if you have diabetes'),
(19, 'Hearing Test', 'Schedule hearing test if experiencing difficulties'),
(20, 'Vitamin D Check', 'Consider vitamin D level test if deficient'),
(21, 'Weight Check', 'Record current weight and BMI calculation'),
(22, 'Stress Test', 'Schedule cardiac stress test if recommended'),
(23, 'Colonoscopy', 'Book screening if age 45+ and not done recently'),
(24, 'Mammogram', 'Schedule if female and age-appropriate'),
(25, 'Prostate Check', 'Discuss PSA test with doctor if male 50+'),
(26, 'Flu Shot', 'Get seasonal flu vaccine if not already done'),
(27, 'Pneumonia Vaccine', 'Check if pneumonia vaccine is needed'),
(28, 'Shingles Vaccine', 'Get shingles vaccine if age 50+'),
(29, 'Tetanus Booster', 'Check if tetanus booster is due (every 10 years)'),
(30, 'Medication Refill', 'Check all prescriptions for refill needs'),
(1, 'CPR Training', 'Consider taking a CPR certification course'),
(2, 'First Aid Kit', 'Check and restock home first aid supplies'),
(3, 'Emergency Contacts', 'Update emergency contact information'),
(4, 'Advance Directives', 'Review living will and healthcare proxy'),
(5, 'Fire Safety', 'Test smoke detectors and check fire extinguisher'),
(6, 'Fall Prevention', 'Remove tripping hazards in home'),
(7, 'Water Safety', 'Review water safety if you have a pool'),
(8, 'Food Safety', 'Check refrigerator temperature (below 40°F)'),
(9, 'Disaster Prep', 'Update emergency disaster supplies'),
(10, 'Travel Health', 'Check travel health recommendations if planning trip'),
(11, 'Sun Safety', 'Apply sunscreen when going outdoors'),
(12, 'Bug Protection', 'Use insect repellent in mosquito areas'),
(13, 'Air Quality', 'Check air quality index if respiratory issues'),
(14, 'Heat Safety', 'Stay hydrated and cool in hot weather'),
(15, 'Cold Protection', 'Dress warmly in layers during cold spells'),
(16, 'Flood Safety', 'Know flood risks in your area'),
(17, 'Tornado Prep', 'Review tornado safety procedures'),
(18, 'Earthquake Prep', 'Secure heavy furniture if in earthquake zone'),
(19, 'Hurricane Prep', 'Prepare hurricane supplies if in risk area'),
(20, 'Wildfire Safety', 'Know evacuation routes if in wildfire area'),
(21, 'Radon Test', 'Test home for radon if not done recently'),
(22, 'Lead Check', 'Test for lead if in older home with children'),
(23, 'Asbestos Check', 'Check for asbestos if renovating older home'),
(24, 'Mold Check', 'Look for mold in damp areas of home'),
(25, 'Carbon Monoxide', 'Test CO detectors and replace batteries'),
(26, 'Drinking Water', 'Test well water annually if applicable'),
(27, 'Food Allergies', 'Check food labels carefully for allergens'),
(28, 'Medication Safety', 'Dispose of expired medications properly'),
(29, 'Safe Sex', 'Practice safe sex and get STI testing if needed'),
(30, 'Substance Use', 'Evaluate alcohol and drug use patterns');


INSERT INTO PersonalizedHealthTips (user_id, condition_id, tip) VALUES
(1, 1, 'Monitor BP twice daily and limit sodium to 1500mg for better hypertension control'),
(2, 3, 'Check blood sugar before meals and 2 hours after to manage diabetes effectively'),
(3, 4, 'Always carry rescue inhaler and avoid cold air to prevent asthma attacks'),
(4, 38, 'Practice mindfulness meditation daily to help manage anxiety symptoms'),
(5, 2, 'Rotate insulin injection sites to prevent lipodystrophy complications'),
(6, 29, 'Identify and avoid migraine triggers like certain foods or stress'),
(7, 10, 'Try swimming or cycling instead of running to protect arthritic joints'),
(8, 37, 'Establish regular sleep schedule to help manage depression symptoms'),
(9, 1, 'Reduce caffeine intake to help control high blood pressure'),
(10, 48, 'Use fragrance-free moisturizers twice daily for eczema flare prevention'),
(11, 15, 'Limit potassium-rich foods if on dialysis for kidney disease'),
(12, 30, 'Take epilepsy medication at same time daily for consistent blood levels'),
(13, 10, 'Apply heat pads to stiff joints in the morning for osteoarthritis relief'),
(14, 17, 'Avoid eating 3 hours before bedtime to reduce GERD symptoms'),
(15, 5, 'Practice pursed-lip breathing technique for COPD symptom relief'),
(16, 36, 'Keep mood diary to track bipolar disorder episodes and triggers'),
(17, 9, 'Choose healthy fats like avocados to help manage cholesterol'),
(18, 30, 'Wear medical alert bracelet indicating epilepsy condition'),
(19, 1, 'Limit alcohol to 1 drink per day to help control hypertension'),
(20, 39, 'Try cognitive behavioral therapy techniques for OCD management'),
(21, 22, 'Get regular liver function tests while on hepatitis B medication'),
(22, 37, 'Engage in social activities weekly to combat depression'),
(23, 6, 'Learn to recognize atypical heart attack symptoms as a woman'),
(24, 17, 'Elevate head of bed 6 inches to reduce nighttime acid reflux'),
(25, 3, 'Inspect feet daily for cuts or sores if you have diabetes'),
(26, 29, 'Keep headache diary to identify migraine patterns and triggers'),
(27, 10, 'Maintain healthy weight to reduce stress on arthritic joints'),
(28, 4, 'Clean inhaler monthly to prevent medication buildup and infection'),
(29, 1, 'Practice stress-reduction techniques like yoga for BP control'),
(30, 48, 'Wear cotton clothing to minimize eczema skin irritation'),
(31, 14, 'Limit phosphorus intake if you have chronic kidney disease'),
(32, 30, 'Avoid flashing lights if they trigger your epilepsy seizures'),
(33, 2, 'Always carry fast-acting glucose for diabetes emergencies'),
(34, 17, 'Avoid tight clothing that puts pressure on your abdomen'),
(35, 5, 'Get pneumococcal vaccine to prevent COPD complications'),
(36, 36, 'Maintain regular sleep schedule to stabilize bipolar moods'),
(37, 9, 'Increase soluble fiber intake to help lower cholesterol'),
(38, 30, 'Ensure adequate sleep to help prevent seizure triggers'),
(39, 1, 'Reduce processed food intake to lower sodium consumption'),
(40, 39, 'Practice exposure therapy gradually for OCD symptoms'),
(41, 23, 'Never share razors or toothbrushes with hepatitis C'),
(42, 37, 'Engage in 30 minutes of physical activity daily for depression'),
(43, 6, 'Take prescribed blood thinners exactly as directed for CAD'),
(44, 17, 'Chew gum after meals to stimulate saliva and neutralize acid'),
(45, 12, 'Do weight-bearing exercises to maintain bone density'),
(46, 29, 'Stay hydrated to help prevent dehydration-triggered migraines'),
(47, 10, 'Use assistive devices to reduce joint stress in arthritis'),
(48, 4, 'Track asthma symptoms and peak flow readings regularly'),
(49, 1, 'Increase potassium-rich foods to help lower blood pressure'),
(50, 48, 'Use lukewarm water for bathing to prevent eczema flare-ups');



INSERT INTO Medicine (symptom_id, use_case, dosage, frequency) VALUES
(1, 'Angina pain relief', 'Nitroglycerin 0.4mg', '1 tablet sublingually every 5 minutes up to 3 doses'),
(2, 'Shortness of breath', 'Albuterol inhaler 90mcg', '2 puffs every 4-6 hours as needed'),
(3, 'Persistent cough', 'Dextromethorphan 30mg', 'Every 6-8 hours as needed'),
(4, 'Asthma wheezing', 'Salmeterol 50mcg inhaler', '1 puff twice daily'),
(5, 'Chronic fatigue', 'Modafinil 100mg', 'Once daily in morning'),
(6, 'Heart palpitations', 'Metoprolol 25mg', 'Twice daily'),
(7, 'Hypertension', 'Lisinopril 10mg', 'Once daily'),
(8, 'Excessive thirst', 'Desmopressin 0.1mg', 'Twice daily as needed'),
(9, 'Frequent urination', 'Oxybutynin 5mg', 'Twice daily'),
(10, 'Weight loss', 'Megestrol 400mg', 'Once daily'),
(11, 'Blurred vision', 'Pilocarpine 1% eye drops', '1 drop in affected eye 3 times daily'),
(12, 'Neuropathic pain', 'Gabapentin 300mg', '3 times daily'),
(13, 'Chronic cough', 'Guaifenesin 600mg', 'Every 12 hours'),
(14, 'COPD phlegm', 'Acetylcysteine 600mg', 'Once daily'),
(15, 'Chest tightness', 'Ipratropium 0.5mg nebulizer', 'Every 6 hours as needed'),
(16, 'Arthritis pain', 'Celecoxib 200mg', 'Once daily'),
(17, 'Joint swelling', 'Prednisone 10mg', 'Once daily for 5 days'),
(18, 'Morning stiffness', 'Meloxicam 15mg', 'Once daily'),
(19, 'Back pain', 'Cyclobenzaprine 10mg', 'At bedtime as needed'),
(20, 'Osteoporosis', 'Alendronate 70mg', 'Once weekly'),
(21, 'Gout pain', 'Colchicine 0.6mg', '1 tablet initially, then 0.6mg 1 hour later'),
(22, 'Joint redness', 'Indomethacin 50mg', '3 times daily with food'),
(23, 'Gout in big toe', 'Allopurinol 300mg', 'Once daily'),
(24, 'Low urine output', 'Furosemide 40mg', 'Once daily in morning'),
(25, 'Leg swelling', 'Spironolactone 25mg', 'Once daily'),
(26, 'Nausea', 'Ondansetron 8mg', 'Every 8 hours as needed'),
(27, 'Heartburn', 'Omeprazole 20mg', 'Once daily before breakfast'),
(28, 'Abdominal pain', 'Dicyclomine 20mg', '4 times daily before meals'),
(29, 'Diarrhea', 'Loperamide 2mg', 'After each loose stool, max 8mg/day'),
(30, 'Bloody stool', 'Mesalamine 1.2g', '3 times daily'),
(31, 'Jaundice', 'Ursodiol 300mg', 'Twice daily'),
(32, 'Ascites', 'Furosemide 40mg + Spironolactone 100mg', 'Once daily'),
(33, 'Fever', 'Acetaminophen 500mg', 'Every 6 hours as needed'),
(34, 'Night sweats', 'Oxybutynin 5mg', 'At bedtime'),
(35, 'Depressed mood', 'Sertraline 50mg', 'Once daily'),
(36, 'Mania', 'Lithium 300mg', 'Twice daily'),
(37, 'Anxiety', 'Lorazepam 0.5mg', 'Every 8 hours as needed'),
(38, 'OCD thoughts', 'Fluoxetine 20mg', 'Once daily'),
(39, 'Hallucinations', 'Risperidone 1mg', 'Twice daily'),
(40, 'Delusions', 'Olanzapine 5mg', 'At bedtime'),
(41, 'Psoriasis', 'Calcipotriene 0.005% ointment', 'Apply twice daily'),
(42, 'Eczema itch', 'Hydrocortisone 2.5% cream', 'Apply 2-3 times daily'),
(43, 'Butterfly rash', 'Hydroxychloroquine 200mg', 'Twice daily'),
(44, 'Muscle pain', 'Diclofenac 1% gel', 'Apply 4 times daily'),
(45, 'Fatigue', 'Methylphenidate 10mg', 'Twice daily before noon'),
(46, 'Malaria fever', 'Artemether-lumefantrine 20/120mg', '4 tablets initially, then 4 tablets after 8 hours'),
(47, 'Headache', 'Sumatriptan 50mg', 'At headache onset, may repeat in 2 hours'),
(48, 'Flu aches', 'Oseltamivir 75mg', 'Twice daily for 5 days'),
(49, 'Runny nose', 'Fluticasone nasal spray 50mcg', '1 spray each nostril daily'),
(50, 'Chickenpox', 'Acyclovir 800mg', '4 times daily for 5 days');



INSERT INTO Remedy (symptom_id, home_remedy, instruction) VALUES
(1, 'Ginger tea', 'Steep fresh ginger slices in hot water for 5 minutes, drink 2-3 cups daily'),
(2, 'Steam inhalation', 'Boil water, pour into bowl, add few drops eucalyptus oil, inhale steam with towel over head for 5-10 minutes'),
(3, 'Honey lemon mixture', 'Mix 1 tbsp honey with 1 tsp lemon juice in warm water, drink slowly'),
(4, 'Pursed lip breathing', 'Inhale through nose for 2 seconds, purse lips, exhale slowly for 4 seconds'),
(5, 'Power nap', '20-30 minute nap in early afternoon in quiet, dark space'),
(6, 'Valsalva maneuver', 'Pinch nose, close mouth, try to exhale for 15-20 seconds'),
(7, 'Garlic water', 'Crush 1 garlic clove in warm water, drink on empty stomach each morning'),
(8, 'Cucumber slices', 'Place chilled cucumber slices on eyes for 10 minutes to reduce puffiness'),
(9, 'Cranberry juice', 'Drink 8oz unsweetened cranberry juice daily to support urinary health'),
(10, 'Protein smoothie', 'Blend Greek yogurt, banana, peanut butter and milk for nutrient-dense snack'),
(11, 'Warm compress', 'Apply warm, moist cloth to eyes for 5-10 minutes several times daily'),
(12, 'Capsaicin cream', 'Apply cream containing 0.025-0.075% capsaicin to affected area 3-4 times daily'),
(13, 'Salt water gargle', 'Mix 1/2 tsp salt in 8oz warm water, gargle for 30 seconds 3 times daily'),
(14, 'Postural drainage', 'Lie with head lower than chest, have someone clap on upper back for 5 minutes'),
(15, 'Mustard plaster', 'Mix dry mustard with flour and water, spread on cloth, apply to chest for 15 minutes'),
(16, 'Epsom salt soak', 'Dissolve 2 cups Epsom salt in warm bath, soak for 20 minutes'),
(17, 'Turmeric paste', 'Mix 1 tbsp turmeric with coconut oil to make paste, apply to swollen joints'),
(18, 'Morning stretches', 'Gentle yoga stretches for 10 minutes upon waking to reduce stiffness'),
(19, 'Tennis ball massage', 'Place tennis ball on floor, gently roll foot over it for arch pain relief'),
(20, 'Calcium-rich smoothie', 'Blend kale, yogurt, almond butter and banana for bone-supporting drink'),
(21, 'Cherry juice', 'Drink 8oz tart cherry juice daily during gout flare-ups'),
(22, 'Apple cider vinegar', 'Mix 1 tbsp in 8oz water, drink before meals to help with joint inflammation'),
(23, 'Cold compress', 'Apply ice pack wrapped in cloth to affected joint for 15 minutes every hour'),
(24, 'Dandelion tea', 'Steep 1 tsp dried dandelion root in hot water for 5 minutes, drink 2-3 cups daily'),
(25, 'Elevation', 'Lie down and elevate legs above heart level for 20 minutes to reduce swelling'),
(26, 'Ginger chews', 'Suck on crystallized ginger or drink ginger tea for nausea relief'),
(27, 'Aloe vera juice', 'Drink 1/4 cup pure aloe vera juice before meals to soothe digestive tract'),
(28, 'BRAT diet', 'Eat bananas, rice, applesauce and toast during digestive upset'),
(29, 'Probiotic foods', 'Consume yogurt, kefir or sauerkraut daily to restore gut flora'),
(30, 'Witch hazel pads', 'Apply witch hazel-soaked cotton pads to affected area after bowel movements'),
(31, 'Dandelion root tea', 'Steep 1 tsp in hot water for 5 minutes, drink 3 times daily to support liver'),
(32, 'Low-sodium diet', 'Limit sodium to 2000mg daily, avoid processed foods to reduce fluid retention'),
(33, 'Lukewarm sponge bath', 'Sponge body with lukewarm water to reduce fever gradually'),
(34, 'Sage tea', 'Steep 1 tsp dried sage in hot water, drink at bedtime to reduce night sweats'),
(35, 'Sunlight exposure', 'Get 15-30 minutes of morning sunlight daily to boost mood'),
(36, 'Dark therapy', 'Keep bedroom completely dark at night to help stabilize moods'),
(37, 'Chamomile tea', 'Steep chamomile tea bags for 5 minutes, drink 2-3 cups daily for anxiety'),
(38, 'Grounding technique', 'Name 5 things you see, 4 you feel, 3 you hear, 2 you smell, 1 you taste during anxiety'),
(39, 'White noise machine', 'Use calming nature sounds or fan noise to distract from hallucinations'),
(40, 'Reality testing', 'Write down experiences and review later with therapist to identify delusions'),
(41, 'Oatmeal bath', 'Grind 1 cup oatmeal, add to lukewarm bath, soak for 15-20 minutes'),
(42, 'Coconut oil', 'Apply virgin coconut oil to affected skin areas after bathing'),
(43, 'Green tea compress', 'Steep green tea bags in hot water, cool, apply to affected skin areas'),
(44, 'Magnesium oil', 'Spray magnesium oil on sore muscles, massage gently'),
(45, 'Power walk', '10-minute brisk walk when energy is lowest to boost circulation'),
(46, 'Neem leaves', 'Boil handful of neem leaves in water, use as skin wash for chickenpox'),
(47, 'Peppermint oil', 'Dilute with carrier oil, apply to temples for headache relief'),
(48, 'Elderberry syrup', 'Take 1 tbsp elderberry syrup 3 times daily during flu'),
(49, 'Saline rinse', 'Use neti pot with saline solution to clear nasal passages'),
(50, 'Baking soda paste', 'Mix baking soda with water to make paste, apply to itchy chickenpox spots');


INSERT INTO RemedyDetail (remedy_id, full_remedy) VALUES
(1, 'Ginger contains anti-inflammatory compounds that may help with chest discomfort. Use 1-2 inches fresh ginger root, peeled and sliced. Steep in boiling water for 5-10 minutes. Add honey if desired. Drink up to 3 cups daily. Avoid if on blood thinners.'),
(2, 'Steam inhalation helps loosen mucus and soothe airways. Boil 4-6 cups water, pour into a large bowl. Add 3-5 drops eucalyptus or peppermint essential oil. Drape towel over head to create tent, lean over bowl (keep face 10-12 inches from water) and inhale deeply for 5-10 minutes. Repeat up to 3 times a day.'),
(3, 'Honey and lemon work together to soothe the throat and support the immune system. Mix 1 tablespoon of raw honey with 1 teaspoon of fresh lemon juice in warm water. Stir until fully dissolved and drink slowly. This remedy is good for soothing coughs and sore throats. Drink 2-3 times a day.'),
(4, 'Pursed lip breathing helps improve airflow and reduces shortness of breath. Sit upright, inhale deeply through your nose for 2 seconds, then purse your lips as though you are about to whistle. Exhale slowly through your lips for 4 seconds. Repeat for 5-10 minutes, up to 3 times daily.'),
(5, 'A power nap of 20-30 minutes can refresh the mind and body, improving alertness and productivity. Ensure the environment is quiet, dark, and free from distractions. Try to nap in the early afternoon when energy naturally dips. Avoid napping for longer durations as it can interfere with nighttime sleep.'),
(6, 'The Valsalva maneuver can help with sinus pressure and ear popping. Pinch your nostrils closed, close your mouth, and try to exhale gently as if you were blowing your nose. Perform for 15-20 seconds, but do not force it. Repeat once or twice.'),
(7, 'Garlic contains compounds with strong antibacterial properties that may help boost immunity. Crush 1 fresh garlic clove and add to 1 cup of warm water. Let it steep for 5 minutes, then drink it on an empty stomach every morning. Garlic may have a strong taste, so consider adding a little honey to sweeten it.'),
(8, 'Cucumber slices can help reduce puffiness and refresh tired eyes. Place 2-3 chilled cucumber slices over your eyes while lying down. Leave them on for 10-15 minutes. This simple remedy can help reduce swelling and cool the skin around the eyes.'),
(9, 'Cranberry juice is known for supporting urinary tract health. Drink 8 oz of unsweetened cranberry juice daily, especially during or after a urinary tract infection (UTI). Ensure the juice is pure, as added sugars can diminish the health benefits.'),
(10, 'A protein smoothie provides a nutrient-dense snack to keep energy levels up. Blend 1/2 cup of Greek yogurt, 1 banana, 1 tablespoon of peanut butter, and 1 cup of milk (or dairy-free alternative). This combination offers a good balance of protein, healthy fats, and carbohydrates.'),
(11, 'A warm compress can soothe tired or dry eyes. Soak a clean cloth in warm water and wring out the excess. Place it over your closed eyelids for 5-10 minutes, repeating several times a day. This remedy can help relieve discomfort caused by strain or dryness.'),
(12, 'Capsaicin cream can help alleviate muscle or joint pain. Apply a small amount of cream containing 0.025-0.075% capsaicin to the affected area 3-4 times daily. Be sure to wash your hands thoroughly after use and avoid contact with eyes or broken skin.'),
(13, 'A salt water gargle can help soothe a sore throat and kill bacteria. Mix 1/2 teaspoon of salt in 8 oz of warm water. Gargle for 30 seconds, ensuring the water reaches the back of the throat. Repeat 3 times daily. This remedy works best when used at the first sign of throat discomfort.'),
(14, 'Postural drainage helps clear mucus from the lungs. Lie flat on your back with your head lower than your chest. Have someone gently clap on your upper back for 5 minutes, helping to dislodge mucus. Repeat up to 3 times a day, especially when experiencing congestion.'),
(15, 'A mustard plaster is a traditional remedy for chest congestion. Mix 1 tablespoon of dry mustard with 2 tablespoons of flour and enough warm water to make a paste. Spread it on a cloth and apply it to the chest for 15 minutes. If it causes irritation, remove immediately.'),
(16, 'An Epsom salt soak can help relax muscles and relieve stress. Dissolve 2 cups of Epsom salt in a warm bath. Soak for 20 minutes, allowing the magnesium to absorb through the skin. This is especially helpful for sore muscles, joint pain, and stress relief.'),
(17, 'Turmeric contains curcumin, a compound with anti-inflammatory properties. Mix 1 tablespoon of turmeric powder with coconut oil to form a paste. Apply to swollen joints or areas of discomfort. Leave on for 15-20 minutes, then rinse off. Repeat 2-3 times a day.'),
(18, 'Morning stretches can reduce stiffness and improve flexibility. Try gentle yoga or stretching exercises for 10 minutes as soon as you wake up. Focus on stretches for the back, neck, and legs to ease morning tightness and improve circulation.'),
(19, 'Tennis ball massage can help relieve foot pain and improve circulation. Place a tennis ball on the floor and gently roll your foot over it, applying light pressure to the arch. Do this for 5-10 minutes on each foot to relieve discomfort and promote relaxation.'),
(20, 'A calcium-rich smoothie can support bone health. Blend 1/2 cup of kale, 1/2 cup of yogurt, 1 tablespoon of almond butter, and 1 banana for a nutrient-dense drink. This smoothie provides calcium, magnesium, and potassium for bone-strengthening nutrients.'),
(21, 'Cherry juice may help alleviate symptoms of gout due to its anti-inflammatory properties. Drink 8 oz of tart cherry juice daily during a flare-up. This can help reduce uric acid levels and provide relief from joint pain.'),
(22, 'Apple cider vinegar is believed to reduce joint inflammation. Mix 1 tablespoon of apple cider vinegar in 8 oz of water and drink before meals. It may also support digestion, though it should be used in moderation to avoid stomach irritation.'),
(23, 'A cold compress can reduce swelling and numb pain. Apply an ice pack wrapped in a cloth to the affected joint for 15 minutes every hour, especially after exercise or injury. Ensure there is a barrier between the ice and skin to avoid frostbite.'),
(24, 'Dandelion tea can promote liver health and detoxification. Steep 1 teaspoon of dried dandelion root in hot water for 5 minutes. Drink 2-3 cups daily to support liver function and help with water retention.'),
(25, 'Elevating your legs can help reduce swelling, especially in the feet and ankles. Lie down and elevate your legs above the level of your heart for 20 minutes. This promotes blood circulation and helps reduce fluid buildup.'),
(26, 'Ginger chews can be a helpful remedy for nausea. Suck on crystallized ginger or drink ginger tea for relief. Ginger has anti-nausea properties and can be soothing for digestive upset.'),
(27, 'Aloe vera juice can soothe the digestive tract and relieve heartburn. Drink 1/4 cup of pure aloe vera juice before meals. Be sure to use juice labeled for internal use.'),
(28, 'The BRAT diet is a bland food diet used during digestive upset. Eat small amounts of bananas, rice, applesauce, and toast. These foods are easy on the stomach and help reduce symptoms of diarrhea or vomiting.'),
(29, 'Probiotic foods can restore healthy gut flora. Include yogurt, kefir, or sauerkraut in your diet daily. These fermented foods contain beneficial bacteria that support digestion and immune health.'),
(30, 'Witch hazel pads can reduce irritation and swelling. Apply witch hazel-soaked cotton pads to the affected area after bowel movements. This remedy helps with hemorrhoid discomfort and can soothe irritated skin.'),
(31, 'Dandelion root tea can support liver detoxification. Steep 1 teaspoon of dried dandelion root in hot water for 5 minutes. Drink 3 times a day to help with liver function and detoxify the body naturally.'),
(32, 'A low-sodium diet is important for managing blood pressure and reducing fluid retention. Limit your sodium intake to 2000 mg daily by avoiding processed foods, canned goods, and salty snacks.'),
(33, 'A lukewarm sponge bath can help gradually lower a fever. Use a washcloth soaked in lukewarm water to sponge your body. Avoid using cold water, as it can cause shivering, which may increase the body temperature.'),
(34, 'Sage tea can help reduce night sweats and hot flashes. Steep 1 teaspoon of dried sage in hot water for 5 minutes. Drink before bedtime to reduce symptoms of menopause or other hormonal imbalances.'),
(35, 'Sunlight exposure boosts mood by increasing serotonin levels. Aim for 15-30 minutes of sunlight in the morning to improve mood and regulate your circadian rhythm.'),
(36, 'Dark therapy helps stabilize mood and sleep patterns. Keep your bedroom completely dark at night to promote deep, restorative sleep. Use blackout curtains or an eye mask to block out light sources.'),
(37, 'Chamomile tea can help with anxiety and promote relaxation. Steep chamomile tea bags in hot water for 5 minutes and drink 2-3 cups daily. Chamomile has mild sedative effects that can calm the nervous system.'),
(38, 'Grounding techniques can help reduce anxiety and panic. Focus on the present by naming 5 things you see, 4 things you feel, 3 things you hear, 2 things you smell, and 1 thing you taste. This helps bring attention away from anxious thoughts.'),
(39, 'A white noise machine can mask disturbing noises and help with sleep. Use a white noise machine or app to play calming sounds such as nature noises or a fan. This can also help mask sounds during hallucinations or sleep disturbances.'),
(40, 'Reality testing is an important tool for managing delusions. Write down experiences and review them later with a therapist to identify distorted thoughts or beliefs. This technique can help you differentiate between reality and delusion.'),
(41, 'An oatmeal bath can soothe irritated skin and provide relief from rashes or itching. Grind 1 cup of oatmeal into a fine powder, then add it to a lukewarm bath. Soak for 15-20 minutes.'),
(42, 'Coconut oil is a natural moisturizer that can help soothe dry or irritated skin. Apply virgin coconut oil to affected areas after bathing to lock in moisture and promote healing.'),
(43, 'Green tea compresses can soothe irritated skin. Steep 2 green tea bags in hot water, let them cool, and apply the tea bags to the affected area for 10-15 minutes. Green tea has antioxidant and anti-inflammatory properties.'),
(44, 'Magnesium oil can help relieve muscle soreness and tension. Spray magnesium oil on sore areas and gently massage it into the skin. This can improve circulation and relax muscles.'),
(45, 'A power walk can help boost circulation and increase energy levels. Take a brisk 10-minute walk when feeling fatigued or sluggish. This will improve blood flow and help you feel more energized throughout the day.'),
(46, 'Neem leaves are known for their antibacterial properties. Boil a handful of neem leaves in water, then use the strained liquid as a skin wash for conditions like chickenpox or acne.'),
(47, 'Peppermint oil can help relieve headaches and tension. Dilute peppermint oil with a carrier oil (like coconut oil) and apply it to your temples or the back of your neck. This remedy can help reduce pain and improve focus.'),
(48, 'Elderberry syrup is often used to boost immunity during flu season. Take 1 tablespoon of elderberry syrup 3 times daily when experiencing flu symptoms. Elderberry has antiviral properties that may reduce the severity and duration of flu.'),
(49, 'A saline rinse helps clear nasal passages and reduce congestion. Use a neti pot with a saline solution to rinse your nasal passages. This can help relieve sinus pressure, allergies, and colds.'),
(50, 'Baking soda paste can help relieve itching caused by chickenpox. Mix baking soda with water to form a paste and apply it to itchy areas. Leave the paste on for 10-15 minutes before rinsing off. This remedy can soothe skin irritation.');




SELECT * FROM Users;
SELECT * FROM User_details;
SELECT * FROM EmergencyContact;
SELECT * FROM Medical_conditions;
SELECT * FROM UserMedicalCondition;
SELECT * FROM Allergies;
SELECT * FROM UserAllergy;
SELECT * FROM Medications;
SELECT * FROM Doctors;
SELECT * FROM DoctorAvailability;
SELECT * FROM Diseases;
SELECT * FROM DoctorDiseases;
SELECT * FROM SymptomsNormalized;
SELECT * FROM SymptomCondition;
SELECT * FROM Treatments;
SELECT * FROM Appointments;
SELECT * FROM Orders;
SELECT * FROM HealthTips;
SELECT * FROM HealthAlerts;
SELECT * FROM PersonalizedHealthTips;
SELECT * FROM Medicine;
SELECT * FROM Remedy;
SELECT * FROM RemedyDetail;



