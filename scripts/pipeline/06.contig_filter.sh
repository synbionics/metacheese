#!/usr/bin/env bash
set -euo pipefail

# --- Attiva Conda ---
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# --- Parametri dal config.yml ---
workdir="data/processed/05_spades_output"        # cartella dove ci sono i risultati SPAdes
contigs_dir="data/processed/06_spades_output/contigs"    # cartella dove copiare i singoli contigs
filtered_dir="data/processed/06_spades_output/contigs/filtered"   # output finale dei contigs filtrati
minlen=500                 # (hardcoded qui, ma si può parametrizzare)
threads="32"     # numero di thread per xargs parallel

# --- Entra nella cartella di lavoro ---
cd "$workdir"

# --- 1. Copia tutti i contigs in una cartella unica con nome campione ---
mkdir -p "$contigs_dir"

for file in $(find . -type f -name "contigs.fasta"); do
    parent_dir=$(dirname "$file")
    sample_name=$(basename "$parent_dir")
    cp "$file" "$contigs_dir/${sample_name}.fasta"
done

# --- 2. Filtra i contigs per lunghezza (> ${minlen}) usando awk + xargs ---
mkdir -p "$filtered_dir"

find "$contigs_dir" -type f -name "*.fasta" -print0 | \
xargs -0 -P "$threads" -I {} bash -c '
  infile="{}"
  outfile="'$filtered_dir'/$(basename "${infile%.fasta}")_filtered.fasta"
  awk "BEGIN {RS=\">\"; ORS=\"\"} length(\$0) > '$minlen' {print \">\"\$0}" "$infile" > "$outfile"
'

echo " Filtrati i contigs in: $filtered_dir"

# --- Disattiva Conda ---
conda deactivate
