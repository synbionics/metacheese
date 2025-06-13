#!/bin/bash
# filepath: /bioinformatics-pipeline/bioinformatics-pipeline/scripts/12-13.checkm.sh

module load apptainer
module load checkm
module load checkm2

# Check for container definitions
test -n "$CHECKM_CONTAINER" || { echo "CHECKM_CONTAINER not defined"; exit 1; }
test -n "$CHECKM2_CONTAINER" || { echo "CHECKM2_CONTAINER not defined"; exit 1; }

# Directories
INPUT_DIR="/hpc/group/G_MICRO/DOPnonDOP_noema/09_metabat_MAG"
CHECKM_OUT="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm"
CHECKM2_OUT="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm2"

mkdir -p "$CHECKM_OUT" "$CHECKM2_OUT" "$TMPDIR"

# Choose what to execute: argument or interactive
choice="$1"
if [[ -z "$choice" ]]; then
    echo "What would you like to execute?"
    echo "1) CheckM"
    echo "2) CheckM2"
    echo "3) Both"
    read -p "Choose (1/2/3): " choice
fi

# Run CheckM
if [[ "$choice" == "1" || "$choice" == "3" ]]; then
    echo "Running CheckM..."
    apptainer exec "$CHECKM_CONTAINER" checkm lineage_wf -t 32 -x fa "$INPUT_DIR" "$CHECKM_OUT" --pplacer_threads 32 -f "$CHECKM_OUT/output_checkm.txt" 2>&1
fi

# Run CheckM2
if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    echo "Running CheckM2..."
    apptainer exec "$CHECKM2_CONTAINER" checkm2 predict --threads 30 \
        --input "$INPUT_DIR" \
        --output-directory "$CHECKM2_OUT" \
        -x .fa
fi