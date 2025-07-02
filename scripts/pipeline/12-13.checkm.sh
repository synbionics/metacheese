#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate checkmenv

# Directory
INPUT_DIR="../../data/processed/11_metabat_MAG"
CHECKM_OUT="../../data/processed/12_checkm"
CHECKM2_OUT="../../data/processed/13_checkm2"

mkdir -p "$CHECKM_OUT" "$CHECKM2_OUT"

# Scegli cosa eseguire: argomento o interattivo
choice="${1:-}"
if [[ -z "$choice" ]]; then
    echo "Cosa vuoi eseguire?"
    echo "1) CheckM"
    echo "2) CheckM2"
    echo "3) Entrambi"
    read -p "Scegli (1/2/3): " choice
fi

if [[ ! "$choice" =~ ^[1-3]$ ]]; then
  echo " Scelta non valida: $choice"
  exit 1
fi

# Esegui CheckM
if [[ "$choice" == "1" || "$choice" == "3" ]]; then
    echo "Eseguo CheckM..."
    #export OMP_NUM_THREADS=1
    #checkm lineage_wf -t 2 -x fa "$INPUT_DIR" "$CHECKM_OUT" --pplacer_threads 1 -f "$CHECKM_OUT/output_checkm.txt" 2>&1
    EXT="fa"  # oppure "fasta"
    checkm taxonomy_wf domain Bacteria \
        "$INPUT_DIR" "$CHECKM_OUT" -x "$EXT"



fi

# Esegui CheckM2
if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    echo "Eseguo CheckM2..."
    checkm2 predict --threads 32 \
        --input "$INPUT_DIR" \
        --output-directory "$CHECKM2_OUT" \
        -x .fa
fi

# --- Disattiva Conda ---
conda deactivate