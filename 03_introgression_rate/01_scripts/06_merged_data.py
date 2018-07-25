
#!/usr/bin/env python3
"""Merge LGs by population

Usage:
    <program> INPUT_DIRECTORY OUTPUT_DIRECTORY POP
"""

# Modules
import os
import sys
import glob

# Functions
def get_file_list(pathDir, prefix, postfix):
    return glob.glob(os.path.join(pathDir, prefix) + "*" + postfix)

# Parse user input
try:
    INPUT_DIRECTORY = sys.argv[1]
    OUTPUT_DIRECTORY = sys.argv[2]
    POP = sys.argv[3]
except:
    print(__doc__)
    sys.exit()

# Get file names
files = get_file_list(INPUT_DIRECTORY, POP, "_introgression_rate.txt")

# Create output file name
output_file = os.path.join(OUTPUT_DIRECTORY, POP) + "_introgression_rate_all_LGs.txt"

# Iterate through input files and append results to output
with open(output_file, "w") as outfile:

    # Write header
    header = "lg\t" + open(files[0]).readlines()[0]
    outfile.write(header)

    for f in files:
        # grep LG number from input file name (ex: ABE_mg8.sf1_introgression_rate.txt)
        num = f.split("sf")[1].split("_")[0]

        lines = open(f, "r").readlines()
        result = []

        for line in lines:
            if not line.startswith("snps"):
                result.append(num + "\t" + line.strip())

        outfile.write("\n".join(result) + "\n")
