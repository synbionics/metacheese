#!/usr/bin/env bash
set -euo pipefail

# 1) Percorsi base
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")
CONFIG_FILE="$PROJECT_ROOT/config/config.yml"

# 2) Definizione degli step
declare -A STEPS
declare -A SEPS

# step00_01: prefix "00-01", separatore "_" e placeholder dir1…dir5, par1…par6
STEPS["step00_01"]="\
  template_00-01.extract_and_adapter.sh \
  scripts/pipeline/00-01.extract_and_adapter.sh \
  00-01 \
  dir1=dir1 dir2=dir2 dir3=dir3 dir4=dir4 dir5=dir5 \
  par1=par1 par2=par2 par3=par3 par4=par4 par5=par5 par6=par6\
"
SEPS["step00_01"]="_"

# step02: prefix "02", separatore "-" e placeholder var1→reference_genome
STEPS["step02"]="\
  template_02.bowtie-database.sh \
  scripts/pipeline/02.bowtie-database.sh \
  02 \
  var1=reference_genome\
"
SEPS["step02"]="-"

# (aggiungi qui altri step…)

# 3) Loop sugli step
for STEP_KEY in "${!STEPS[@]}"; do
  # Legge la stringa in array
  read -r -a arr <<< "${STEPS[$STEP_KEY]}"
  TEMPLATE_FILE="${arr[0]}"
  OUTPUT_FILE="${arr[1]}"
  PREFIX="${arr[2]}"
  map_pairs=("${arr[@]:3}")   # tutte le coppie placeholder=chiaveYaml
  SEP="${SEPS[$STEP_KEY]}"

  TEMPLATE_PATH="$PROJECT_ROOT/scripts/templates/$TEMPLATE_FILE"
  OUTPUT_PATH="$PROJECT_ROOT/$OUTPUT_FILE"

  echo -e "\n Generating [$STEP_KEY] → $OUTPUT_FILE"

  # Controlli
  [ -f "$TEMPLATE_PATH" ]   || { echo " Missing template: $TEMPLATE_PATH"; continue; }
  [ -f "$CONFIG_FILE" ]     || { echo " Missing config:   $CONFIG_FILE"; exit 1; }

  mkdir -p "$(dirname "$OUTPUT_PATH")"
  cp "$TEMPLATE_PATH" "$OUTPUT_PATH"

  # Per ciascuna coppia placeholder=chiaveYaml
  for pair in "${map_pairs[@]}"; do
    ph="${pair%%=*}"        # es. dir4 o var1
    yaml_key="${pair#*=}"   # es. dir4 o reference_genome
    value=$(yq eval -r ".${STEP_KEY}.${yaml_key}" "$CONFIG_FILE")

    # debug
    echo "    • Replacing @$PREFIX$SEP$ph@ → $value"

    sed -i "s|@$PREFIX$SEP$ph@|$value|g" "$OUTPUT_PATH"
  done

  chmod +x "$OUTPUT_PATH"
  echo " Created: $OUTPUT_FILE"
done
