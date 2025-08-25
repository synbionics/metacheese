#!/bin/bash
set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate humannenv

INPUT_DIR="@04b_last_dir1@"
OUTPUT_DIR="@04b_last_dir2@"

# Check that there are *_genefamilies.tsv files
GENEFILES=("$INPUT_DIR"/*_genefamilies.tsv)
if [[ ! -e "${GENEFILES[0]}" ]]; then
    echo "Error: No *_genefamilies.tsv file found in $INPUT_DIR" >&2
    exit 2
fi

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Merging the following files:"
ls "$INPUT_DIR"/*_genefamilies.tsv

# 1. Join tables (output in the same folder)
humann_join_tables \
    --input "$INPUT_DIR" \
    --file_name _genefamilies.tsv \
    --output "$OUTPUT_DIR/humann_joined_genefamilies.tsv"

# 2. Normalize
humann_renorm_table \
    --input "$OUTPUT_DIR/humann_joined_genefamilies.tsv" \
    --output "$OUTPUT_DIR/humann_joined_genefamilies_cpm.tsv" \
    --units cpm

# 3. Regroup: example for Metacyc reactions (default HUMAnN 3.9)
humann_regroup_table \
    --input "$OUTPUT_DIR/humann_joined_genefamilies_cpm.tsv" \
    --groups uniref90_rxn \
    --output "$OUTPUT_DIR/merged_table_genefamilies_rxn.txt"

# 4. Rename table: example for KO
humann_rename_table \
    --input "$OUTPUT_DIR/merged_table_genefamilies_rxn.txt" \
    --names kegg-orthology \
    --output "$OUTPUT_DIR/merged_table_ko.txt"

# 5. Rename table: example for KEGG Pathway
humann_rename_table \
    --input "$OUTPUT_DIR/merged_table_genefamilies_rxn.txt" \
    --names kegg-pathway \
    --output "$OUTPUT_DIR/merged_table_kegg_pathway.txt"

echo "HUMAnN merge and annotation completed."
conda deactivate
