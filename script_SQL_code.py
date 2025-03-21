import pandas as pd
import re
import os

def generate_sql_insert_statements(csv_file, output_file):
    # Check if the file exists
    if not os.path.exists(csv_file):
        print(f"Error: The file {csv_file} does not exist.")
        return

    # Load the CSV file
    df = pd.read_csv(csv_file)

    # Open the output file in write mode with UTF-8 encoding
    with open(output_file, 'w', encoding='utf-8') as file:
        # Iterate over each row in the dataframe
        for index, row in df.iterrows():
            # Generate a unique disease_id (starting from 1 and incrementing)
            disease_id = index + 1

            # Clean symptoms data (if missing, set to NULL)
            symptoms = []
            for i in range(1, 18):  # Symptoms are in columns symptom_1 to symptom_17
                symptom_column = f'Symptom_{i}'  # Adjusted based on actual column names
                symptom = row[symptom_column] if pd.notna(row[symptom_column]) else 'NULL'
                symptoms.append(symptom)

            # Format the symptoms into a string for SQL (NULL will remain as NULL)
            symptoms_string = ', '.join([f"'{symptom}'" if symptom != 'NULL' else 'NULL' for symptom in symptoms])

            # Generate the SQL insert statement for each row
            sql_statement = f"INSERT INTO Symptoms (disease_id, disease_name, symptom_1, symptom_2, symptom_3, symptom_4, symptom_5, symptom_6, symptom_7, symptom_8, symptom_9, symptom_10, symptom_11, symptom_12, symptom_13, symptom_14, symptom_15, symptom_16, symptom_17) VALUES ({disease_id}, '{row['Disease']}', {symptoms_string});\n"

            # Write the SQL statement to the file
            file.write(sql_statement)

    print(f"SQL insert statements have been written to {output_file}")

# Absolute paths to your input CSV file and output txt file
csv_file = r'C:\Users\LAPTOP WORLD\OneDrive - Habib University\University\sem 6\SE\Project\IlajNow\Dataset\DiseaseAndSymptoms.csv'  # Correct the path here
output_file = r'C:\Users\LAPTOP WORLD\OneDrive - Habib University\University\sem 6\SE\Project\IlajNow\symptoms_insert_statements.txt'  # Your desired output file path

# Generate the SQL insert statements
generate_sql_insert_statements(csv_file, output_file)
