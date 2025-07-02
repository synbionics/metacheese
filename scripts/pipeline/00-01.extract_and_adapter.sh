#!/bin/bash

# Inizializza Conda e attiva ambiente bioenv
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Step 1: Estrazione dei file .fq.gz dagli archivi .tar
cd ../../data/input/rawdata  # Directory con i file .tar
output_dir00="../../processed/01_AdapterRemoval"  # Dove salvare i .fq.gz
output_dir01="../../processed/01_AdapterRemoval"  # Dove mettere gli output di AdapterRemoval

mkdir -p "$output_dir00" "$output_dir01"

echo "Estrazione dei file .fq.gz dagli archivi .tar..."
for tar_file in X204SC24020161-Z01-F003_01.tar \
                X204SC24020161-Z01-F003_02.tar; do
    tar -tf "$tar_file" | grep -E '^D?_?PR_[0-9]+|^ND_[0-9]+.*\.fq\.gz$' | while read -r filepath; do
        filename=$(basename "$filepath")
        tar -xf "$tar_file" -C "$output_dir00" --strip-components=$(echo "$filepath" | tr -cd '/' | wc -c) "$filepath"
        mv "$output_dir00/$filepath" "$output_dir00/$filename"
    done
done

echo "Estrazione completata."

# Step 2: Rimozione degli adattatori
echo "Avvio della rimozione degli adattatori con AdapterRemoval..."
for file_L1 in "$output_dir00"/*_1.fq.gz; do
    file_base=${file_L1%_1.fq.gz}
    file_L2="${file_base}_2.fq.gz"
    sample_name=$(basename "$file_base")

    AdapterRemoval \
        --file1 "$file_L1" --file2 "$file_L2" \
        --output1 "$output_dir01/${sample_name}_cleaned_L1.fq.gz" \
        --output2 "$output_dir01/${sample_name}_cleaned_L2.fq.gz" \
        --threads 80 \
        --gzip \
        --minlength 50 \
        --trimqualities \
        --minquality 30 \
        --trimns \
        --maxns 10 \
        --trim5p 2 \
        --trim3p 2
done

echo "Rimozione degli adattatori completata."
