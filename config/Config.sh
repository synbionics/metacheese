# Variabili di configurazione step 00-01
step00_01_dir1="/hpc/archive/G_MICRO/rawdata/" # comando cd per dove sono i campioni .tar
step00_01_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/rawdata" # directory di output estrazione
step00_01_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output" # directory di output AdapterRemoval
step00_01_dir4="/hpc/archive/G_MICRO/rawdata/X204SC24020161-Z01-F003_01.tar" # file tar 01
step00_01_dir5="/hpc/archive/G_MICRO/rawdata/X204SC24020161-Z01-F003_02.tar" # file tar 02

step00_01_par1=80 # threads
step00_01_par2=50 # lunghezza minima
step00_01_par3=30 # qualità minimaq
step00_01_par4=10 # max ns
step00_01_par5=2 # trim5p
step00_01_par6=2 # trim3p

# Variabili di configurazione step 02
step02_reference_genome="/hpc/home/luca.bettera/Downloads/ncbi_dataset/data/GCA_002263795.4/GCA_002263795.4_ARS-UCD2.0_genomic.fna Bos_taurus"

# Variabili di configurazione step 03
step03_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output" # directory di input
step03_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" # directory di output
step03_dir3="/hpc/group/G_MICRO/Metagenomica-database/Bos_taurus/Bos_taurus.bt2" # database

# Variabili di configurazione step 04
step04_dir1="$GROUP/common/metaphlan_databases" # directory di database
step04_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" # directory dwi campioni
step04_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/03_metaphlan_output" # directory di output

step04_rscript="/opt/micromamba/envs/metaphlan/lib/python3.12/site-packages/metaphlan/utils/calculate_diversity.R" # script R

# Variabili di configurazione step 05
step05_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/temporanea" # mkdir
step05_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" # directory dei campioni

# Variabili di configurazione step 06
step06_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/" # cd
step06_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs" # mkdir e secondo cd
step06_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" # secondo mkdir

step06_filter1=32 # filtro parallel
step06_filter2=500 # filtro lunghezza minima
step06_filter3="filtered" # filtro dir output

# Variabili di configurazione step 07
step07_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" # directory di output
step07_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" # directory di input

step07_par1=32

# Variabili di configurazione step 08-09
step08_09_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" # directory di fastq
step08_09_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" # directory di index
step08_09_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map" # directory di output

# Variabili di configurazione step 10-11-11b
step10_11_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map" # directory di input
step10_11_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/08_metabat_depth" # directory di output depth
step10_11_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" # directory di input contig
step10_11_dir4="/hpc/group/G_MICRO/DOPnonDOP_noema/09_metabat_MAG" # directory di output metabat
step10_11_dir5="/hpc/group/G_MICRO/DOPnonDOP_noema/09b_metabat_MAG" # directory di output metabat 11b

step10_11_par1=1500 # lunghezza minima contig
step10_11_par2=32 # threads

# Variabili di configurazione step 12-13
step12_13_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/09_metabat_MAG" # directory di input
step12_13_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm" # directory di output checkm
step12_13_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm2" # directory di output checkm2

step12_13_par1=32 # threads checkm
step12_13_par2=32 # threads pplacer
step12_13_par3=30 # threads checkm2

# Variabili di configurazione step 14
step14_var1="/percorso/al/quality_report.tsv"
step14_var2="/percorso/ai_MAGs_originali"
step14_var3="/percorso/ai_MAGs_filtrati"
step14_var4="/percorso/a_tutti_i_MAGs"
step14_var5=50
step14_var6=10
step14_var7="my-metadata2.txt"
step14_var8="my-metadata_thermophilus.txt"

# Variabili di configurazione step 15
step15_var1="/hpc/group/G_MICRO/DOPnonDOP_noema/11b_filtered_MAG_thermophilus/my-metadata_thermophilus.txt" # directory di input

step15_par1="s12b_tormes_thermophilus/" # directory di output
step15_par2=32 # threads