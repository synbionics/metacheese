#!/usr/bin/env bash
set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

sample_directory="@03_var1@"
output_dir="@03_var2@"
mkdir -p "$output_dir"
meta_database="@03_var3@"

echo "[$(date)] Mapping in: $sample_directory  →  $output_dir  on DB: $meta_database"

for file_L1 in "$sample_directory"/*cleaned_L1.fq.gz; do
  [ -e "$file_L1" ] || { echo "No *_cleaned_L1.fq.gz file found in $sample_directory"; exit 1; }

  file_L2="${file_L1/_L1/_L2}"
  sample_name=$(basename "${file_L1%_cleaned_L1.fq.gz}")

  echo "[$(date)] Starting mapping for $sample_name"

  if ! bowtie2 \
    -x "$meta_database" \
    -1 "$file_L1" -2 "$file_L2" \
    --un-conc-gz "$output_dir/${sample_name}.unmapped.fq.gz" \
    -p 32 \
    -S "$output_dir/${sample_name}.sam"; then
      echo "Error: bowtie2 failed for $sample_name" >&2
      exit 1
  fi

  rm -f "$output_dir/${sample_name}.sam"
done

echo "[$(date)] Mapping completed successfully."

conda deactivate
