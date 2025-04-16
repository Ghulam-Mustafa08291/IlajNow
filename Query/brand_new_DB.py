import re
from graphviz import Digraph

# Define the SQL schema as a single string
sql_schema = """
CREATE TABLE DoctorDiseases ( doctor_id INT, disease_id INT, PRIMARY KEY (doctor_id, disease_id), FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id), FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id) );
CREATE TABLE Users ( user_id INT PRIMARY KEY IDENTITY(1,1), email NVARCHAR(255) UNIQUE NOT NULL, password NVARCHAR(255) NOT NULL );
CREATE TABLE User_details ( user_id INT PRIMARY KEY, full_name NVARCHAR(255) NOT NULL, age INT, gender NVARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')), phone_number NVARCHAR(20), house_no NVARCHAR(50), city NVARCHAR(100) DEFAULT 'Karachi', area NVARCHAR(100), weight DECIMAL(5,2), height DECIMAL(5,2), disability NVARCHAR(255), FOREIGN KEY (user_id) REFERENCES Users(user_id) );
CREATE TABLE EmergencyContact ( contact_id INT PRIMARY KEY IDENTITY(1,1), user_id INT NOT NULL, name NVARCHAR(255) NOT NULL, number NVARCHAR(20) NOT NULL, FOREIGN KEY (user_id) REFERENCES Users(user_id) );
CREATE TABLE Medical_conditions ( condition_id INT PRIMARY KEY IDENTITY(1,1), condition_name NVARCHAR(255) NOT NULL );
CREATE TABLE UserMedicalCondition ( user_id INT NOT NULL, condition_id INT NOT NULL, PRIMARY KEY (user_id, condition_id), FOREIGN KEY (user_id) REFERENCES Users(user_id), FOREIGN KEY (condition_id) REFERENCES Medical_conditions(condition_id) );
CREATE TABLE Allergies ( allergy_id INT PRIMARY KEY IDENTITY(1,1), allergy_name NVARCHAR(255) NOT NULL );
CREATE TABLE UserAllergy ( user_id INT NOT NULL, allergy_id INT NOT NULL, PRIMARY KEY (user_id, allergy_id), FOREIGN KEY (user_id) REFERENCES Users(user_id), FOREIGN KEY (allergy_id) REFERENCES Allergies(allergy_id) );
CREATE TABLE Medications ( medication_id INT PRIMARY KEY IDENTITY(1,1), user_id INT NOT NULL, name NVARCHAR(255) NOT NULL, dosage NVARCHAR(100), frequency NVARCHAR(100), next_dose DATETIME, supply_remaining INT, FOREIGN KEY (user_id) REFERENCES Users(user_id) );
CREATE TABLE Doctors ( doctor_id INT PRIMARY KEY IDENTITY(1,1), name NVARCHAR(255) NOT NULL, specialization NVARCHAR(255) NOT NULL, location NVARCHAR(255) NOT NULL, fees DECIMAL(10,2) );
CREATE TABLE DoctorAvailability ( availability_id INT PRIMARY KEY IDENTITY(1,1), doctor_id INT NOT NULL, day_of_week NVARCHAR(10) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')), start_time TIME, end_time TIME, FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) );
CREATE TABLE Health_info ( user_id INT PRIMARY KEY, doctor_id INT, prescription_path NVARCHAR(255), FOREIGN KEY (user_id) REFERENCES Users(user_id), FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) );
CREATE TABLE Diseases ( disease_id INT PRIMARY KEY IDENTITY(1,1), disease_name NVARCHAR(255) UNIQUE NOT NULL );
CREATE TABLE SymptomsNormalized ( symptom_id INT PRIMARY KEY IDENTITY(1,1), description NVARCHAR(255) NOT NULL );
CREATE TABLE SymptomCondition ( disease_id INT NOT NULL, symptom_id INT NOT NULL, PRIMARY KEY (disease_id, symptom_id), FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id), FOREIGN KEY (symptom_id) REFERENCES SymptomsNormalized(symptom_id) );
CREATE TABLE Treatments ( treatment_id INT PRIMARY KEY IDENTITY(1,1), disease_id INT NOT NULL, description NVARCHAR(MAX), type NVARCHAR(50), FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id) );
CREATE TABLE Appointments ( appointment_id INT PRIMARY KEY IDENTITY(1,1), user_id INT NOT NULL, doctor_id INT NOT NULL, date DATE NOT NULL, time TIME NOT NULL, status NVARCHAR(50) CHECK (status IN ('Booked', 'Completed', 'Cancelled')), FOREIGN KEY (user_id) REFERENCES Users(user_id), FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) );
CREATE TABLE Orders ( order_id INT PRIMARY KEY IDENTITY(1,1), user_id INT NOT NULL, medication_id INT NOT NULL, quantity INT NOT NULL, delivery_method NVARCHAR(50), order_date DATETIME DEFAULT GETDATE(), FOREIGN KEY (user_id) REFERENCES Users(user_id), FOREIGN KEY (medication_id) REFERENCES Medications(medication_id) );
CREATE TABLE HealthTips ( tip_id INT PRIMARY KEY IDENTITY(1,1), title NVARCHAR(255), content NVARCHAR(MAX), type NVARCHAR(50) CHECK (type IN ('Seasonal', 'General')), valid_from DATE, valid_to DATE );
CREATE TABLE UserEmergencySettings ( user_id INT PRIMARY KEY, check_in_frequency NVARCHAR(50), last_check_in DATETIME, FOREIGN KEY (user_id) REFERENCES Users(user_id) );
"""

# Initialize the graph
dot = Digraph(comment='ERD Diagram')
dot.attr(rankdir='LR', fontsize='10')

# Extract tables and their details (columns, data types, constraints)
tables = re.findall(r'CREATE TABLE (\w+) \((.*?)\);', sql_schema, re.DOTALL)
foreign_keys = {}

for table, body in tables:
    # Add table as a node with columns as label
    columns = re.findall(r'(\w+ \w+(?:\(\d+\))?)', body)
    constraints = re.findall(r'PRIMARY KEY \((.*?)\)', body)
    fks = re.findall(r'FOREIGN KEY \((\w+)\) REFERENCES (\w+)\((\w+)\)', body)
    
    table_description = f'{table}\n'
    table_description += '\n'.join(columns)
    if constraints:
        table_description += '\nPRIMARY KEY: ' + ', '.join(constraints[0].split(','))
    
    dot.node(table, table_description, shape='box', fontsize='8')
    
    for col, ref_table, ref_col in fks:
        foreign_keys[(table, col)] = (ref_table, ref_col)
        dot.edge(table, ref_table, label=f'{col} → {ref_col}')

# Display the diagram with added column names and relationships
dot.render('/mnt/data/erd_diagram_detailed', format='png', cleanup=False)
'/mnt/data/erd_diagram_detailed.png'
