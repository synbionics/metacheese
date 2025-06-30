#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

output_folder="@07_var1@"
input_folder="@07_var2@"

# Ciclo attraverso tutti i file .fasta
for file in "$input_folder"/*.fasta; do
    # Estrai il nome del file senza l'estensione
    base_name=$(basename -- "$file")
    file_name="${base_name%.fasta}"


    #Domanda: perchè di nuovo bowtie2-build?
    # Esegui bowtie2-build per ogni file
    bowtie2-build "$file" "$output_folder/${file_name}_index_base" -p @07_par1@ #Per ogni file .fasta viene fatto bowtie
    #bowtie crea un indice di genoma che servirà successivamete per l'allineamento delle letture
done

conda deactivate