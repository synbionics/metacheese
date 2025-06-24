#!/bin/bash

# sbatch in /hpc/group/G_MICRO/CoagMicroGP_shotgun/04_spades_output
cd @06_var1@
mkdir -p @06_var2@
for file in $(find . -type f -name "contigs.fasta"); do
    parent_dir=$(dirname "$file")
    parent_dir_name=$(basename "$parent_dir")
    cp "$file" "contigs/$parent_dir_name.fasta"
done

cd @06_var2@

mkdir -p @06_var3@

find . -type f -name "*..fasta" -print0 | xargs -0 -P @06_filter1@ -I {} bash -c 'x="{}"; output_dir="filtered/$(dirname "$x")"; mkdir -p "$output_dir"; awk "BEGIN{RS=\">\";ORS=\"\"} length(\$0)>500 {print \">\"\$0}" "$x" > "$output_dir/${x##*/}_sort.fasta"'

#Ordina e filtra i file contigs generati da spades in base alla lunghezza delle sequenze
#Il comando "find" filtra i contigs