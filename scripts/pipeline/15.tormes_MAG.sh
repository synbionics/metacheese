#!/bin/bash --login

set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

WORKDIR="/hpc/group/DOPnonDOP_noema/"
cd "$WORKDIR"

INPUT="data/processed/14_MAGs_high_quality/filtered_metadata.tsv"

apptainer exec "$TORMES_CONTAINER" tormes \
  --metadata "$INPUT" \
  --output data/processed/15_tormes_MAGs \
  --threads 16

apptainer exec "$TORMES_CONTAINER" tormes --metadata $INPUT --output data/processed/15_tormes_MAGs --threads 16