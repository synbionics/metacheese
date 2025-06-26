#!/usr/bin/env bash
set -euo pipefail

# --- Attiva Conda per Bowtie2 ---
source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

# --- Parametri dinamici ---
output_folder="@07_var1@"
input_folder="@07_var2@"
threads="@07_par1@"

mkdir -p "$output_folder"

echo " Inizio indicizzazione Bowtie2 su tutti i .fasta in: $input_folder"

for file in "$input_folder"/*.fasta; do
    [ -e "$file" ] || continue
    base_name=$(basename "$file" .fasta)
    echo "  Indicizzo: $base_name"
    bowtie2-build "$file" "$output_folder/${base_name}_index_base" -p "$threads"
done

echo " Indicizzazione completata: $output_folder"

# --- Disattiva Conda ---
conda deactivate
