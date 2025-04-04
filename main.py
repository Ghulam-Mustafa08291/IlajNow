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

        self.sign_up_health_info_screen.pushButton_2.clicked.connect(self.handle_create_account)
        
        # print("printing the new user name:",self.new_user_name)    

    def handle_create_account(self):
        if self.sign_up_health_info_screen.textEdit.toPlainText():
            new_user_medical_conditions=self.sign_up_health_info_screen.textEdit.toPlainText()
        
        if self.sign_up_health_info_screen.textEdit_2.toPlainText():
            new_user_allergies=self.sign_up_health_info_screen.textEdit_2.toPlainText()
        
        if self.sign_up_health_info_screen.textEdit_3.toPlainText():
            new_user_current_medication=self.sign_up_health_info_screen.textEdit_3.toPlainText()
            
        if self.sign_up_health_info_screen.lineEdit.text():
            new_user_current_doctor=self.sign_up_health_info_screen.lineEdit.text()
                
        print("pressed the create account button in signup health info,so now am saving detials of that signup health info screen")
        print("new_user_medical_conditions",new_user_medical_conditions)
        print("new_user_allergies",new_user_allergies)
        print("new_user_current_medication",new_user_current_medication)
        print("new_user_current_doctor",new_user_current_doctor)
    
app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our class
app.exec()  # Start the application
