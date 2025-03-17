import pandas as pd
import os
import re  # Import regular expressions for cleaning

def generate_sql_insert_statements(csv_file, output_file):
    # Load the CSV file
    df = pd.read_csv(csv_file)

    # Iterate over each row and replace missing values with 'NA' for each field
    for column in df.columns:
        df[column] = df[column].fillna('NA')

    # Open the output file in write mode with UTF-8 encoding
    with open(output_file, 'w', encoding='utf-8') as file:
        # Iterate over each row in the dataframe
        for index, row in df.iterrows():
            # For fee, handle missing fee as 'NA' and clean up to get just the number
            fee_value = re.sub(r'\D', '', str(row['fee'])) if row['fee'] != 'NA' else "NULL"
            
            # Generate the SQL insert statement for each row
            sql_statement = f"INSERT INTO Doctors (name, designation, speciality, location, fee) VALUES ('{row['name']}', '{row['designation']}', '{row['speciality']}', '{row['location']}', {fee_value});\n"
            
            # Write the SQL statement to the file
            file.write(sql_statement)

    print(f"SQL insert statements have been written to {output_file}")

# Absolute paths to your input CSV file and output txt file
csv_file = r'C:\Users\LAPTOP WORLD\OneDrive - Habib University\University\sem 6\SE\Project\IlajNow\Doctors_in_Pakistancsv.csv'
output_file = r'C:\Users\LAPTOP WORLD\OneDrive - Habib University\University\sem 6\SE\Project\IlajNow\doctors_insert_statements.txt'

# Generate the SQL insert statements
generate_sql_insert_statements(csv_file, output_file)
