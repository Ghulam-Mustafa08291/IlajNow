# Import all the required libraries
from PyQt6 import QtWidgets, uic,QtGui, QtCore
import sys
import pyodbc
from PyQt6.QtWidgets import QTableWidgetItem,QMessageBox
from datetime import datetime

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
database="IlajNow_Final"
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
        self.entered_symptoms = []
        self.symptom_ids = []
        self.disease_ids = []
        self.disease_names = []
        self.treatments = []
        self.selected_symptoms = []  # To store selected symptoms
        self.diseases_found = {}     # To store diseases and their corresponding symptom counts
        
        
        self.sign_up_personal_info_screen=None
        self.sign_up_health_info_screen=None
        self.dashboard_screen=None
        self.current_email=None
        self.current_password=None
        self.current_user_id=None
        self.symptom_checker_screen=None

        # Show the GUI
        self.show()
        # Event Handling
        self.sign_up_button.clicked.connect(self.handle_click)
        self.login_button.clicked.connect(self.handle_login)
        self.sign_up_button.clicked.connect(self.handle_sign_up)
        
    def handle_login(self):
        self.current_email=self.start_screen_email_field.text()
        self.current_password=self.start_screen_password_field.text()
        cursor.execute(f"SELECT email FROM Users WHERE email = '{self.current_email}' AND password = '{self.current_password}'")    
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
            
            
            
            
            # NOW BELOW TRYNNA IMPLEMENT THE DASHBOARD LOGIC
            self.dashboard_screen=QtWidgets.QMainWindow()
            uic.loadUi("Screens/dashboard_screen.ui",self.dashboard_screen)
            self.dashboard_screen.show()
            print("hehe trying to go to load dashboared hehe")
            
            self.dashboard_screen.pushButton_5.clicked.connect(self.handle_symptom_checker)
            
            cursor.execute("""
            SELECT user_id FROM Users 
            WHERE email = ? AND password = ?
        """, self.current_email, self.current_password)
            
            user_id_result = cursor.fetchone()
            # print("in dashboardscreen,user id:",self.current_user_id)
            if user_id_result:
                self.current_user_id = user_id_result[0]
                print(f"in dashboard screen,Logged-in user_id: {self.current_user_id}")
                
                # Now fetch the medication reminder and next dose
                cursor.execute("""
                    SELECT name, next_dose 
                    FROM Medications 
                    WHERE user_id = ?
                """, self.current_user_id)
                medication = cursor.fetchone()
                
                if medication:
                    med_name, next_dose = medication
                    print(f"Medication: {med_name}, Next Dose: {next_dose}") 
                    self.dashboard_screen.lineEdit_2.setText(str(med_name))
                    self.dashboard_screen.lineEdit_3.setText(str(next_dose))
                else:
                    print("No medication found for this user.")
            else:
                print("Could not find user_id for the logged-in user.")

            
            #now for getting the seasonal tips
            current_date = datetime.now().date()
            print(f"Current Date: {current_date}")    
            
            # Step 2: Fetch seasonal health tip valid for today
            cursor.execute("""
                SELECT content 
                FROM HealthTips 
                WHERE type = 'Seasonal' 
                AND valid_from <= ? 
                AND valid_to >= ?
            """, current_date, current_date)    
            
            seasonal_tip = cursor.fetchone()
            
            if seasonal_tip:
                seasonal_tip_content = seasonal_tip[0]
                print(f"in dashboard screen,Seasonal Health Tip: {seasonal_tip_content}")
                 # Set the seasonal health tip into the line edit on the dashboard
                self.dashboard_screen.lineEdit_4.setText(seasonal_tip_content)
            else:
                print("No seasonal health tip valid for today.")
                self.dashboard_screen.lineEdit_4.setText("No seasonal tip for today,stay safe :)")

            
            
            # self.home_screen=QtWidgets.QMainWindow() #window is initialized to none in the init function
            # uic.loadUi("HOME.ui",self.home_screen)
     
    # def load_dashboard(self):
    #     print("hehe trynna load dashboard")   
      
    def handle_symptom_checker(self):
        self.symptom_checker_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/symptoms_checker.ui",self.symptom_checker_screen)
        self.symptom_checker_screen.show()
        print("hehe trying to load symptom checker screen in dashboard")
        
        #below logic to get symtpoms from user
        
        
            
        self.symptom_checker_screen.pushButton.clicked.connect(self.handle_check_symptoms)
            
    def handle_check_symptoms(self):
        # Clear previous entries
        self.entered_symptoms.clear()
        self.symptom_ids.clear()
        self.disease_ids.clear()
        self.disease_names.clear()
        self.treatments.clear()
        
        for dropdown in [self.symptom_checker_screen.comboBox_2, self.symptom_checker_screen.comboBox_3,self.symptom_checker_screen.comboBox_4, self.symptom_checker_screen.comboBox_5]:
                        symptom = dropdown.currentText()
                        if symptom and symptom != 'Select Symptom':  # Make sure it's not the default value
                            self.selected_symptoms.append(symptom)
                            print("the user selected symptom:",symptom)
        
        if len(self.selected_symptoms) < 2:  # Check if we have at least 2 symptoms inputted by symptom checker screen
            msg_box = QMessageBox() #MIGHT SHOW A SCREEN HERE FOR REMEDIES
            msg_box.setWindowTitle("Insufficient Symptoms")
            msg_box.setText("Please select at least two symptoms for accurate diagnosis.")
            msg_box.exec()
            return  # Exit the function if not enough symptoms are selected
        
        # # Step 1: Get symptoms entered by user
        # raw_input = self.symptom_checker_screen.textEdit.toPlainText()

        # if not raw_input.strip():
        #     msg_box = QMessageBox()
        #     msg_box.setWindowTitle("No Input")
        #     msg_box.setText("Please enter at least one symptom.")
        #     msg_box.exec()
        #     return
        
        #  # Step 2: Clean and split symptoms
        # symptoms = [sym.strip() for sym in raw_input.split(',') if sym.strip()]
        # self.entered_symptoms = symptoms

        # print("Entered Symptoms:", self.entered_symptoms)
        
        #  # Step 3: Lookup symptom_id for each
        # for symptom in self.entered_symptoms:
        #     cursor.execute("""
        #         SELECT symptom_id FROM SymptomsNormalized WHERE description = ?
        #     """, symptom)
        #     result = cursor.fetchone()
        #     if result:
        #         self.symptom_ids.append(result[0])
        #     else:
        #         print(f"Symptom '{symptom}' not found in DB.")
        
        # print("Symptom IDs found:", self.symptom_ids)
        
        # if not self.symptom_ids:
        #     msg_box = QMessageBox()
        #     msg_box.setWindowTitle("No Matches")
        #     msg_box.setText("None of the entered symptoms matched our records.")
        #     msg_box.exec()
        #     return
        
        #  # Step 4: Get disease IDs from SymptomCondition
        # for sym_id in self.symptom_ids:
        #     cursor.execute("SELECT disease_id FROM SymptomCondition WHERE symptom_id = ?", sym_id)
        #     results = cursor.fetchall()
        #     for row in results:
        #         self.disease_ids.append(row[0])
        # # Optional: Remove duplicate disease_ids
        # self.disease_ids = list(set(self.disease_ids))
        
        # print("disease ids found:",self.disease_ids)
        # if not self.disease_ids:
        #     QMessageBox.warning(self, "No Related Conditions", "No conditions found for entered symptoms.")
        #     return
        
        #     # Step 5: Get disease names
        # for dis_id in self.disease_ids:
        #     cursor.execute("SELECT disease_name FROM Diseases WHERE disease_id = ?", dis_id)
        #     res = cursor.fetchone()
        #     if res:
        #         self.disease_names.append(res[0])
        # print("disease name found:",self.disease_names) 
        #  # Step 6: Get treatments
        # for dis_id in self.disease_ids:
        #     cursor.execute("SELECT description FROM Treatments WHERE disease_id = ?", dis_id)
        #     res = cursor.fetchone()
        #     if res:
        #         self.treatments.append(res[0])
        # print("treatments found:",self.treatments)      
        #  # Step 7: Show results screen
        # self.symptom_result_screen = QtWidgets.QMainWindow()
        # uic.loadUi("Screens/symptom_results.ui", self.symptom_result_screen)
        # self.symptom_result_screen.show()
                    
        # # Step 8: Populate result fields
        # self.symptom_result_screen.textEdit.setText('\n'.join(self.disease_names))
        # self.symptom_result_screen.textEdit_2.setText(', '.join(self.entered_symptoms))
        # # self.symptom_result_screen.textEdit_3.setText('\n'.join(self.treatments))
        # formatted_treatments = []
        # for i in range(len(self.disease_names)):
        #     formatted_treatments.append(f"For {self.disease_names[i]}, use: {self.treatments[i]}")
        # self.symptom_result_screen.textEdit_3.setText('\n'.join(formatted_treatments))
        
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
        print("Account created successfully heh.")

        
    
app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our class
app.exec()  # Start the application
