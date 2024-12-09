import pandas as pd

# Path to the TSV file
file_path = r'F:\SCANS\0-ME-Collagen Project\0- MTC TMAs\Cores for matrix topography\FIM2\Qupath\FIM2_measurements_Haralick.tsv'

# Read the TSV file
df = pd.read_csv(file_path, delimiter='\t')

# Ensure that empty entropy values are represented as NaN
entropy_column = 'ROI: 1.00 px per pixel: DAB: Haralick Entropy (F8)'
df[entropy_column] = pd.to_numeric(df[entropy_column], errors='coerce')

# Group by 'Image'and calculate mean and median
result = df.groupby(['Image'])[entropy_column].agg(['mean', 'median']).reset_index()

# Rename columns
result.columns = ['Image', 'Mean Entropy', 'Median Entropy']

# Save the results to a new TSV file
output_path = r'F:\SCANS\0-ME-Collagen Project\0- MTC TMAs\Cores for matrix topography\FIM2\Qupath\entropy_results.tsv'
result.to_csv(output_path, sep='\t', index=False)

print('The mean and median entropy values have been successfully calculated and saved.')
