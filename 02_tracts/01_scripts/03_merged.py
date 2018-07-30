#!/usr/bin/env python3
"""
Usage:
    <program> INPUT_DIRECTORY
"""

# Modules
import os
import sys
import glob

# Functions
def get_file_list(pathDir,pattern):
    return glob.glob(pathDir +"*"+pattern)

# Parse user input
try:
    INPUT_DIRECTORY = sys.argv[1]

except:
    print(__doc__)
    sys.exit()

# Get file names
files = get_file_list(INPUT_DIRECTORY, "_res2")

# Create output file name

output_file = INPUT_DIRECTORY + "seuil_0.1_results.res3"

# Iterate through input files and append results to output
with open(output_file, "w") as outfile:

    for f in files:

         # grep LG number :example filename: temps_files_OMR/ABE_sf1.dom._0.05_0.95_HET.res2
        num = f.split("_sf")[1].split(".dom")[0]
        pop = f.split("/")[1].split("_")[0] 
        traitement = f.split(".9_")[1].split("seuil")[0] 

        lines = open(f, "r").readlines()
        result = []

        for line in lines:
            result.append(line.strip()+ "\t" + num + "\t" +  pop + "\t"+ traitement)

        outfile.write("\n".join(result) + "\n")
