#!/bin/bash --login

set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

WORKDIR="@15_var1@"
cd "$WORKDIR"

INPUT="@15_var2@"

apptainer exec "$TORMES_CONTAINER" tormes \
  --metadata "$INPUT" \
  --output @15_par1@ \
  --threads @15_par2@

apptainer exec "$TORMES_CONTAINER" tormes --metadata $INPUT --output @15_par1@ --threads @15_par2@