#!/bin/bash

# Attiva l'ambiente Conda in cui è installato Bowtie2
source /opt/conda/etc/profile.d/conda.sh
conda activate bowtieenv

# Definisci il percorso al genoma di riferimento (senza estensione per output index)
reference_genome="@02-var1@"

# Costruisce l'indice di Bowtie2
bowtie2-build "$reference_genome" "$reference_genome"

# Disattiva l'ambiente Conda alla fine
conda deactivate
