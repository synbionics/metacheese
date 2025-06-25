#!/bin/bash --login

shopt -q login_shell || exit 1

module load apptainer
module load metaphlan

# 1. Impostazione cartelle e variabili
DEFAULT_DB_FOLDER="$GROUP/common/metaphlan_databases"
campioni_folder="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output"
output_folder="/hpc/group/G_MICRO/DOPnonDOP_noema/03_metaphlan_output"

mkdir -p "$DEFAULT_DB_FOLDER"
if [ ! -d "$DEFAULT_DB_FOLDER" ]; then
    echo "'$DEFAULT_DB_FOLDER': No such file or directory" 1>&2
    exit 1
fi
mkdir -p "$output_folder"

# 2. Profilazione tassonomica per ogni campione (solo se SLURM_ARRAY_TASK_ID è definito)
if [ -n "$SLURM_ARRAY_TASK_ID" ]; then
    file=$(ls "$campioni_folder"/*fq.1.gz | sed -n "$((SLURM_ARRAY_TASK_ID + 1))p")
    nome_campione=$(basename "$file" .fq.1.gz)

    apptainer exec "$METAPHLAN_CONTAINER" metaphlan \
        "$campioni_folder/${nome_campione}.fq.1.gz","$campioni_folder/${nome_campione}.fq.2.gz" \
        --bowtie2db "$DEFAULT_DB_FOLDER" \
        --input_type fastq \
        --nproc 16 \
        --bowtie2out "$output_folder/${nome_campione}.bz2" \
        -o "$output_folder/${nome_campione}.txt" \
        -s "$output_folder/${nome_campione}.sam.bz2"
    exit 0
fi

# 3. Merge dei profili tassonomici (da lanciare senza SLURM_ARRAY_TASK_ID)
apptainer exec "$METAPHLAN_CONTAINER" merge_metaphlan_tables.py \
    "$output_folder"/*.txt > "$output_folder/merged_abundance_table.txt"

# 4. Calcolo diversità alpha
for metric in richness shannon simpson gini; do
    apptainer exec "$METAPHLAN_CONTAINER" Rscript /opt/micromamba/envs/metaphlan/lib/python3.12/site-packages/metaphlan/utils/calculate_diversity.R \
        -f "$output_folder/merged_abundance_table.txt" \
        -d alpha \
        -m "$metric" \
        #-o "$output_folder/alpha_diversity_${metric}.txt"
done

# 5. Calcolo diversità beta
for metric in bray-curtis jaccard weighted-unifrac unweighted-unifrac clr aitchison; do
    apptainer exec "$METAPHLAN_CONTAINER" Rscript /opt/micromamba/envs/metaphlan/lib/python3.12/site-packages/metaphlan/utils/calculate_diversity.R \
        -f "$output_folder/merged_abundance_table.txt" \
        -d beta \
        -m "$metric" \
        #-o "$output_folder/beta_diversity_${metric}.txt"
done