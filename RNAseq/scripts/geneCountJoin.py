import argparse
import os

parser = argparse.ArgumentParser(description='Process input and output files.')

parser.add_argument('-i', '--input_files', nargs='+', help='Input file names (multiple files)', required=True)
parser.add_argument('-o', '--output_file', help='Output file name', required=True)
parser.add_argument('-s', '--skip_lines', type=int, help='Number of lines to skip in each input file', default=0)

args = parser.parse_args()

input_files = args.input_files
output_file = args.output_file
skip_lines = args.skip_lines

# Create a dictionary to store the data from all input files
data = {}

# Loop through all input files and store the data in the dictionary
for file in input_files:
    with open(file, 'r') as f:
        for i, line in enumerate(f):
            if i < skip_lines:
                continue
            line = line.strip().split()
            key = line[0]
            value = line[1]
            if key in data:
                data[key].append(value)
            else:
                data[key] = [value]

# Write the data from the dictionary to the output file
with open(output_file, 'w') as f:
    f.write("Transcript\t" + "\t".join([os.path.basename(x.replace("_ReadsPerGene.out.tab","")) for x in input_files]) + "\n")
    for key, values in data.items():
        f.write(key + '\t' + '\t'.join(values) + '\n')

print('Completed Files: ', output_file)