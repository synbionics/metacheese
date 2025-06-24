#!/bin/bash

# Inizializza Conda
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"

# Disattiva ambiente corrente
conda deactivate &> /dev/null

echo ""
echo "-----------------------------"
echo "     BioEnv Tool Activator   "
echo "-----------------------------"
echo ""
echo "Scegli ambiente da attivare:"
echo "  1) bioenv    (tool generali)"
echo "  2) bowtieenv (solo Bowtie2)"
echo ""
read -p "→ Inserisci 1 o 2: " scelta

case "$scelta" in
  1)
    echo "Attivazione bioenv"
    conda activate bioenv
    ;;
  2)
    echo "Attivazione bowtieenv"
    conda activate bowtieenv
    ;;
  *)
    echo "Scelta non valida. Nessun ambiente attivato."
    ;;
esac
