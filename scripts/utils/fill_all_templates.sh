#!/bin/bash
set -euo pipefail

# 1) Percorsi base
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")
CONFIG_FILE="$PROJECT_ROOT/config/config.yml"

# 2) Definizione degli step
declare -A STEPS
declare -A SEPS

# step00_01
STEPS["step00_01"]="\
  template_00-01.extract_and_adapter.sh \
  scripts/pipeline/00-01.extract_and_adapter.sh \
  00-01 \
  dir1=dir1 dir2=dir2 dir3=dir3 dir4=dir4 dir5=dir5 \
  par1=par1 par2=par2 par3=par3 par4=par4 par5=par5 par6=par6\
"
SEPS["step00_01"]="_"

# step02
STEPS["step02"]="\
  template_02.bowtie-database.sh \
  scripts/pipeline/02.bowtie-database.sh \
  02 \
  var1=reference_genome\
"
SEPS["step02"]="-"

# step03
STEPS["step03"]="\
  template_03.bowtie-remove_host.sh \
  scripts/pipeline/03.bowtie-remove_host.sh \
  03 \
  var1=dir1 var2=dir2 var3=dir3\
"
SEPS["step03"]="_"

# step04
STEPS["step04"]="\
  template_04.metaphlan.sh \
  scripts/pipeline/04.metaphlan.sh \
  04 \
  var1=dir1 var2=dir2 var3=dir3 Rscript=rscript\
"
SEPS["step04"]="_"

# step05
STEPS["step05"]="\
  template_05.spades.assembly.sh \
  scripts/pipeline/05.spades.assembly.sh \
  05 \
  var1=var1 var2=var2 par1=par1 par2=par2\
"
SEPS["step05"]="_"

# step06
STEPS["step06"]="\
  template_06.contig_filter.sh \
  scripts/pipeline/06.contig_filter.sh \
  06 \
  var1=var1 var2=var2 var3=var3 filter1=filter1\
"
SEPS["step06"]="_"

# step07
STEPS["step07"]="\
  template_07.bowtie-MAG_database.sh \
  scripts/pipeline/07.bowtie-MAG_database.sh \
  07 \
  var1=dir1 var2=dir2 par1=par1\
"
SEPS["step07"]="_"

# step08_09
STEPS["step08_09"]="\
  template_08-09.mapp_coverage.sh \
  scripts/pipeline/08-09.mapp_coverage.sh \
  08-09 \
  var1=dir1 var2=dir2 var3=dir3\
"
SEPS["step08_09"]="_"

# step10_11
STEPS["step10_11"]="\
  template_10-11-11b.metabat.sh \
  scripts/pipeline/10-11-11b.metabat.sh \
  10-11 \
  var1=dir1 var2=dir2 var3=dir3 var4=dir4 var5=dir5 par1=par1 par2=par2\
"
SEPS["step10_11"]="_"

# step12_13
STEPS["step12_13"]="\
  template_12-13.checkm.sh \
  scripts/pipeline/12-13.checkm.sh \
  12-13 \
  var1=var1 var2=var2 var3=var3 par1=par1 par2=par2 par3=par3\
"
SEPS["step12_13"]="_"

# step14
STEPS["step14"]="\
  template_14.filter-metadata.sh \
  scripts/pipeline/14.filter-metadata.sh \
  14 \
  var1=var1 var2=var2 var3=var3 var4=var4 \
  var5=var5 var6=var6 var7=var7 var8=var8\
"
SEPS["step14"]="_"

# step15
STEPS["step15"]="\
  template_15.tormes_MAG.sh \
  scripts/pipeline/15.tormes_MAG.sh \
  15 \
  var1=var1 var2=var2 par1=par1 par2=par2\
"
SEPS["step15"]="_"

# 3) Generazione
for STEP_KEY in "${!STEPS[@]}"; do
  read -r -a arr <<< "${STEPS[$STEP_KEY]}"
  TEMPLATE_FILE="${arr[0]}"
  OUTPUT_FILE="${arr[1]}"
  PREFIX="${arr[2]}"
  map_pairs=("${arr[@]:3}")
  SEP="${SEPS[$STEP_KEY]}"

  TEMPLATE_PATH="$PROJECT_ROOT/scripts/templates/$TEMPLATE_FILE"
  OUTPUT_PATH="$PROJECT_ROOT/$OUTPUT_FILE"

  echo " Generating [$STEP_KEY] → $OUTPUT_FILE"

  [ -f "$TEMPLATE_PATH" ]   || { echo " Missing template: $TEMPLATE_PATH"; continue; }
  [ -f "$CONFIG_FILE" ]     || { echo " Missing config:   $CONFIG_FILE"; exit 1; }

  mkdir -p "$(dirname "$OUTPUT_PATH")"
  cp "$TEMPLATE_PATH" "$OUTPUT_PATH"

  for pair in "${map_pairs[@]}"; do
    ph="${pair%%=*}"
    yaml_key="${pair#*=}"
    value=$(yq eval -r ".${STEP_KEY}.${yaml_key}" "$CONFIG_FILE")
    #echo "    • Replacing @$PREFIX$SEP$ph@ → $value"
    sed -i "s|@$PREFIX$SEP$ph@|$value|g" "$OUTPUT_PATH"
  done

  chmod +x "$OUTPUT_PATH"
  echo " Created $OUTPUT_FILE"
done
