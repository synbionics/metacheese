#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

output_folder="../../data/processed/07_Bowtie_Index"
input_folder="../../data/processed/06_spades_output/filtered"

mkdir -p "$output_folder"

# Ciclo attraverso tutti i file .fasta
for file in "$input_folder"/*.fasta; do
    # Estrai il nome del file senza l'estensione
    base_name=$(basename -- "$file")
    file_name="${base_name%.fasta}"


    #Domanda: perchè di nuovo bowtie2-build?
    # Esegui bowtie2-build per ogni file
    bowtie2-build "$file" "$output_folder/${file_name}_index_base" -p 32 #Per ogni file .fasta viene fatto bowtie
    #bowtie crea un indice di genoma che servirà successivamete per l'allineamento delle letture
done

conda deactivate