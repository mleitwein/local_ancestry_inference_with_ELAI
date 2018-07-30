# add header to results.res3 : Ind start stop LG pop HET/HOM

 { printf 'Ind start stop LG pop HET/HOM \n'; cat seuil_0.1_results.res3; } > results2.res3


# preparer le tableau et calculer la longueur des tracks d'introgression :

awk '
  {
  # If it is the first row
  if (NR==1)
  print $0, "length";
  else
  # Print all fields, then then substract 6 by 5
  print $0,($3-$2)
  }' results2.res3 > length_results.res3

awk -F " " '{print $4, $5, $6,$1, $2, $3, $7}' length_results.res3 > ../length_introgression_final_seuil0.05.txt

  
rm results2.res3




