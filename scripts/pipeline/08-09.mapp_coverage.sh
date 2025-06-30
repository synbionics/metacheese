#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

# Define input and output directories
FASTQ_DIR="../../data/processed/03_bowtie2_output"
INDEX_DIR="../../data/processed/07_Bowtie_Index"
OUTPUT_DIR="../../data/processed/08_mapping_coverage"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Itera su tutti i file .fq.1.gz presenti
for fq1 in "$FASTQ_DIR"/*.fq.1.gz; do
    base_name=$(basename "$fq1")
    file_name="${base_name%.fq.1.gz}"
    fq2="$FASTQ_DIR/${file_name}.fq.2.gz"

    # Verifica che esista il file mate
    if [[ ! -f "$fq2" ]]; then
        echo "File mancante: $fq2"
        continue
    fi

    echo "Processo campione: $file_name"

    # Path base dell'indice Bowtie
    index_base="${INDEX_DIR}/${file_name}..fasta_sort_index_base"

    # Output
    bam_file="${OUTPUT_DIR}/${file_name}.bam"
    sorted_bam="${OUTPUT_DIR}/${file_name}.sorted.bam"
    bam_index="${OUTPUT_DIR}/${file_name}.sorted.bam.bai"
    idxstats_file="${OUTPUT_DIR}/${file_name}.sorted.bam.idxstat"

    # Esegue Bowtie2
    bowtie2 -x "$index_base" \
        -1 "$fq1" -2 "$fq2" \
        -q --no-unal --very-sensitive-local \
        -p 4 2> "${OUTPUT_DIR}/${file_name}_bowtie2.log" | \
        samtools view -bS -o "$bam_file" -

    # Ordina BAM
    samtools sort "$bam_file" -o "$sorted_bam"

    # Indicizza BAM
    samtools index "$sorted_bam"

    # Statistiche
    samtools idxstats "$sorted_bam" > "$idxstats_file"
done

conda deactivate
