#!/bin/bash
set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate humannenv

NUC_DB="/main/db/humann/chocophlan/chocophlan"
PROT_DB="/main/db/humann/uniref/uniref"

# Check che i db ci siano
if [ ! -d "$NUC_DB" ] || [ -z "$(ls -A "$NUC_DB")" ]; then
    echo "ERRORE: DB ChocoPhlAn mancante" >&2; exit 1
fi
if [ ! -d "$PROT_DB" ] || [ -z "$(ls -A "$PROT_DB")" ]; then
    echo "ERRORE: DB UniRef90 mancante" >&2; exit 1
fi


# Percorsi input/output (lascia come i tuoi)
taxon_dir="@04b_1_var1@"
input_dir="@04b_1_var2@"
output_dir="@04b_1_var3@"

mkdir -p "$output_dir"

# Loop sui campioni
samples=($(ls -1 ${input_dir}/*fq.1.gz | sort))
for sample in "${samples[@]}"; do
    nome_campione=$(basename "$sample" .fq.1.gz)
    input_file="${input_dir}/${nome_campione}.fq.1.gz"
    taxonomic_profile="${taxon_dir}/${nome_campione}.txt"

    if [[ -f "$input_file" && -f "$taxonomic_profile" ]]; then
        echo "Processing sample: $nome_campione"
        humann \
          --input "$input_file" \
          --output "$output_dir" \
          --threads 4 \
          --remove-temp-output \
          --taxonomic-profile "$taxonomic_profile" \
          --nucleotide-database "$NUC_DB" \
          --protein-database "$PROT_DB"
    else
        echo "WARNING: Input or taxonomic profile missing for sample: $nome_campione. Skipping..." >&2
    fi

    echo "HUMAnN processing complete for sample: $nome_campione"
done
