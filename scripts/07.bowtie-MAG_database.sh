#!/bin/bash

module load bowtie2/2.3.3.1
output_folder="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index"
input_folder="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered"

# Ciclo attraverso tutti i file .fasta
for file in "$input_folder"/*.fasta; do
    # Estrai il nome del file senza l'estensione
    base_name=$(basename -- "$file")
    file_name="${base_name%.fasta}"

    # Esegui bowtie2-build per ogni file
    bowtie2-build "$file" "$output_folder/${file_name}_index_base" -p 32 #Per ogni file .fasta viene fatto bowtie
    #bowtie crea un indice di genoma che servirà successivamete per l'allineamento delle letture
done