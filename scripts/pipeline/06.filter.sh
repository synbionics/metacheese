#!/bin/bash

# sbatch in /hpc/group/G_MICRO/CoagMicroGP_shotgun/04_spades_output
cd /hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/
mkdir -p /hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs

for file in $(find . -type f -name "contigs.fasta"); do
    parent_dir=$(dirname "$file")
    parent_dir_name=$(basename "$parent_dir")
    cp "$file" "contigs/$parent_dir_name.fasta"
done

cd /hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs

mkdir -p /hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered

find . -type f -name "*..fasta" -print0 | xargs -0 -P 32 -I {} bash -c 'x="{}"; output_dir="filtered/$(dirname "$x")"; mkdir -p "$output_dir"; awk "BEGIN{RS=\">\";ORS=\"\"} length(\$0)>500 {print \">\"\$0}" "$x" > "$output_dir/${x##*/}_sort.fasta"'