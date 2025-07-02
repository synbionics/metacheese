#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Directory del database Metaphlan
DEFAULT_DB_FOLDER="../../data/input/metaphlan_database"
# Directory dei campioni .fq.gz
sample_folder="../../data/processed/03_bowtie2_output"
# Directory di output per i risultati
output_folder="../../data/processed/04_metaphlan_output"
mkdir -p "$output_folder"

# Validazione database
#if [ ! -d "$DEFAULT_DB_FOLDER" ]; then
#    echo " Errore: cartella DB non trovata → $DEFAULT_DB_FOLDER" >&2
#    exit 1
#fi
#
## Usa SLURM_ARRAY_TASK_ID se presente, altrimenti cicla su tutti i file
#if [ -n "${SLURM_ARRAY_TASK_ID:-}" ]; then
#    # Caso SLURM: singolo campione
#    file=$(ls "$sample_folder"/*1.fq.gz | sed -n "$((SLURM_ARRAY_TASK_ID + 1))p")
#    nome_campione=$(basename "$file" .1.fq.gz)
#
#    echo "Analizzo campione $nome_campione (da SLURM array index $SLURM_ARRAY_TASK_ID)"
#    
#    metaphlan \
#        "$sample_folder/${nome_campione}.1.fq.gz","$sample_folder/${nome_campione}.2.fq.gz" \
#        --input_type fastq \
#        --bowtie2db "$DEFAULT_DB_FOLDER" \
#        --nproc 16 \
#        --bowtie2out "$output_folder/${nome_campione}.bowtie2.bz2" \
#        -s "$output_folder/${nome_campione}.sam.bz2" \
#        -o "$output_folder/${nome_campione}.txt"
#else
#    # Caso senza SLURM: tutti i campioni
#    for file in "$sample_folder"/*1.fq.gz; do
#        nome_campione=$(basename "$file" .1.fq.gz)
#
#    echo "Analizzo campione $nome_campione (modalità seriale)"
#    
#    metaphlan \
#        "$sample_folder/${nome_campione}.1.fq.gz","$sample_folder/${nome_campione}.2.fq.gz" \
#        --input_type fastq \
#        --bowtie2db "$DEFAULT_DB_FOLDER" \
#        --nproc 16 \
#        --bowtie2out "$output_folder/${nome_campione}.bowtie2.bz2" \
#        -s "$output_folder/${nome_campione}.sam.bz2" \
#        -o "$output_folder/${nome_campione}.txt"
#
#done
#
#fi


# --- Merge dei profili tassonomici ---
#echo " Merge dei profili tassonomici in corso..."
#merge_metaphlan_tables.py "$output_folder"/*.txt > "$output_folder/merged_abundance_table.txt"

# --- Analisi di diversità alpha ---
for metric in richness shannon simpson gini; do
    echo " Calcolo alpha diversity ($metric)..."
    Rscript ../../data/input/calculate_diversity.R \
        -f "$output_folder/merged_abundance_table.txt" \
        -d alpha \
        -m "$metric" \
        -s s__
done

# --- Analisi di diversità beta ---
for metric in bray-curtis jaccard weighted-unifrac unweighted-unifrac clr aitchison; do
    echo " Calcolo beta diversity ($metric)..."
    Rscript ../../data/input/calculate_diversity.R \
        -f "$output_folder/merged_abundance_table.txt" \
        -d beta \
        -m "$metric" \
        -s s__
done

# Disattiva l’ambiente Conda
conda deactivate

