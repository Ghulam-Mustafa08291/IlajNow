import sqlite3
import pandas as pd

# Connect to SQLite database (it creates the database file if it doesn't exist)
conn = sqlite3.connect('my_database.db')
cursor = conn.cursor()

# Load CSV file into pandas DataFrame
df = pd.read_csv('your_file.csv')

# Convert DataFrame to SQL table
df.to_sql('table_name', conn, if_exists='replace', index=False)

# Commit and close the connection
conn.commit()
conn.close()
    