## Estimation of the length and the number of introgressed haplotypes

The aim of this section is to retrieved the length of the domestic introgressed tracts. For the methods please refer to our article : https://doi.org/10.1111/mec.14816
This code is an example and need to be adapted to your own data, please be cautionous. 

### Step 1: 

This step aim to retrive only the ancestry of interest for each linkage groups (here 42, do not forget to adjust this number), in this example we chose the domestic ancestry. 

```
R 01_prepare_files.R
```

### Step 2:

This step aim to determind the start and end position of each domestic haplotypes (see article for details)

```
phyton 02_PosStartStop.py

```

### Step 3
Meged data and create a summary table 

```
phyton 03_merged.py

bash 04_final_summary.sh

bash 05_remove_emptyline

```

### Step 4: compute the CAI
