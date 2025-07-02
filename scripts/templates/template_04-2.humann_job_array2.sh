#!/bin/bash
set -euo pipefail

# Attiva conda solo se serve (opzionale, dipende da come è configurato il container)
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Define input/output directories (modifica come ti serve)
taxon_dir="@04_1_var1@"
input_dir="@04_1_var2@"
output_dir="@04_1_var3@"

mkdir -p "$output_dir"

# Lista tutti i file forward e ordina
samples=($(ls -1 ${input_dir}/*.1.fq.gz | sort))

# Prendi il sample usando SLURM_ARRAY_TASK_ID
sample=${samples[$((SLURM_ARRAY_TASK_ID-1))]}
nome_campione=$(basename "$sample" .1.fq.gz)

input_file="${input_dir}/${nome_campione}.1.fq.gz"
taxonomic_profile="${taxon_dir}/${nome_campione}.txt"

# Verifica che i file esistano
if [[ -f "$input_file" && -f "$taxonomic_profile" ]]; then
    echo "Processing sample: $nome_campione"

    # Lancia docker con i bind mount necessari (modifica "humann_image" con il nome corretto)
    docker run --rm \
        -v "$input_dir":/input:ro \
        -v "$taxon_dir":/taxon:ro \
        -v "$output_dir":/output \
        humann_image humann \
            --input "/input/${nome_campione}.1.fq.gz" \
            --output /output \
            --threads 4 \
            --remove-temp-output \
            --taxonomic-profile "/taxon/${nome_campione}.txt"
else
    echo "WARNING: Input or taxonomic profile missing for sample: $nome_campione. Skipping..." >&2
fi

echo "HUMAnN processing complete for sample: $nome_campione"
