#!/bin/bash
set -euo pipefail

# Attiva conda solo se serve (opzionale, dipende da come è configurato il container)
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv


# Binding for the Humann container
bind="$(dirname "$HUMANN_CONTAINER")/humann.cfg:/opt/micromamba/envs/humann/lib/python3.12/site-packages/humann/humann.cfg"

#Run Humann3 to merge single-sample output files into a single table with multiple samples
apptainer exec ${bind:+--bind $bind} "$HUMANN_CONTAINER" humann_join_tables \
	--input humann_genefamilies \
	--output humann_joined_genefamilies.tsv

# normalize our merged file to adjust for differences in sequencing depth across the samples
apptainer exec ${bind:+--bind $bind} "$HUMANN_CONTAINER" humann_renorm_table \
	--input humann_joined_genefamilies.tsv \
	--output humann_joined_genefamilies_cpm.tsv \
	--units cpm

# regroup gene families into other functional categories
apptainer exec ${bind:+--bind $bind} "$HUMANN_CONTAINER" humann_regroup_table \
    --input humann_joined_genefamilies_cpm.tsv \
    --groups uniref90_ko \
    --output merged_table_genefamilies_ko.txt

# rename table features
apptainer exec ${bind:+--bind $bind} "$HUMANN_CONTAINER" humann_rename_table \
    --input merged_table_genefamilies_ko.txt \
    --names uniref90 \
    --output merged_table_ko.txt

# rename table features
apptainer exec ${bind:+--bind $bind} "$HUMANN_CONTAINER" humann_rename_table \
    --input merged_table_genefamilies_ko.txt \
    --names kegg-pathway \
    --output merged_table_kegg_pathway.txt

