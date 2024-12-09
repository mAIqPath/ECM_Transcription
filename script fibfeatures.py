import os
import pandas as pd
import re

# Define the directory containing your CSV files
directory = 'F:/0-ME-Collagen Project/CTFire/ROIS/output/CA_Out'

# Compile regular expression pattern for matching file names (TB, PIF, DIF)
pattern = re.compile(r'(TB|PIF|DIF)\d+_Colour_1_fibFeatures\.csv')

# List of column names from column 10 to 27 (for labeling purposes)
column_names = [
    'f10 : dist to nearest 2', 'f11 : dist to nearest 4', 'f12 : dist to nearest 8',
    'f13 : dist to nearest 16', 'f14 : mean nearest dist', 'f15 : std nearest dist',
    'f16 : box density 32', 'f17 : box density 64', 'f18 : box density 128',
    'f19 : alignment of nearest 2', 'f20 : alignment of nearest 4', 'f21 : alignment of nearest 8',
    'f22 : alignment of nearest 16', 'f23 : mean nearest align', 'f24 : std nearest align',
    'f25 : box alignment 32', 'f26 : box alignment 64', 'f27 : box alignment 128'
]

# Initialize a list to store summary data for each file and column
summary_data = []

# Iterate through the files in the directory
for filename in os.listdir(directory):
    if pattern.match(filename):
        file_path = os.path.join(directory, filename)
        
        # Read the CSV file
        df = pd.read_csv(file_path)

        # Select the columns of interest (columns 9 to 26)
        df_selected = df.iloc[:, 9:27]

        # Calculate mean, median, and standard deviation for each column
        for i, col in enumerate(df_selected.columns):
            summary = {
                "File Name": filename,
                "Column": column_names[i],
                "Mean": df_selected[col].mean(),
                "Median": df_selected[col].median(),
                "Standard Deviation": df_selected[col].std()
            }
            summary_data.append(summary)

# Convert the summary data into a DataFrame
summary_df = pd.DataFrame(summary_data)

# Save the summary DataFrame to a CSV file
summary_file_path = os.path.join(directory, 'summary_fibfeatures.csv')
summary_df.to_csv(summary_file_path, index=False)

print(f"Summary saved to {summary_file_path}")
