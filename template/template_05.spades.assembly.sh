#!/bin/bash

# lo script è lanciato dalla cartella
mkdir -p @05_var1@
cd @05_var1@ 
#creata in precedenza

module load spades/3.13.0

campioni_folder="@05_var2@" #domanda
output_folder="@05_var1@"
# List all forward read files and sort them
samples=($(ls -1 ${campioni_folder}/*fq.1.gz | sort)) #array di campioni ordinati alfabeticmente

# Get the current sample based on the SLURM_ARRAY_TASK_ID
sample=${samples[$((SLURM_ARRAY_TASK_ID-1))]}
nome_campione=$(basename "$sample" fq.1.gz)

# Run SPAdes on the specific sample
spades.py -1 "${campioni_folder}/${nome_campione}fq.1.gz" \
          -2 "${campioni_folder}/${nome_campione}fq.2.gz" \
          --meta -t 16 --memory 350 \
          --only-assembler \
          -o "$output_folder/${nome_campione}"


#Sample è un array di campioni dal quale ne viene estratto uno e poi eseguito lo spades
