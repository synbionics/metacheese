#!/bin/bash

# Attiva conda solo se serve
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Rende la shell tollerante ai glob vuoti
shopt -s nullglob

# Directory di input/output (relative al file)
campioni_folder="../../data/processed/03_Bowtie2_output"
output_folder="../../data/processed/05_spades_output"

# Crea cartella di output se non esiste
mkdir -p "$output_folder"

# Ciclo su tutti i file .fq.1.gz presenti
for fq1 in "$campioni_folder"/*.fq.1.gz; do
    nome_campione=$(basename "$fq1" .fq.1.gz)
    fq2="$campioni_folder/${nome_campione}.fq.2.gz"

    if [[ -f "$fq2" ]]; then
        echo "Processo campione: $nome_campione"
        
        # Esegui SPAdes
        spades.py -1 "$fq1" -2 "$fq2" \
            --only-assembler \
            --isolate -t 1 --memory 2 \  
            -o "$output_folder/$nome_campione"
    else
        echo "ATTENZIONE: File $fq2 mancante per $nome_campione"
    fi
done

conda deactivate
