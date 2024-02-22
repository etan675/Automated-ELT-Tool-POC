import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import sys

input_file_path = sys.argv[1]
output_file_path = sys.argv[2]
drop_option = 'column'

def convert_csv_to_parquet(input_file_path, output_file_path, drop_option):
    # Read CSV file into a Pandas DataFrame
    df = pd.read_csv(input_file_path, sep='\t', on_bad_lines='skip')

    # Remove rows or columns with NaN fields based on the drop_option argument
    if drop_option == 'row':
        df = df.dropna()
    elif drop_option == 'column':
        df = df.dropna(axis=1)

    # Convert Pandas DataFrame to PyArrow Table
    table = pa.Table.from_pandas(df)

    # Write PyArrow Table to Parquet file
    pq.write_table(table, output_file_path)

    # Open the Parquet file
    table = pq.read_table(output_file_path)

    # Convert the table to a Pandas DataFrame
    df = table.to_pandas()

    # Print the DataFrame
    print(df.head(1000))

#execute func
convert_csv_to_parquet(input_file_path, output_file_path, drop_option)