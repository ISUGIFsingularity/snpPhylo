#!/bin/bash

#input for this script is the VCF file
basename=$(basename ${1} | sed 's/.vcf$//g')

#Here is how to add the ids prior to running phylosnp, it creates the idea from the scaffold + position and retains the header.
awk 'BEGIN{OFS="\t"} (/#/) {print} ($3==".") {$3=$1"_"$2;print}' $1 > ${basename}_withIDs.vcf

#Looks like Snpphylo requires chromosomes that are only numbers so need to modify the above awk command.

sed -i  's/Scaffold_//g' ${basename}_withIDs.vcf

#Filter SNPs for hardy-weinberg and amount of missing data 

vcftools --vcf ${basename}_withIDs.vcf --max-non-ref-af 0.8 --non-ref-af 0.2  --hwe 0.001 --recode --recode-INFO-all --out ${basename}_withIDs_filtered.vcf

#run snpphylo

snphylo.sh -b -B 100 -v ${basename}_withIDs_filtered.vcf 
