#!/bin/bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Verifica presenza del container
test -n "$METABAT_CONTAINER" || { echo "METABAT_CONTAINER non definito"; exit 1; }

# Directory dai placeholder
bam_dir="data/processed/08_mapping_coverage"
depth_dir="data/processed/09_metabat_depth"
contig_dir="data/processed/06_spades_output/contigs/filtered"
mag_dir_11="data/processed/09_metabat_MAG"
mag_dir_11b="data/processed/09b_metabat_MAG"

mkdir -p "$depth_dir" "$mag_dir_11" "$mag_dir_11b"

# Step 10: Calcolo delle depth
for bam in "$bam_dir"/*.sorted.bam; do
    base=$(basename "$bam" .sorted.bam)
    apptainer exec "$METABAT_CONTAINER" jgi_summarize_bam_contig_depths \
        --outputDepth "$depth_dir/${base}.depth.txt" "$bam"
done

# Step 11: Chiedi quale modalità usare per il binning
echo "Scegli quale binning eseguire:"
echo "1) MetaBAT2 classico (output in $mag_dir_11)"
echo "2) MetaBAT2 alternativo (output in $mag_dir_11b)"
read -p "Inserisci 1 o 2: " scelta

if [[ "$scelta" == "1" ]]; then
    out_dir="$mag_dir_11"
    extra_opts=""
elif [[ "$scelta" == "2" ]]; then
    out_dir="$mag_dir_11b"
    extra_opts="--minContig 2000 --maxEdges 200"
else
    echo "Scelta non valida."
    exit 1
fi

# Step 11 o 11b: Binning con MetaBAT2
for contig in "$contig_dir"/*.fasta_sort.fasta; do
    sample=$(basename "$contig" ..fasta_sort.fasta)
    depth="$depth_dir/${sample}.depth.txt"
    apptainer exec "$METABAT_CONTAINER" metabat2 \
        -i "$contig" -a "$depth" -o "$out_dir/${sample}" \
        -m 1500 -t 32 $extra_opts
done

# --- Disattiva Conda ---
conda deactivate