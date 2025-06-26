#!/usr/bin/env bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Directory del database Metaphlan
DEFAULT_DB_FOLDER="@04_var1@"
# Directory dei campioni .fq.gz
sample_folder="@04_var2@"
# Directory di output per i risultati
output_folder="@04_var3@"
mkdir -p "$DEFAULT_DB_FOLDER" "$output_folder"

# Validazione database
if [ ! -d "$DEFAULT_DB_FOLDER" ]; then
    echo " Errore: cartella DB non trovata → $DEFAULT_DB_FOLDER" >&2
    exit 1
fi

# --- Analisi campione per campione (se usi array SLURM) ---
if [ -n "${SLURM_ARRAY_TASK_ID:-}" ]; then
    file=$(ls "$sample_folder"/*fq.1.gz | sed -n "$((SLURM_ARRAY_TASK_ID + 1))p")
    nome_campione=$(basename "$file" .fq.1.gz)

    metaphlan \
        "$sample_folder/${nome_campione}.fq.1.gz","$sample_folder/${nome_campione}.fq.2.gz" \
        --input_type fastq \
        --bowtie2db "$DEFAULT_DB_FOLDER" \
        --nproc 16 \
        --bowtie2out "$output_folder/${nome_campione}.bowtie2.bz2" \
        -s "$output_folder/${nome_campione}.sam.bz2" \
        -o "$output_folder/${nome_campione}.txt"

    exit 0
fi

# --- Merge dei profili tassonomici ---
echo " Merge dei profili tassonomici in corso..."
merge_metaphlan_tables.py "$output_folder"/*.txt > "$output_folder/merged_abundance_table.txt"

# --- Analisi di diversità alpha ---
for metric in richness shannon simpson gini; do
    echo " Calcolo alpha diversity ($metric)..."
    Rscript @04_Rscript@ \
        -f "$output_folder/merged_abundance_table.txt" \
        -d alpha \
        -m "$metric"
done

# --- Analisi di diversità beta ---
for metric in bray-curtis jaccard weighted-unifrac unweighted-unifrac clr aitchison; do
    echo " Calcolo beta diversity ($metric)..."
    Rscript @04_Rscript@ \
        -f "$output_folder/merged_abundance_table.txt" \
        -d beta \
        -m "$metric"
done

# Disattiva l’ambiente Conda
conda deactivate

