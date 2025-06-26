#!/usr/bin/env bash
set -euo pipefail

# --- Attiva ambiente con Bowtie2 + samtools ---
source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

# --- Parametri ---
FASTQ_DIR="data/processed/03_bowtie2_output"
INDEX_DIR="data/processed/07_Bowtie_Index"
OUTPUT_DIR="data/processed/08_mapping_coverage"

mkdir -p "$OUTPUT_DIR"

# Lista dei file
file_list=($FASTQ_DIR/*.fq.1.gz)
target_file="${file_list[$((SLURM_ARRAY_TASK_ID - 1))]}"

# Campione corrente
base_name=$(basename -- "$target_file")
sample="${base_name%.fq.1.gz}"

# Indice Bowtie2 associato
index_base="${INDEX_DIR}/${sample}.fasta_sort_index_base"

# Output
bam_file="${OUTPUT_DIR}/${sample}.bam"
sorted_bam="${OUTPUT_DIR}/${sample}.sorted.bam"
bam_index="${OUTPUT_DIR}/${sample}.sorted.bam.bai"
idxstats_file="${OUTPUT_DIR}/${sample}.sorted.bam.idxstat"

echo " Mapping ${sample} → ${index_base}"

# Bowtie2 + conversione in BAM
bowtie2 -x "$index_base" \
        -1 "$FASTQ_DIR/${sample}.fq.1.gz" \
        -2 "$FASTQ_DIR/${sample}.fq.2.gz" \
        -q --no-unal --very-sensitive-local \
        -p 32 2> "${OUTPUT_DIR}/${sample}_bowtie2.log" | \
    samtools view -bS -o "$bam_file" -

# Ordinamento BAM
samtools sort "$bam_file" -o "$sorted_bam"
rm -f "$bam_file"

# Index e idxstats
samtools index "$sorted_bam"
samtools idxstats "$sorted_bam" > "$idxstats_file"

echo " Completato: $sample"

# --- Disattiva Conda ---
conda deactivate
