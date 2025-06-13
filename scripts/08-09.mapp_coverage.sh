#!/bin/bash

module load bowtie2/2.3.3.1
module load samtools/1.6

# Define input and output directories
FASTQ_DIR="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output"
INDEX_DIR="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index"
OUTPUT_DIR="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Get the list of files and select one based on SLURM_ARRAY_TASK_ID
file_list=($FASTQ_DIR/*.fq.1.gz)
target_file=${file_list[$((SLURM_ARRAY_TASK_ID - 1))]}

# Extract the base name
base_name=$(basename -- "$target_file")
file_name="${base_name%.fq.1.gz}"

# Correctly reference the existing index files
index_base="${INDEX_DIR}/${file_name}..fasta_sort_index_base"

# Define output files
bam_file="${OUTPUT_DIR}/${file_name}.bam"
sorted_bam="${OUTPUT_DIR}/${file_name}.sorted.bam"
bam_index="${OUTPUT_DIR}/${file_name}.sorted.bam.bai"
idxstats_file="${OUTPUT_DIR}/${file_name}.sorted.bam.idxstat"

# Run Bowtie2 and output SAM
bowtie2 -x "$index_base" \
        -1 "$FASTQ_DIR/${file_name}.fq.1.gz" \
        -2 "$FASTQ_DIR/${file_name}.fq.2.gz" \
        -q --no-unal --very-sensitive-local \
        -p 32 2> "${OUTPUT_DIR}/${file_name}_bowtie2.log" | \
    samtools view -bS -o "$bam_file" -

# Sort BAM
samtools sort "$bam_file" -o "$sorted_bam"

# Index BAM
samtools index "$sorted_bam"