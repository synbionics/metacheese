#!/usr/bin/env bash
set -euo pipefail

# --- Attiva Conda e ambiente con Bowtie2 installato ---
source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

# Directory dove sono i .fq.gz puliti da AdapterRemoval
sample_directory="../../data/tmp/stept00_01/AdpRem"

# Directory di output per i risultati di mapping
output_dir="../../data/processed/02_Bowtie2_output"
mkdir -p "$output_dir"

# Prefisso del database Bowtie2 (senza estensione .bt2)
meta_database="../../data/input/gene/Bos_taurus/Bos_taurus"

echo "[$(date)] Mapping in: $sample_directory  →  $output_dir  su DB: $meta_database"

# Loop su tutte le coppie _L1/_L2 e lancio Bowtie2
for file_L1 in "$sample_directory"/*cleaned_L1.fq.gz; do
  [ -e "$file_L1" ] || continue

  # Deduce il file L2 e nome del campione
  file_L2="${file_L1/_L1/_L2}"
  sample_name=$(basename "${file_L1%_cleaned_L1.fq.gz}")

  # Mapping paired‐end
  bowtie2 \
    -x "$meta_database" \
    -1 "$file_L1" -2 "$file_L2" \
    --un-conc-gz "$output_dir/${sample_name}.unmapped.fq.gz" \
    -p 32 \
    -S "$output_dir/${sample_name}.sam"

  # Rimuove il SAM intermedio
  rm -f "$output_dir/${sample_name}.sam"
done

# Disattiva l’ambiente Conda
conda deactivate
