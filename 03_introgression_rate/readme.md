## Estimation of the introgression rate for each LGs and each populations

Lauch 05_introgression_rate_estimation.R from 01_Run_ELAI folder


## merged data 

```
cat ../01_Run_ELAI/02_info/populations_and_numbers_of_generations.csv.all.pops | while read i
  do pop=$(echo "$i" | cut -d "," -f 1)
  python 01_scripts/06_merged_data.py 02_data/ 03_data_merged/ "$pop"
 done
 
```
## Plot the results

R 07_introgression_rate_plot.R
