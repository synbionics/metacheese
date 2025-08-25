#!/bin/bash
set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

bam_dir="@10-11_var1@"
depth_dir="@10-11_var2@"
contig_dir="@10-11_var3@"
mag_dir_11="@10-11_var4@"
mag_dir_11b="@10-11_var5@"
mkdir -p "$depth_dir" "$mag_dir_11" "$mag_dir_11b"

# Step 10: Calculate depth
echo "Calculating depth from BAM in $depth_dir"
found_bam=false
for bam in "$bam_dir"/*.sorted.bam; do
    [[ -e "$bam" ]] || continue
    found_bam=true
    base=$(basename "$bam" .sorted.bam)
    jgi_summarize_bam_contig_depths --outputDepth "$depth_dir/${base}.depth.txt" "$bam"
done
if ! $found_bam; then
    echo "ERROR: No BAM files found in $bam_dir" >&2
    exit 1
fi

# Binning choice (non-interactive default possible)
echo "Choose which binning to perform:"
echo "1) Classic MetaBAT2"
echo "2) Alternative MetaBAT2"
#read -p "Enter 1 or 2 [default 1]: " scelta
#scelta="${scelta:-1}"

choice="1"

if [[ "$choice" == "1" ]]; then
    out_dir="$mag_dir_11"
    extra_opts=""
elif [[ "$choice" == "2" ]]; then
    out_dir="$mag_dir_11b"
    extra_opts="--minContig 2000 --maxEdges 200"
else
    echo "Invalid choice."
    exit 1
fi

# Step 11/11b: Binning
echo "Running binning on contigs in $contig_dir -> $out_dir"
found_contig=false
for contig in "$contig_dir"/*.fasta_sort.fasta; do
    [[ -e "$contig" ]] || continue
    found_contig=true
    sample=$(basename "$contig" .fasta_sort.fasta)
    depth="$depth_dir/${sample}.depth.txt"

    if [[ ! -f "$depth" ]]; then
        echo "WARNING: Depth file missing for $sample, skipping." >&2
        continue
    fi

    metabat2 -i "$contig" -a "$depth" -o "$out_dir/${sample}" -m @10-11_par1@ -t @10-11_par2@ $extra_opts
done

if ! $found_contig; then
    echo "ERROR: No contig files found in $contig_dir" >&2
    exit 1
fi

echo "Binning completed."
conda deactivate
