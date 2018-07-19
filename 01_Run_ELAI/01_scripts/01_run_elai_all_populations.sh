#!/bin/bash
# specify the number of replicates example for 20 replicats: ./01_run_elai_all_populations.sh 20 

# Global variables
NUMREP=$1

cat 02_info/populations_and_numbers_of_generations.csv.all.pops | while read i
do
	pop=$(echo "$i" | cut -d "," -f 1)
	numgen=$(echo "$i" | cut -d "," -f 2)
	./01_scripts/util/run_elai_one_population.sh "$pop" "$numgen" "$NUMREP" &
done
