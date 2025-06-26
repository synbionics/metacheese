#!/usr/bin/env bash
set -euo pipefail

# Inizializza Conda e attiva ambiente bioenv 
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# --- Parametri definiti nel config.yml via placeholder ---
output_base_dir="@05_var1@"     # cartella dove creare sottocartelle per ogni campione
campioni_folder="@05_var2@"     # cartella con file .fq.1.gz e .fq.2.gz
threads="@05_par1@"              # numero di thread
memory="@05_par2@"               # memoria RAM in GB

mkdir -p "$output_base_dir"
cd "$output_base_dir"

# --- Lista ordinata dei campioni ---
samples=($(ls -1 "$campioni_folder"/*fq.1.gz | sort))
sample="${samples[$((SLURM_ARRAY_TASK_ID - 1))]}"
nome_campione=$(basename "$sample" .fq.1.gz)

# --- Log campione processato ---
echo " Avvio SPAdes per: $nome_campione"

# --- Lancio SPAdes ---
spades.py \
  -1 "${campioni_folder}/${nome_campione}.fq.1.gz" \
  -2 "${campioni_folder}/${nome_campione}.fq.2.gz" \
  --meta \
  -t "$threads" \
  --memory "$memory" \
  --only-assembler \
  -o "${output_base_dir}/${nome_campione}"

echo " SPAdes completato per: $nome_campione"

# --- Disattiva Conda ---
conda deactivate
