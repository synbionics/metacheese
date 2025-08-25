#!/bin/bash
set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh

INPUT_DIR="@12-13_var1@"
CHECKM_OUT="@12-13_var2@"
CHECKM2_OUT="@12-13_var3@"
mkdir -p "$CHECKM_OUT" "$CHECKM2_OUT"

if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: input folder $INPUT_DIR not found" >&2
    exit 1
fi

choice="${1:-}"

while [[ "$choice" != "1" && "$choice" != "2" && "$choice" != "3" ]]; do
    echo "What do you want to run?"
    echo "1) CheckM"
    echo "2) CheckM2"
    echo "3) Both"
    #read -p "Choose (1/2/3): " choice
    choice="2"
done

if [[ "$choice" == "1" || "$choice" == "3" ]]; then
    conda activate checkmenv
    echo "Running CheckM..."
    checkm lineage_wf \
        -t @12-13_par1@ -x fa "$INPUT_DIR" "$CHECKM_OUT" \
        --pplacer_threads @12-13_par2@ \
        -f "$CHECKM_OUT/output_checkm.txt" || { echo "Error in CheckM"; exit 1; }
    conda deactivate
fi

if [[ "$choice" == "2" || "$choice" == "3" ]]; then
    conda activate checkm2env
    echo "Running CheckM2..."
    checkm2 predict --threads @12-13_par3@ \
        --input "$INPUT_DIR" \
        --output-directory "$CHECKM2_OUT" \
        -x .fa || { echo "Error in CheckM2"; exit 1; }
    conda deactivate
fi

echo "CheckM analysis completed successfully."
