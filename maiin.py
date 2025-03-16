# Import all the required libraries
from PyQt6 import QtWidgets, uic, QtGui, QtCore
import sys

class UI(QtWidgets.QMainWindow):
    def __init__(self):
        # Call the inherited classes __init__ method
        super(UI, self).__init__()
        
        uic.loadUi('Screens/start_screen.ui', self)

        # Show the GUI
        self.show()
        # Event Handling
        self.sign_up_button.clicked.connect(self.handle_click)

    def handle_click(self):
        self.lineEdit.setText("Welcome to QT Designer")

app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our class
app.exec()  # Start the application
