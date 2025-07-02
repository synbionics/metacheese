#!/bin/bash
set -euo pipefail

echo " Controllo modelli salvati di CheckM2..."

# Attiva l'ambiente checkmenv
source /opt/conda/etc/profile.d/conda.sh
conda activate checkmenv

MODEL_DIR="$CONDA_PREFIX/lib/python3.8/site-packages/checkm2/models"

# Funzione che verifica presenza modelli
check_model() {
    local folder="$1"
    [[ -d "$MODEL_DIR/$folder" ]] && \
    [[ -f "$MODEL_DIR/$folder/saved_model.pb" || -f "$MODEL_DIR/$folder/saved_model.pbtxt" ]]
}

missing=false

if ! check_model "specific_model_COMP.keras"; then
    echo " Modello specifico mancante"
    missing=true
else
    echo " Modello specifico OK"
fi

if ! check_model "general_model.keras"; then
    echo " Modello generale mancante"
    missing=true
else
    echo " Modello generale OK"
fi

if [[ "$missing" == true ]]; then
    echo " Scaricamento modelli tramite CheckM2..."
    checkm2 database --download
    echo " Download completato"
else
    echo " Tutti i modelli sono già presenti"
fi

conda deactivate
