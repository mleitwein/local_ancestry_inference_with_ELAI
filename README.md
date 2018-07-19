# local_ancestry_inference_with_ELAI

Pipeline for infering local ancestry without phased data by using ELAI 

## WARNING

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

Also see ELAI documentation http://www.haplotype.org/download/elai-manual.pdf



## DEPENDANCIES

ELAI: http://www.haplotype.org/elai.html
Vcftools: https://vcftools.github.io/man_latest.html

## Workflow

#### STEP1: Creation of ELAI input format from vcf files

ELAI need input files for the source(s) population(s) (1 or 2) and the admixted populations. 
ELAI need to be run sepatatly for each linkage groups.

1- You neeed to create White lists containing you source populations and admixted populatons (example: WL_pop_wild and WL_pop_dom)
2- You need to create White lists for each linkage groups (example: 02_info/WL_LG/WL_X) 

For example, if you have a source population of domestique strain and a wild populations containing both pure and admixted individuals : 
##### Creation of plink files 
This is a code example for creating plink files for you populations and need to be adjusted in function of your sampling desing. 

```
cat 02_info/populations_and_numbers_of_generations.csv.all.pops | while read j
do
	pop=$(echo "$j" | cut -d "," -f 1)
	mkdir 04_plinkfiles/$pop
						for i in 02_info/WL_LG/*
						do
						WL=$(echo $i| awk -F"/" '{print $3}' | awk -F"_" '{print $2}')
						echo $WL
						vcftools --vcf $j.vcf --keep WL_pop_wild --positions $i --plink --out ${pop}/${pop}.${WL}.wild #for the admixted individuals
            vcftools --vcf $j.vcf --keep WL_pop_dom --positions $i --plink --out ${pop}/${pop}.${WL}.dom #for the domestic individuals
						done 
						done
  ```
  
  
