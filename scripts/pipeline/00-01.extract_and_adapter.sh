#!/bin/bash

module load apptainer
module load adapterremoval

# Step 1: Estrazione dei file .fq.gz dagli archivi .tar
cd /hpc/archive/G_MICRO/rawdata/ # Dove sono i file .tar
output_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/rawdata"
output_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output"

echo "Estrazione dei file .fq.gz dagli archivi .tar..."
for tar_file in /hpc/archive/G_MICRO/rawdata/X204SC24020161-Z01-F003_01.tar \
                /hpc/archive/G_MICRO/rawdata/X204SC24020161-Z01-F003_02.tar; do
    tar -tf "$tar_file" | grep -E '^D?_?PR_[0-9]+|^ND_[0-9]+.*\.fq\.gz$' | while read -r filepath; do
        filename=$(basename "$filepath")  # Estrae solo il nome del file
        tar -xf "$tar_file" -C "$output_dir1" --strip-components=$(echo "$filepath" | tr -cd '/' | wc -c) "$filepath"
        mv "$output_dir1/$filepath" "$output_dir1/$filename"
    done
done

echo "Estrazione completata."

# Step 2: Rimozione degli adattatori con AdapterRemoval

test -n "$ADAPTER_REMOVAL_CONTAINER" || exit 1

mkdir -p $output_dir
echo "Avvio della rimozione degli adattatori..."
for file_L1 in "$output_dir"/*_1.fq.gz; do
    file_base=${file_L1%_1.fq.gz}  # Rimuove il suffisso "_1.fq.gz"
    file_L2="${file_base}_2.fq.gz"  # Costruisce il nome del file R2
    sample_name=$(basename "$file_base")  # Nome del campione

    # Esegui AdapterRemoval
    apptainer exec "$ADAPTER_REMOVAL_CONTAINER" AdapterRemoval \
        --file1 "$file_L1" --file2 "$file_L2" \
        --output1 "$output_dir/${sample_name}_cleaned_L1.fq.gz" \
        --output2 "$output_dir/${sample_name}_cleaned_L2.fq.gz" \
        --threads 80 --gzip --minlength 50 --trimqualities --minquality 30 --trimns --maxns 10 --trim5p 2 --trim3p 2
done

echo "Rimozione degli adattatori completata."