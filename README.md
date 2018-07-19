# local_ancestry_inference_with_ELAI

Pipeline for infering local ancestry without phased data by using ELAI 

## WARNING

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

Also see ELAI documentation http://www.haplotype.org/download/elai-manual.pdf



## DEPENDANCIES

ELAI: http://www.haplotype.org/elai.html
Vcftools: https://vcftools.github.io/man_latest.html

## Workflow

### STEP1: Creation of ELAI input format from vcf files

ELAI need input files for the source(s) population(s) (1 or 2) and the admixted populations. 
ELAI need to be run sepatatly for each linkage groups.

1- You neeed to create White lists containing you source populations and admixted populatons (example: WL_pop_wild and WL_pop_dom)
2- You need to create White lists for each linkage groups (example: 02_info/WL_LG/WL_X) 

For example, if you have a source population of domestique strain and a wild populations containing both pure and admixted individuals : 
##### Creation of plink files 
This an example of a code for creating plink files for your populations and this need to be adjusted in function of your sampling desing. 

```
cat 02_info/populations_and_numbers_of_generations.csv.all.pops | while read j
    do
    pop=$(echo "$j" | cut -d "," -f 1)
    mkdir 04_plinkfiles/$pop
    for i in 02_info/WL_LG/*
	do
	WL=$(echo $i| awk -F"/" '{print $3}' | awk -F"_" '{print $2}')
	echo $WL
	vcftools --vcf 03_vcf/$j.vcf --keep 02_info/WL_pop_wild --positions $i --plink --out 04_plinkfiles/${pop}/${pop}.${WL}.wild #for the admixted individuals
        vcftools --vcf 03_vcf/$j.vcf --keep 02_info/WL_pop_dom --positions $i --plink --out 04_plinkfiles/${pop}/${pop}.${WL}.dom #for the domestic individuals
     done 
done
  ```
  
 
##### Creation of genotype files with BIMBAM
This an example of a code for creating plink files for your populations and this need to be adjusted in function of your sampling desing. 
```
cat 02_info/populations_and_numbers_of_generations.csv.all.pops | while read j
    do
    pop=$(echo "$j" | cut -d "," -f 1)
    mkdir 05_BimBam/$pop
    for i in {1..42} #number of linkage groups
	do
	plink --ped 04_plinkfile/${pop}/${pop}.sf${i}.wild.ped --map 04_plinkfile/${pop}/${pop}.sf${i}.wild.map --recode bimbam  --out 05_BimBam_sfon/${pop}/${pop}.sf${i}.wild --chr-set 42
	plink --ped 04_plinkfile/${pop}/${pop}.sf${i}.dom.ped --map 04_plinkfile/${pop}/${pop}.sf${i}.dom.map --recode bimbam  --out 05_BimBam_sfon/${pop}/${pop}.sf${i}.dom --chr-set 42
	done
done	

```


### STEP2: Run ELAI for all your populations
  
  A file containing the populations names and the number of estimated generation since admixture is needed
  Example for 20 replicates 
  
  ```
  ./01_scripts/01_run_elai_all_populations.sh 20
  
  ```
  
  ### STEP3: Compute the Median and sd of each ELAI replicates for all your populations

```

01_scripts/02_Mediane_Replicates.R

01_scripts/03_standard_error.R

```





