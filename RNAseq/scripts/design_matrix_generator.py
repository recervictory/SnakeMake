import argparse

def parse_input_file(input_file):
    conditions = {}
    with open(input_file, 'r') as f:
        for line in f:
            condition, *samples = line.strip().split()
            conditions[condition] = samples
    return conditions

def generate_design_matrix(conditions, output_file):
    with open(output_file, 'w') as f:
        f.write("sample\tcondition\n")
        for condition, samples in conditions.items():
            for sample in samples:
                f.write(f"{sample}\t{condition}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate design matrix file")
    parser.add_argument('-i', '--input', dest='input_file', required=True, help='Input file name')
    parser.add_argument('-o', '--output', dest='output_file', required=True, help='Output file name')
    args = parser.parse_args()

    conditions = parse_input_file(args.input_file)
    generate_design_matrix(conditions, args.output_file)
