#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Controllo container
test -n "$CHECKM_CONTAINER" || { echo "CHECKM_CONTAINER non definito"; exit 1; }
test -n "$CHECKM2_CONTAINER" || { echo "CHECKM2_CONTAINER non definito"; exit 1; }

# Directory
INPUT_DIR="data/processed/09_metabat_MAG"
CHECKM_OUT="data/processed/12_checkm"
CHECKM2_OUT="data/processed/13_checkm2"

mkdir -p "$CHECKM_OUT" "$CHECKM2_OUT" "$TMPDIR"

# Scegli cosa eseguire: argomento o interattivo
choice="$1"
if [[ -z "$choice" ]]; then
    echo "Cosa vuoi eseguire?"
    echo "1) CheckM"
    echo "2) CheckM2"
    echo "3) Entrambi"
    read -p "Scegli (1/2/3): " choice
fi

# Esegui CheckM
if [[ "$choice" == "1" || "$choice" == "3" ]]; then
    echo "Eseguo CheckM..."
    apptainer exec "$CHECKM_CONTAINER" checkm lineage_wf -t 32 -x fa "$INPUT_DIR" "$CHECKM_OUT" --pplacer_threads 16 -f "$CHECKM_OUT/output_checkm.txt" 2>&1
fi

# Esegui CheckM2
if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    echo "Eseguo CheckM2..."
    apptainer exec "$CHECKM2_CONTAINER" checkm2 predict --threads 32 \
        --input "$INPUT_DIR" \
        --output-directory "$CHECKM2_OUT" \
        -x .fa
fi

# --- Disattiva Conda ---
conda deactivate