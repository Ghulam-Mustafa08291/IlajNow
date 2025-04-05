# Import all the required libraries
from PyQt6 import QtWidgets, uic,QtGui, QtCore
import sys
import pyodbc
from PyQt6.QtWidgets import QTableWidgetItem,QMessageBox

#signup personal info screen values to be stored here
new_user_name="" 
new_user_email=""
new_user_password=""
new_user_age=""
new_user_number=""
new_user_house_no=""
new_user_area=""
new_user_emergency_contact_name=""
new_user_emergency_contact_number=""
new_user_gender=""
new_user_city=""

#signup health info screen values to be stored here
new_user_medical_conditions=""
new_user_allergies=""
new_user_current_medication=""
new_user_current_doctor=""

server="DESKTOP-6J02DRS\SQLEXPRESS"
database="testing"
use_windows_authentication=True
username=""
password=""

if use_windows_authentication:
    connection_string=f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;"
else:
   connection_string= f"Driver={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}"

connection=pyodbc.connect(connection_string)

cursor=connection.cursor()


class UI(QtWidgets.QMainWindow):
    def __init__(self):
        # Call the inherited classes __init__ method
        super(UI, self).__init__()
        
        uic.loadUi('Screens/start_screen.ui', self)
        self.new_user_current_medication_lst=[]
        self.sign_up_personal_info_screen=None
        self.sign_up_health_info_screen=None

        # Show the GUI
        self.show()
        # Event Handling
        self.sign_up_button.clicked.connect(self.handle_click)
        self.login_button.clicked.connect(self.handle_login)
        self.sign_up_button.clicked.connect(self.handle_sign_up)
        
    def handle_login(self):
        entered_email=self.start_screen_email_field.text()
        entered_password=self.start_screen_password_field.text()
        cursor.execute(f"SELECT email FROM Users WHERE email = '{entered_email}' AND password = '{entered_password}'")    
        rows=cursor.fetchall()
        if len(rows)==0:
            msg_box = QMessageBox()
            msg_box.setWindowTitle('Login failed')
            msg_box.setText('no user found!')
            msg_box.exec()
        else:
          
            print(rows)
            msg_box = QMessageBox()
            msg_box.setWindowTitle('Login passed')
            msg_box.setText('user found!')
            msg_box.exec()
            
            # self.home_screen=QtWidgets.QMainWindow() #window is initialized to none in the init function
            # uic.loadUi("HOME.ui",self.home_screen)
        
        
    def handle_click(self):
        self.start_screen_email_field.setText("Welcome to QT Designer")
        
    def handle_sign_up(self):
 
        self.sign_up_personal_info_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/sign_up_personal_info_Screen.ui",self.sign_up_personal_info_screen)
        self.sign_up_personal_info_screen.show()
        print("hehe trying to go to health info sign up screen")
        
      
        
        self.sign_up_personal_info_screen.to_health_info.clicked.connect(self.handle_health_info)


    def handle_health_info(self):
        self.sign_up_health_info_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/sign_up_health_info_screen.ui",self.sign_up_health_info_screen)
        self.sign_up_health_info_screen.show()   
        
        
        # new_user_name=""
        # new_user_email=""
        # new_user_password=""
        # new_user_age=""
        # new_user_number=""
        # new_user_house_no=""
        # new_user_area=""
        # new_user_emergency_contact_name=""
        # new_user_emergency_contact_number=""
        # new_user_gender=""
        # new_user_city=""
        global new_user_name, new_user_email, new_user_password, new_user_age, new_user_number
        global new_user_house_no, new_user_area, new_user_emergency_contact_name, new_user_emergency_contact_number
        global new_user_gender, new_user_city

        
        # self.sign_up_personal_info_screen.to_health_info.clicked.connect()
        if self.sign_up_personal_info_screen.lineEdit.text():
            new_user_name=self.sign_up_personal_info_screen.lineEdit.text()
        
        if self.sign_up_personal_info_screen.lineEdit_2.text():
            new_user_email=self.sign_up_personal_info_screen.lineEdit_2.text()
        # print(new_user_name,new_user_email)
        
        if self.sign_up_personal_info_screen.lineEdit_3.text():
            new_user_password=self.sign_up_personal_info_screen.lineEdit_3.text()
        
        if self.sign_up_personal_info_screen.lineEdit_4.text():
            new_user_age=self.sign_up_personal_info_screen.lineEdit_4.text()
        
        if self.sign_up_personal_info_screen.lineEdit_5.text():
            new_user_number=self.sign_up_personal_info_screen.lineEdit_5.text()
            # print("printing the new user number:,",new_user_number)
        
        if self.sign_up_personal_info_screen.lineEdit_6.text():
            new_user_house_no=self.sign_up_personal_info_screen.lineEdit_6.text()
            
        if self.sign_up_personal_info_screen.lineEdit_7.text():
            new_user_area=self.sign_up_personal_info_screen.lineEdit_7.text()
            
        if self.sign_up_personal_info_screen.lineEdit_8.text():
            new_user_emergency_contact_name=self.sign_up_personal_info_screen.lineEdit_8.text()
            
        if self.sign_up_personal_info_screen.lineEdit_9.text():
            new_user_emergency_contact_number=self.sign_up_personal_info_screen.lineEdit_9.text()
            
        if self.sign_up_personal_info_screen.comboBox.currentText():
            new_user_gender=self.sign_up_personal_info_screen.comboBox.currentText()
        
        if self.sign_up_personal_info_screen.comboBox_2.currentText():
            new_user_city=self.sign_up_personal_info_screen.comboBox_2.currentText() 
        
        print("pressed the Next:health info button and am now in the next health info screen so will save details of prev screen\n")
        print("new_user_name:",new_user_name)
        print("new_user_email",new_user_email)
        print("new_user_password",new_user_password)
        print("new_user_age",new_user_age)
        print("new_user_gender",new_user_gender)
        print("new_user_number",new_user_number)
        print("new_user_house_no",new_user_house_no)
        print("new_user_area",new_user_area)
        print("new_user_city",new_user_city)
        print("new_user_emergency_contact_name",new_user_emergency_contact_name)
        print("new_user_emergency_contact_number",new_user_emergency_contact_number)

        self.sign_up_health_info_screen.pushButton_3.clicked.connect(self.save_new_user_current_medication_to_lst) #when the save button is clicked,next to the current medication entry
        self.sign_up_health_info_screen.pushButton_2.clicked.connect(self.handle_create_account)
        
        
        # print("printing the new user name:",self.new_user_name)    

    def save_new_user_current_medication_to_lst(self):
        medication_input = self.sign_up_health_info_screen.textEdit_3.toPlainText().strip()
        
         # Check if the input is empty
        if not medication_input:
            msg_box = QMessageBox()
            msg_box.setWindowTitle('Error')
            msg_box.setText('Input field is empty! Please enter medication details.')
            msg_box.exec()
            return
        
        # Split the input string by commas
        medication_details = medication_input.split(',')
        
        # Ensure the user has entered exactly 5 values (name, dosage, frequency, next_dose, supply_remaining)
        if len(medication_details) != 5:
            msg_box = QMessageBox()
            msg_box.setWindowTitle('Error')
            msg_box.setText('Invalid input format! Please enter all 5 fields separated by commas.')
            msg_box.exec()
            return

         # Parse individual values from the list
        medication_name = medication_details[0].strip()
        medication_dosage = medication_details[1].strip()
        medication_frequency = medication_details[2].strip()
        medication_next_dose = medication_details[3].strip()
        medication_supply_remaining = medication_details[4].strip()
        
         # Validate that all fields are provided
        if not medication_name or not medication_dosage or not medication_frequency or not medication_next_dose or not medication_supply_remaining:
            msg_box = QMessageBox()
            msg_box.setWindowTitle('Error')
            msg_box.setText('One or more fields are missing. Please provide all the details.')
            msg_box.exec()
            return
        
        medication_tuple = (
            medication_name,
            medication_dosage,
            medication_frequency,
            medication_next_dose,
            medication_supply_remaining
        )
        
         # Add the medication details to the list
        self.new_user_current_medication_lst.append(medication_tuple)

        # Debugging print to confirm
        print(f"Medication added: {medication_tuple}")
        print(f"Current medications list: {self.new_user_current_medication_lst}")
        
         # Optionally, clear the input field for the next entry
        self.sign_up_health_info_screen.textEdit_3.clear()
    
    def handle_create_account(self):
    
        global new_user_name, new_user_email, new_user_password, new_user_age, new_user_number
        global new_user_house_no, new_user_area, new_user_emergency_contact_name, new_user_emergency_contact_number
        global new_user_gender, new_user_city, new_user_medical_conditions, new_user_allergies, new_user_current_medication, new_user_current_doctor

        # Collecting data from the UI inputs
        if self.sign_up_health_info_screen.textEdit.toPlainText():
            new_user_medical_conditions = self.sign_up_health_info_screen.textEdit.toPlainText()

        if self.sign_up_health_info_screen.textEdit_2.toPlainText():
            new_user_allergies = self.sign_up_health_info_screen.textEdit_2.toPlainText()

        if self.sign_up_health_info_screen.textEdit_3.toPlainText():
            new_user_current_medication = self.sign_up_health_info_screen.textEdit_3.toPlainText()

        if self.sign_up_health_info_screen.lineEdit.text():
            new_user_current_doctor = self.sign_up_health_info_screen.lineEdit.text()
                    
        print("Pressed the create account button in signup health info, saving details of that signup health info screen:")
        print("new_user_medical_conditions", new_user_medical_conditions)
        print("new_user_allergies", new_user_allergies)
        print("new_user_current_medication", new_user_current_medication)
        print("new_user_current_doctor", new_user_current_doctor)
        
        # Step 2: Manually get the maximum user_id and generate the new user_id
        cursor.execute('SELECT MAX(user_id) FROM Users')
        max_user_id = cursor.fetchone()[0]  # Get the maximum user_id

        # Increment the user_id for the new user
        if max_user_id is not None:
            new_user_id = max_user_id + 1  # Increment the maximum user_id by 1 for the new user
        else:
            new_user_id = 1  # If no users exist, start from 1

        print(f"Generated new_user_id: {new_user_id}")

        # Enable IDENTITY_INSERT to allow explicit insertion of values into the IDENTITY column
        cursor.execute("SET IDENTITY_INSERT Users ON")

        # Step 3: Insert user data into the Users table using the manually generated user_id
        cursor.execute("""
            INSERT INTO Users (user_id, email, password) 
            VALUES (?, ?, ?)
        """, new_user_id, new_user_email, new_user_password)

        # Disable IDENTITY_INSERT after the insert is done
        cursor.execute("SET IDENTITY_INSERT Users OFF")

        print("gender:", new_user_gender)
        # Step 4: Insert personal information into the User_details table
        cursor.execute("""
            INSERT INTO User_details (user_id, full_name, age, gender, phone_number, house_no, city, area)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, new_user_id, new_user_name, new_user_age, new_user_gender, new_user_number, new_user_house_no, new_user_city, new_user_area)

        # Step 5: Insert emergency contact information into the EmergencyContact table
        cursor.execute("""
            INSERT INTO EmergencyContact (user_id, name, number)
            VALUES (?, ?, ?)
        """, new_user_id, new_user_emergency_contact_name, new_user_emergency_contact_number)

        # Step 6: Insert medical conditions into UserMedicalCondition table
        conditions = new_user_medical_conditions.split(',')  # Split the string into individual conditions
        for condition in conditions:
            cursor.execute("""
                SELECT condition_id FROM Medical_conditions WHERE condition_name = ?
            """, condition)
            condition_id = cursor.fetchone()
            if condition_id:
                cursor.execute("""
                    INSERT INTO UserMedicalCondition (user_id, condition_id)
                    VALUES (?, ?)
                """, new_user_id, condition_id[0])

        # Step 7: Insert allergies into UserAllergy table
        allergies = new_user_allergies.split(',')  # Split the string into individual allergies
        for allergy in allergies:
            cursor.execute("""
                SELECT allergy_id FROM Allergies WHERE allergy_name = ?
            """, allergy)
            allergy_id = cursor.fetchone()
            if allergy_id:
                cursor.execute("""
                    INSERT INTO UserAllergy (user_id, allergy_id)
                    VALUES (?, ?)
                """, new_user_id, allergy_id[0])

        # Step 8: Insert medications into Medications table from the new_user_current_medication_lst
        for medication in self.new_user_current_medication_lst:
            medication_name = medication[0]
            medication_dosage = medication[1]
            medication_frequency = medication[2]
            medication_next_dose = medication[3]
            medication_supply_remaining = medication[4]

            # Insert the medication into the Medications table
            cursor.execute("""
                INSERT INTO Medications (user_id, name, dosage, frequency, next_dose, supply_remaining)
                VALUES (?, ?, ?, ?, ?, ?)
            """, new_user_id, medication_name, medication_dosage, medication_frequency, medication_next_dose, medication_supply_remaining)

        # Step 9: Insert health info into Health_info table
        cursor.execute("""      
            SELECT doctor_id FROM Doctors WHERE name = ?
        """, new_user_current_doctor)
        doctor_id = cursor.fetchone()
        if doctor_id:
            cursor.execute("""
                INSERT INTO Health_info (user_id, doctor_id, prescription_path)
                VALUES (?, ?, ?)
            """, new_user_id, doctor_id[0], "path_to_prescription")

        # Commit the changes to the database
        connection.commit()
        print("Account created successfully.")

        
    
app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our class
app.exec()  # Start the application
