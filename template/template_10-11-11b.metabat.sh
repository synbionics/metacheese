#!/bin/bash
# filepath: c:\Users\davip\Desktop\script bioinformatica\10-11.metabat_pipeline.sh

module load apptainer
module load metabat

test -n "$METABAT_CONTAINER" || { echo "METABAT_CONTAINER non definito"; exit 1; }

# Directory
bam_dir="@10-11_var1@"
depth_dir="10-11_var2@"
contig_dir="10-11_var3@"
mag_dir_11="10-11_var4@"
mag_dir_11b="10-11_var5@"
mkdir -p "$depth_dir" "$mag_dir_11" "$mag_dir_11b"

# 1. Calcolo delle depth (step 10)
for bam in "$bam_dir"/*.sorted.bam; do
    base=$(basename "$bam" .sorted.bam)
    apptainer exec "$METABAT_CONTAINER" jgi_summarize_bam_contig_depths \
        --outputDepth "$depth_dir/${base}.depth.txt" "$bam"
done

# 2. Chiedi all'utente quale binning eseguire
echo "Scegli quale binning eseguire:"
echo "1) MetaBAT2 classico (output in $mag_dir_11)"
echo "2) MetaBAT2 alternativo (output in $mag_dir_11b)"
read -p "Inserisci 1 o 2: " scelta

if [[ "$scelta" == "1" ]]; then
    out_dir="$mag_dir_11"
    extra_opts=""
elif [[ "$scelta" == "2" ]]; then
    out_dir="$mag_dir_11b"
    # Qui puoi aggiungere opzioni alternative per 11b, ad esempio:
    extra_opts="--minContig 2000 --maxEdges 200"
else
    echo "Scelta non valida."
    exit 1
fi

# 3. Binning (step 11 o 11b)
for contig in "$contig_dir"/*.fasta_sort.fasta; do
    sample=$(basename "$contig" ..fasta_sort.fasta)
    depth="$depth_dir/${sample}.depth.txt"
    apptainer exec "$METABAT_CONTAINER" metabat2 \
        -i "$contig" -a "$depth" -o "$out_dir/${sample}" -m @10-11_par1@ -t @10-11_par2@ $extra_opts
done