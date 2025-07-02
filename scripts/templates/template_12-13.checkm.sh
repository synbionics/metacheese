#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate checkmenv

# Controllo container
test -n "$CHECKM_CONTAINER" || { echo "CHECKM_CONTAINER non definito"; exit 1; }
test -n "$CHECKM2_CONTAINER" || { echo "CHECKM2_CONTAINER non definito"; exit 1; }

# Directory
INPUT_DIR="@12-13_var1@"
CHECKM_OUT="@12-13_var2@"
CHECKM2_OUT="@12-13_var3@"

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
    apptainer exec "$CHECKM_CONTAINER" checkm lineage_wf -t @12-13_par1@ -x fa "$INPUT_DIR" "$CHECKM_OUT" --pplacer_threads @12-13_par2@ -f "$CHECKM_OUT/output_checkm.txt" 2>&1
fi

# Esegui CheckM2
if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    echo "Eseguo CheckM2..."
    apptainer exec "$CHECKM2_CONTAINER" checkm2 predict --threads @12-13_par3@ \
        --input "$INPUT_DIR" \
        --output-directory "$CHECKM2_OUT" \
        -x .fa
fi

# --- Disattiva Conda ---
conda deactivate