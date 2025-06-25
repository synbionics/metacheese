#!/bin/bash

# 1. Impostazione cartelle e variabili
DEFAULT_DB_FOLDER="@04_var1@"
sample_folder="@04_var2@"
output_folder="@04_var3@"

mkdir -p "$DEFAULT_DB_FOLDER"
if [ ! -d "$DEFAULT_DB_FOLDER" ]; then
    echo "'$DEFAULT_DB_FOLDER': No such file or directory" 1>&2
    exit 1
fi
mkdir -p "$output_folder"

if [ -n "$SLURM_ARRAY_TASK_ID" ]; then
    file=$(ls "$sample_folder"/*fq.1.gz | sed -n "$((SLURM_ARRAY_TASK_ID + 1))p")
    nome_campione=$(basename "$file" .fq.1.gz)

    metaphlan \
        "$sample_folder/${nome_campione}.fq.1.gz","$sample_folder/${nome_campione}.fq.2.gz" \
        --bowtie2db "$DEFAULT_DB_FOLDER" \
        --input_type fastq \
        --nproc 16 \
        --bowtie2out "$output_folder/${nome_campione}.bz2" \
        -o "$output_folder/${nome_campione}.txt" \
        -s "$output_folder/${nome_campione}.sam.bz2"
    exit 0
fi

# Merge dei profili tassonomici
merge_metaphlan_tables.py "$output_folder"/*.txt > "$output_folder/merged_abundance_table.txt"

# Calcolo diversità alpha
for metric in richness shannon simpson gini; do
    Rscript @04_Rscript@ \
        -f "$output_folder/merged_abundance_table.txt" \
        -d alpha \
        -m "$metric"
done

# Calcolo diversità beta
for metric in bray-curtis jaccard weighted-unifrac unweighted-unifrac clr aitchison; do
    Rscript @04_Rscript@ \
        -f "$output_folder/merged_abundance_table.txt" \
        -d beta \
        -m "$metric"
done