# Import all the required libraries
from PyQt6 import QtWidgets, uic,QtGui, QtCore
import sys
import pyodbc
from PyQt6.QtWidgets import QTableWidgetItem,QMessageBox


server="DESKTOP-6J02DRS\SQLEXPRESS"
database="IlajNow"
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

app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our class
app.exec()  # Start the application
