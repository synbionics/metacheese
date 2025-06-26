#!/usr/bin/env bash
set -euo pipefail

# 1. CREA FILE CLEANED FQ.GZ FINTI
echo " Creo file cleaned *.fq.gz fittizi..."
mkdir -p /data/data/tmp/stept00_01/AdpRem

for SAMPLE in sample1 sample2; do
  for READ in L1 L2; do
    echo -e "@${SAMPLE}_${READ}\nGATTACA\n+\nIIIIIII" | gzip > \
      "/data/data/tmp/stept00_01/AdpRem/${SAMPLE}_cleaned_${READ}.fq.gz"
  done
done

# 2. CREA UN MINI FASTA E INDICIZZA CON BOWTIE2
echo " Creo FASTA fittizio e indicizzo con Bowtie2..."
mkdir -p /data/input/database_metaphlan/Bos_taurus
echo -e ">chrTest\nGATTACAGATTACAGATTACA" > /data/input/database_metaphlan/Bos_taurus/dummy.fa

bowtie2-build \
  /data/input/database_metaphlan/Bos_taurus/dummy.fa \
  /data/input/database_metaphlan/Bos_taurus/Bos_taurus

echo " Tutto pronto: file cleaned e database indicizzato creati!"
