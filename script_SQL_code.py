import pandas as pd

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
            # For fee, handle missing fee as 'NA'
            fee_value = f"'{row['fee']}'" if row['fee'] != 'NA' else "'NA'"
            
            # Generate the SQL insert statement for each row
            sql_statement = f"INSERT INTO Doctors (name, designation, speciality, location, fee) VALUES ('{row['name']}', '{row['designation']}', '{row['speciality']}', '{row['location']}', {fee_value});\n"
            
            # Write the SQL statement to the file
            file.write(sql_statement)

    print(f"SQL insert statements have been written to {output_file}")

# Path to your input CSV file and output txt file
csv_file = 'IlajNow/Doctors_in_Pakistancsv.csv'
output_file = 'IlajNow/doctors_insert_statements.txt'

# Generate the SQL insert statements
generate_sql_insert_statements(csv_file, output_file)
