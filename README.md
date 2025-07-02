# metacheese
metacheese è una pipeline modulare per l’elaborazione di dati metagenomici, confezionata in un contenitore Docker che integra strumenti bioinformatici moderni in ambienti isolati per massima compatibilità e replicabilità.

metacheese/
├── README.md
├── Dockerfile                      # Definizione immagine Docker per l'ambiente del progetto
├───config                          # per i file YAML o SH di configurazione
│   └── config.yml
├───data                            # per organizzare input/output ( da migliorare)
│   ├───input                         # per i dati originali (es. FASTQ, metadati)
│   │   ├───database_metaphlan
│   │   ├───gene
│   │   │   └───Bos_taurus
│   │   └───rawdata
│   ├───processed                     # per output intermedi o finali
│   │   ├───02_Bowtie2_output
│   │   └───04_metaphlan_output
│   └───tmp                           # per file temporanei
│       └───stept00_01
│           ├───AdpRem
│           └───rawData
├───docs                            # immagini, schemi, diagrammi della pipeline.
├───examples                        # per testare singoli step con dati minimi
│   └───prova_da_togliere
│       ├───config
│       ├───pipeline
│       ├───templates
│       └───utils
└───scripts                         # con gli step principali della pipeline
    ├───pipeline                      # script da eseguire
    ├───templates                     # template di script parametrizzabili 
    └───utils                         # sed/riempimento e altro



# metacheese Docker Container
Ambiente Docker personalizzato per analisi bioinformatiche con strumenti moderni mantenuti separati.

## Contenuto
Docker container costruito su Ubuntu 18.04 con i seguenti tool e ambienti:
- Miniconda con ambienti isolati::
  - `bioenv`: contiene AdapterRemoval, MetaPhlAn, CheckM, Samtools, SPAdes, MetaBAT2
  - `bowtieenv`: contiene Bowtie2 (Python 2.7, Perl 5.22)
- R + pacchetto `optparse`
- Il container monta automaticamente le directory `scripts/`, `data/`, `config/`, `examples/`

## Costruzione e utilizzo
Da terminale:



# Build dell'immagine
docker build -t bio-tools .
# Build dell'immagine con il compose
docker compose up -d
# per eseguire il container: 
docker exec -it bio-tools-container bash

# in bioenv per scaricare il database_metaphlan
metaphlan dummy.fq --input_type fastq \
  --bowtie2db ../../data/input/database_metaphlan \
  --bowtie2out /dev/null -o /dev/null --nproc 4



```bash
# Build dell'immagine
docker build -t metacheese .

# Esecuzione interattiva
docker run -it --rm -v $PWD:/data metacheese /bin/bash
docker run -it --rm -v C:\Users\Dorin\Documents\GitHub\metacheese:/data metacheese /bin/bash
docker run -it metacheese

# All'interno del container
cd /data
. activate_tool.sh
conda info --envs
./check_tools.sh
bash xxx.sh
conda activate bioenv

#per scaricare i pacchetti R
 conda install -c bioconda bioconductor-microbiome
 conda install -c conda-forge -c bioconda \
>   r-vegan r-optparse r-ape r-rbiom r-compositions bioconductor-microbiome

