#!/bin/bash
# filepath: c:\Users\davip\Desktop\script bioinformatica\06.spades_filtering.sh

# Attiva Conda
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Parametri (verranno sostituiti dal generatore o configuratore)
input_folder="@06_var1@"               # Cartella dove si trovano i contigs da Spades
output_contig_folder="@06_var2@"       # Dove copiare i contigs rinominati
output_filtered_folder="@06_var3@"     # Dove salvare i contigs filtrati
threads="@06_filter1@"                 # Numero di thread da usare per la filtrazione

# 📁 Crea cartelle se non esistono
mkdir -p "$output_contig_folder"
mkdir -p "$output_filtered_folder"

# 🔁 Trova e copia tutti i contigs.fasta rinominandoli con il nome del campione
find "$input_folder" -type f -name "contigs.fasta" | while read -r file; do
    sample_dir=$(basename "$(dirname "$file")")
    cp "$file" "$output_contig_folder/${sample_dir}.fasta"
done

# 🧪 Filtra i contigs >500bp in parallelo con xargs
find "$output_contig_folder" -type f -name "*.fasta" -print0 | xargs -0 -P "$threads" -I {} bash -c '
  x="{}"
  base=$(basename "$x")
  awk "BEGIN{RS=\">\";ORS=\"\"} length(\$0)>500 {print \">\"\$0}" "$x" > "'"$output_filtered_folder"'/${base%.fasta}.fasta_sort.fasta"
'

# Disattiva Conda
conda deactivate
