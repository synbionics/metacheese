#!/bin/bash

set -e  # Esci subito se un comando fallisce
echo " Avvio test pipeline template..."

# 1. Lancia sed.sh
echo " Generazione script con sed.sh..."
bash sed.sh

# 2. Lista di tutti gli script che dovrebbero essere stati generati
SCRIPT_LIST=(
    "00-01.extract_and_adapter.sh"
    "02.bowtie-database.sh"
    "03.bowtie-remove_host.sh"
    "04.metaphlan.sh"
    "05.spades.assembly.sh"
    "06.filter.sh"
    "07.bowtie-MAG_database.sh"
    "08-09.mapp_coverage.sh"
    "10-11-11b.metabat.sh"
    "12-13.checkm.sh"
    "14.filter-metadata.sh"
    "15.tormes_MAG.sh"
)

echo " Verifica file generati..."
all_passed=true
for script in "${SCRIPT_LIST[@]}"; do
    if [[ -f "$script" ]]; then
        echo " $script trovato"
        
        # 3. Controlla placeholder rimasti
        if grep -q "@[0-9a-zA-Z_\-]\+@" "$script"; then
            echo " Placeholder non sostituiti in $script"
            all_passed=false
        fi
    else
        echo " $script mancante"
        all_passed=false
    fi
done

# 4. Esito finale
echo ""
if $all_passed; then
    echo -e " Tutti gli script sono stati generati correttamente e non contengono placeholder residui!"
else
    echo -e "  Attenzione: alcuni script hanno placeholder non sostituiti o mancano del tutto."
fi
