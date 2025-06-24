#!/bin/bash

# Inizializza Conda
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"

check_cmd() {
    echo -n "Controllando $1... "
    if command -v "$1" &> /dev/null; then
        echo "trovato"
    else
        echo "non trovato"
    fi
}

echo "Controllo strumenti in bioenv:"
conda activate bioenv

check_cmd AdapterRemoval
check_cmd metaphlan
check_cmd checkm
check_cmd samtools
check_cmd spades.py
check_cmd metabat2

echo ""
echo "Controllo strumenti in bowtieenv:"
conda activate bowtieenv

check_cmd bowtie2
