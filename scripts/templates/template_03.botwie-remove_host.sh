#!/bin/bash

# lo script va sbatchato dalla cartella 01_AdpRem_output
module load bowtie2/2.3.3.1

# Ottieni il percorso della directory corrente
sample_directory="@03_var1@"

# Crea cartella di output "mkdir -p /hpc/group/G_MICRO/CoagMicroGP_shotgun/02_Bowtie2_output"
output_dir="@03_var2@"
# oppure qui usando
mkdir -p "$output_dir"
 

# Loop attraverso i file che seguono il pattern FILE_cleaned_R1.fq.gz
for file_L1 in "$sample_directory"/*cleaned_L1.fq.gz; do
    # Verifica se almeno un file R1 è presente
    if [ -e "$file_L1" ]; then
        # Genera il nome del file R2 corrispondente
        file_L2="${file_L1/_L1/_L2}"
        
        # Esegui il comando bowtie2 con i nomi dei file correnti
        # riga 27, forse, rimuovibile

        meta_database=@03_var3@
        bowtie2 -x $meta_database \
		-1 "$file_L1" -2 "$file_L2" \
	        -q --phred33 --local \
                --un-conc-gz "$output_dir/$(basename "${file_L1/_cleaned_L1.fq.gz/.fq.gz}")" \
                -p 32 -S "$output_dir/$(basename "${file_L1/_cleaned_L1.fq.gz/.sam}")"

        # Elimina il file .sam dalla cartella bowtie
        rm "$output_dir/$(basename "${file_L1/_cleaned_L1.fq.gz/.sam}")"

        # Puoi aggiungere ulteriori comandi o logica qui, se necessario
    fi
done

# Cosa fa questa riga? Questa riga elimina il file di output in formato SAM generato da Bowtie2. Il file SAM è un formato di allineamento dettagliato, ma può occupare molto spazio, soprattutto con grandi dataset.