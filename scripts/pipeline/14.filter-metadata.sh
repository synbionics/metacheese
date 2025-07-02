#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Parametri comuni (tutti sostituibili via template)
TSV_FILE="../../data/processed/12_checkm/output_checkm.txt"
SOURCE_DIR="../../data/processed/11_metabat_MAG"
TARGET_DIR="../../data/processed/14_MAGs_high_quality"
ALL_MAGS_DIR="../../data/processed/09_metabat_MAG"
COMPLETENESS="50"      # soglia completezza (es: 50)
CONTAMINATION="10"     # soglia contaminazione (es: 10)
METADATA_FILTERED="filtered_metadata.tsv" # nome file metadati filtrati (es: my-metadata2.txt)
METADATA_ALL="all_metadata.tsv"      # nome file metadati tutti i MAGs (es: my-metadata_thermophilus.txt)

echo "Scegli il processo:"
echo "1) Filtra MAGs per qualità e genera metadati solo per quelli filtrati"
echo "2) Genera metadati per tutti i MAGs in una directory (senza filtro)"
read -p "Scelta (1/2): " scelta

if [[ "$scelta" == "1" ]]; then
    # Processo 1: filtro e metadati solo per MAG filtrati
    FILTERED_TSV="filtered_data.tsv"
    mkdir -p "$TARGET_DIR"
    awk -F'\t' "NR==1 || (\$2 > $COMPLETENESS && \$3 < $CONTAMINATION)" "$TSV_FILE" > "$FILTERED_TSV"
    awk -F'\t' 'NR > 1 {print $1".fa"}' "$FILTERED_TSV" | while IFS= read -r filename; do
      if [ -e "$SOURCE_DIR/$filename" ]; then
        mv "$SOURCE_DIR/$filename" "$TARGET_DIR/"
        echo "File $filename spostato in $TARGET_DIR"
      else
        echo "File $filename non trovato in $SOURCE_DIR"
      fi
    done
    ls $TARGET_DIR/*.fa | sed "s/.*\///" | sed "s/.fa//" > uno.tmp
    while read -r filename; do
      echo "GENOME" >> dos.tmp
      realpath $TARGET_DIR/${filename}.fa >> tres.tmp
      echo "This is the genome for ${filename}" >> cuatro.tmp
    done < uno.tmp
    paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > $TARGET_DIR/$METADATA_FILTERED
    rm uno.tmp dos.tmp tres.tmp cuatro.tmp

elif [[ "$scelta" == "2" ]]; then
    # Processo 2: metadati per tutti i MAGs in una directory
    ls $ALL_MAGS_DIR/*.fa | sed "s/.*\///" | sed "s/.fa//" > uno.tmp
    while read -r filename; do
      echo "GENOME" >> dos.tmp
      realpath $ALL_MAGS_DIR/${filename}.fa >> tres.tmp
      echo "This is the genome for ${filename}" >> cuatro.tmp
    done < uno.tmp
    paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > $ALL_MAGS_DIR/$METADATA_ALL
    rm uno.tmp dos.tmp tres.tmp cuatro.tmp

else
    echo "Scelta non valida."
    exit 1
fi

# --- Disattiva Conda ---
conda deactivate