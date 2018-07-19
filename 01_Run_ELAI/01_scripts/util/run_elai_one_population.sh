#!/bin/bash
# Boucle to Run elai pour toutes pop

# Global parameters
POP=$1
NUMGEN=$2
NUMREP=$3

# Loop over replicates
for replicate in $(seq -w "$NUMREP")
do
	# Loop over chromosomes
	for chromosome in $(seq 42)
	do
		echo "$POP" "$NUMGEN" "$replicate" "$chromosome"

	elai-mac -g 05_BimBam_sfon/"$POP"/"$POP".sf"$chromosome".dom.recode.geno.txt -p 10 \
			-g 05_BimBam_sfon/"$POP"/"$POP".sf"$chromosome".wild.recode.geno.txt -p 1 \
			-pos 05_BimBam_sfon/"$POP"/"$POP".sf"$chromosome".wild.recode.pos.txt \
			-o "$POP".sf"$chromosome".replicate"$replicate".numgen"$NUMGEN" \
			-R -s 20 -C 2 -c 10 --exclude-maf 0.01 -mg "$NUMGEN"
	done
done
