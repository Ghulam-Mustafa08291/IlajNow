# Import all the required libraries
from PyQt6 import QtWidgets, uic,QtGui, QtCore
import sys
import pyodbc
from PyQt6.QtWidgets import QTableWidgetItem,QMessageBox
from datetime import datetime
import random
from PyQt6.QtWidgets import QGroupBox, QLineEdit,QTextEdit


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
        self.symptom_result_screen=None
        self.meds_and_remedy_screen=None
        self.remedy_details_screen=None
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
                    
                     # Now, check if it's time to take the medication
                    # Now, check if it's time to take the medication
                    current_time = datetime.now()

                    # Since next_dose is already a datetime object, no need for strptime
                    if current_time == next_dose:
                        msg_box = QMessageBox()
                        msg_box.setWindowTitle("Medication Reminder")
                        msg_box.setText(f"Time to take your medication: {med_name}")
                        msg_box.exec()
                    
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

            # Fetch the personalized health tip for the logged-in user
            cursor.execute("""
                SELECT tip 
                FROM PersonalizedHealthTips 
                WHERE user_id = ?
            """, self.current_user_id)
            personalized_tip = cursor.fetchone()
            
            if personalized_tip:
                personalized_tip_content = personalized_tip[0]
                self.dashboard_screen.lineEdit.setText(personalized_tip_content)  # Set personalized health tip text
            else:
                print("No personalized health tip found for this user.")
                self.dashboard_screen.lineEdit.setText("No personalized tip available.")
                
            
            #for health alerts i first generate random id and then use that
            alert_id = random.randint(1, 60)
            print(f"Generated random alert_id: {alert_id}")
            print("the random geenrate alert id is:",alert_id)
            # Fetch the alert details from the HealthAlerts table using the generated alert_id
            cursor.execute("""
                SELECT alert_detailed 
                FROM HealthAlerts 
                WHERE alert_id = ?
            """, alert_id)
            health_alert = cursor.fetchone()
            
            if health_alert:
                alert_content = health_alert[0]
                self.dashboard_screen.lineEdit_5.setText(alert_content)  # Set health alert text
            else:
                print(f"No alert found for alert_id: {alert_id}")
                self.dashboard_screen.lineEdit_5.setText("No health alert found.")
            
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
        self.selected_symptoms.clear()
        
        for dropdown in [self.symptom_checker_screen.comboBox_2, self.symptom_checker_screen.comboBox_3,self.symptom_checker_screen.comboBox_4, self.symptom_checker_screen.comboBox_5]:
                        symptom = dropdown.currentText().strip()
                        if symptom and symptom != 'Select Symptom':  # Make sure it's not the default value
                            self.selected_symptoms.append(symptom)
                            print("the user selected symptom:",symptom)
        
        if len(self.selected_symptoms) < 2:  # Check if we have at least 2 symptoms inputted by symptom checker screen
            msg_box = QMessageBox() #MIGHT SHOW A SCREEN HERE FOR REMEDIES
            msg_box.setWindowTitle("Insufficient Symptoms")
            msg_box.setText("Please select at least two symptoms for accurate diagnosis.")
            msg_box.exec()
            return  # Exit the function if not enough symptoms are selected
        
        
         # Step 2: Lookup symptom_id for each selected symptom
        for symptom in self.selected_symptoms:
            cursor.execute("""
                SELECT symptom_id FROM SymptomsNormalized WHERE description = ?
            """, symptom)
            result = cursor.fetchone()
            if result:
                print("for entred symptom:",symptom," found symp_id:",result[0])
                self.symptom_ids.append(result[0])
            else:
                print(f"Symptom '{symptom}' not found in DB.")
                
                
        # Step 3: Get disease IDs for symptoms selected by user
        for sym_id in self.symptom_ids:
            cursor.execute("SELECT disease_id FROM SymptomCondition WHERE symptom_id = ?", sym_id)
            results = cursor.fetchall()
            for row in results:
                print("for symtpom id:",sym_id," found mathcing disease id",row[0])
                self.disease_ids.append(row[0])
                
        # Remove duplicate disease_ids
        self.disease_ids = list(set(self.disease_ids))
        
         # Step 4: Count symptoms for each disease
        self.diseases_found = {}  # Reset dictionary
        for sym_id in self.symptom_ids:
            cursor.execute("SELECT disease_id FROM SymptomCondition WHERE symptom_id = ?", (sym_id,))
            results = cursor.fetchall()
            for row in results:
                dis_id = row[0]
                cursor.execute("SELECT disease_name FROM Diseases WHERE disease_id = ?", (dis_id,))
                res = cursor.fetchone()
                if res:
                    disease_name = res[0]
                    if disease_name not in self.diseases_found:
                        self.diseases_found[disease_name] = 0
                    self.diseases_found[disease_name] += 1  # Count how many t

        # Step 5: Check if diseases have sufficient symptoms (at least 2 symptoms)
        diseases_to_display = [disease for disease, count in self.diseases_found.items() if count >= 2]      
        print("diseases to display:",diseases_to_display)
        if not diseases_to_display:
            msg_box = QMessageBox()
            msg_box.setWindowTitle("Insufficient Symptoms")
            msg_box.setText("No diseases found with sufficient symptoms (at least 2).")
            msg_box.exec()
            return
        
        
        # TILL ABOVE,WE GOT DISEASE WORTHY OF BEING DISPLAYED,NOW BELOW WE WILL DISPLAY ANY RANDOM 3 AT MAX,ON SYMPTOM RESULTS SCREEEN
        
        # Step 6: Randomly select 3 diseases (if there are more than 3 diseases)
        if len(diseases_to_display) > 3:
            diseases_to_display = random.sample(diseases_to_display, 3)
            
        
        # Step 7: Display diseases on the Symptoms Results screen
        # We will now iterate through the diseases to display them on the UI.
        self.symptom_result_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/symptom_results.ui",self.symptom_result_screen)
        self.symptom_result_screen.show()
        for idx, disease_name in enumerate(diseases_to_display):
            # Query symptoms for the current disease
            disease_name = disease_name.strip()  # Remove any accidental spaces
            cursor.execute("""
                SELECT description FROM SymptomsNormalized
                WHERE symptom_id IN (SELECT symptom_id FROM SymptomCondition WHERE disease_id = (SELECT disease_id FROM Diseases WHERE disease_name = ?))
            """, disease_name)
            symptoms = cursor.fetchall()
            symptom_list = ", ".join([symptom[0] for symptom in symptoms])

            # Query treatment for the current disease
            cursor.execute("""
                SELECT description FROM Treatments WHERE disease_id = (SELECT disease_id FROM Diseases WHERE disease_name = ?)
            """, disease_name)
            treatment = cursor.fetchone()
            treatment_text = treatment[0] if treatment else "No treatment information available."

            # Populate the UI with the disease information
            group_box = self.symptom_result_screen.findChild(QGroupBox, f"groupBox_{idx+1}")
            possible_condition_lineedit = group_box.findChild(QLineEdit, f"lineEdit_condition_{idx+1}")
            symptoms_lineedit = group_box.findChild(QLineEdit, f"lineEdit_symptoms_{idx+1}")
            treatment_lineedit = group_box.findChild(QLineEdit, f"lineEdit_treatment_{idx+1}")

            possible_condition_lineedit.setText(disease_name)
            symptoms_lineedit.setText(symptom_list)
            treatment_lineedit.setText(treatment_text)
            
        #NOW BELOW WILL WRITE LOGIC FOR VEIWING REMEDY AND MEDICINE FOR A DISEASE
        disease_1=self.symptom_result_screen.findChild(QLineEdit, "lineEdit_condition_1").text().strip()
        disease_2=self.symptom_result_screen.findChild(QLineEdit, "lineEdit_condition_2").text().strip()
        disease_3=self.symptom_result_screen.findChild(QLineEdit, "lineEdit_condition_3").text().strip()
        
        print("disease_1=",disease_1)
        print("disease_2=",disease_2)
        print("disease_2=",disease_2)

        self.symptom_result_screen.pushButton_7.clicked.connect(
            lambda: self.handle_view_remedies_meds(selected_disease_name=disease_1)
        )
        self.symptom_result_screen.pushButton_8.clicked.connect(
            lambda: self.handle_view_remedies_meds(selected_disease_name=disease_2)
        )
        self.symptom_result_screen.pushButton_9.clicked.connect(
            lambda: self.handle_view_remedies_meds(selected_disease_name=disease_2)
        )
       

    def handle_view_remedies_meds(self,selected_disease_name):
        
        self.meds_and_remedy_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/meds_&_remedy_screen.ui",self.meds_and_remedy_screen)
        self.meds_and_remedy_screen.show()
        print("hehe trying to load meds and remedy screen hehehe")
        
        
        # Step 1: Query the disease_id from the Diseases table using the passed disease_name
        cursor.execute("SELECT disease_id FROM Diseases WHERE disease_name = ?", (selected_disease_name,))
        disease_id_result = cursor.fetchone()
        
        if not disease_id_result:
            print(f"Disease with name {selected_disease_name} not found in database.")
            return  # Exit if no disease found

        disease_id = disease_id_result[0]
        print("Selected Disease ID:", disease_id)
  
        # Step 2: Get the disease's symptoms
        disease_symptoms = []  # A list to store the symptoms related to the selected disease
        cursor.execute("""
            SELECT symptom_id FROM SymptomCondition WHERE disease_id = ?
        """, (disease_id,))
        disease_symptoms_result = cursor.fetchall()
        disease_symptoms = [symptom[0] for symptom in disease_symptoms_result]
                    
        
        # Step 2: Pick 2 symptoms randomly from the selected disease's symptoms
        if len(disease_symptoms) > 2:
            disease_symptoms = random.sample(disease_symptoms, 2)
        print("disease_symptoms array:",disease_symptoms)
        print("printing names of all child widghets",self.meds_and_remedy_screen.findChildren(QGroupBox))  # This will print all groupboxes
        group_boxes = self.meds_and_remedy_screen.findChildren(QGroupBox)
        for group_box in group_boxes:
            print("group box names:",group_box.objectName())  

         # Step 3: Populate medicine details for selected symptoms
        for idx, symptom_id in enumerate(disease_symptoms):
            # Query the Medicine table for this symptom_id
            print("idx+1=",idx+1)
            cursor.execute("SELECT dosage, use_case, frequency FROM Medicine WHERE symptom_id = ?", (symptom_id,))
            medicine_info = cursor.fetchone()
            print("medicine indfo in for meds and remedy screen:",medicine_info)
            # Populate the UI for each selected symptom
            group_box = self.meds_and_remedy_screen.findChild(QGroupBox, f"groupBox_{idx+1}")
            dosage_lineedit = group_box.findChild(QLineEdit, f"lineEdit_dosage_{idx+1}")
            use_for_lineedit = group_box.findChild(QLineEdit, f"lineEdit_use_for_{idx+1}")
            frequency_lineedit = group_box.findChild(QLineEdit, f"lineEdit_frequency_{idx+1}")

            # Fill the fields with data
            if medicine_info:
                # print("medicine indfo in for meds and remedy screen:",medicine_info)
                dosage_lineedit.setText(medicine_info[0])
                use_for_lineedit.setText(medicine_info[1])
                frequency_lineedit.setText(medicine_info[2])
            else:
                dosage_lineedit.setText("Not Available")
                use_for_lineedit.setText("Not Available")
                frequency_lineedit.setText("Not Available")                   
        
         # Step 4: Populate Remedy details for one of the symptoms
        remedy_symptom = disease_symptoms[0]  # Use the first symptom from the selected symptoms
        cursor.execute("SELECT home_remedy, instruction, remedy_id FROM Remedy WHERE symptom_id = ?", (remedy_symptom,))
        remedy_info = cursor.fetchone()
        print("remedy info is:",remedy_info)
        remedy_lineedit = self.meds_and_remedy_screen.findChild(QLineEdit, "lineEdit_13")
        instruction_lineedit = self.meds_and_remedy_screen.findChild(QLineEdit, "lineEdit_14")
        remedy_id=remedy_info[2]
        if remedy_info:
            remedy_lineedit.setText(remedy_info[0])
            instruction_lineedit.setText(remedy_info[1])
        else:
            remedy_lineedit.setText("No Remedy Found")
            instruction_lineedit.setText("No Instructions Found") 
        
        self.meds_and_remedy_screen.pushButton_6.clicked.connect(
            lambda: self.handle_view_remedy_detail(remedy_id=remedy_id)
        )
        
        
    def handle_view_remedy_detail(self,remedy_id):
        print("tryanna load remedy detail page")
        self.remedy_details_screen=QtWidgets.QMainWindow()
        uic.loadUi("Screens/remedy_detail_screen.ui",self.remedy_details_screen)
        self.remedy_details_screen.show()
        print("hehe trying to load remedy details screen in dashboard")
        
         # Step 1: Query RemedyDetail table to get full_remedy for the given remedy_id
        cursor.execute("SELECT full_remedy FROM RemedyDetail WHERE remedy_id = ?", (remedy_id,))
        remedy_detail = cursor.fetchone()

        # Step 2: Check if remedy_detail exists and get the full_remedy
        if remedy_detail:
            full_remedy = remedy_detail[0]
            print(f"Full Remedy: {full_remedy}")  # Optional: Check what we get from the DB

            # Step 4: Find the QTextEdit widget on the screen and set its text
            remedy_text_edit = self.remedy_details_screen.findChild(QTextEdit, "textEdit")

            if remedy_text_edit:
                remedy_text_edit.setText(full_remedy)  # Set the remedy details to the QTextEdit widget
            else:
                print("Error: QTextEdit widget not found in the UI.")
        else:
            print(f"No remedy details found for remedy_id: {remedy_id}")
        
        
        
        
        
    def handle_click(self):
        self.start_screen_email_field.setPlaceholderText("Enter your email address")
        
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
