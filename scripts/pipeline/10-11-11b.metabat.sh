#!/bin/bash
# filepath: c:\Users\davip\Desktop\script bioinformatica\10-11.metabat_pipeline.sh

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Directory parametrizzate
bam_dir="../../data/processed/08-09_mapping_coverage"      
depth_dir="../../data/processed/10_metabat_depth"    
contig_dir="../../data/processed/06_spades_output/filtered"   
mag_dir_11="../../data/processed/11_metabat_MAG"   
mag_dir_11b="../../data/processed/11b_metabat_MAG"  

mkdir -p "$depth_dir" "$mag_dir_11" "$mag_dir_11b"

# STEP 10 – Calcolo della coverage
for bam in "$bam_dir"/*.sorted.bam; do
    sample=$(basename "$bam" .sorted.bam)
    echo " Calcolo depth per $sample"
    jgi_summarize_bam_contig_depths \
        --outputDepth "$depth_dir/${sample}.depth.txt" "$bam"
done

# STEP 11 – Scelta del tipo di binning
echo "Scegli quale binning eseguire:"
echo "1) MetaBAT2 classico (output in $mag_dir_11)"
echo "2) MetaBAT2 alternativo (output in $mag_dir_11b)"
read -p "Inserisci 1 o 2: " scelta

if [[ "$scelta" == "1" ]]; then
    out_dir="$mag_dir_11"
    extra_opts="-m 1500"  # es: 1500
elif [[ "$scelta" == "2" ]]; then
    out_dir="$mag_dir_11b"
    extra_opts="--minContig 2000 --maxEdges 200"
else
    echo " Scelta non valida."
    exit 1
fi

# STEP 11 – Binning con MetaBAT2
for contig in "$contig_dir"/*.fasta_sort.fasta; do
    sample=$(basename "$contig" .fasta_sort.fasta)
    depth="$depth_dir/${sample}.depth.txt"

    if [[ ! -f "$depth" ]]; then
        echo "Depth mancante per $sample → salto binning."
        continue
    fi

    echo " Binning $sample..."
    metabat2 \
        -i "$contig" \
        -a "$depth" \
        -o "$out_dir/${sample}" \
        -t 32 \
        $extra_opts
done
