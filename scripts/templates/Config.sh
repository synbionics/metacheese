#Variabili di configurazione 00-01
00-01_Output00="/hpc/group/G_MICRO/DOPnonDOP_noema/rawdata"
00-01_Output01="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output"

00-01_par1=80 #threads
00-01_par2=50 #lunghezza minima
00-01_par3=30 #qualità minima
00-01_par4=10 #max ns
00-01_par5=2 #trim5p
00-01_par6=2 #trim3p

#Variabili di configurazione 02

02_reference_genome="/hpc/home/luca.bettera/Downloads/ncbi_dataset/data/GCA_002263795.4/GCA_002263795.4_ARS-UCD2.0_genomic.fna Bos_taurus"

#Variabili di configurazione 03

03_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output" #directory di input
03_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory di output
03_dir3="/hpc/group/G_MICRO/Metagenomica-database/Bos_taurus/Bos_taurus.bt2" #database

#Variabili di configurazione 04
04_dir1="$GROUP/common/metaphlan_databases" #directory di database
04_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory dwi campioni
04_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/03_metaphlan_output" #directory di output

04_Rscript="/opt/micromamba/envs/metaphlan/lib/python3.12/site-packages/metaphlan/utils/calculate_diversity.R" #script R

#Variabili di configurazione 05
05_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/temporanea" #mkdir
05_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory dei campioni

#Variabili di configurazione 06

06_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/" #cd
06_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs" #mkdir e secondo cd
06_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" #secondo mkdir

06_filter1=32 #filtro parallel
06_filter2=500 #filtro lunghezza minima
06_filter3="filtered" #filtro dir output

#Variabili di configurazione 07

07_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" #directory di output
07_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" #directory di input

07_par1=32

#Variabili di configurazione 08-09

08-09_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory di fastq
08-09_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" #directory di index
08-09_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map" #directory di output

#Variabili di configurazione 10-11-11b

10-11_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map" #directory di input
10-11_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/08_metabat_depth" #directory di output depth
10-11_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" #directory di input contig
10-11_dir4="/hpc/group/G_MICRO/DOPnonDOP_noema/09_metabat_MAG" #directory di output metabat
10-11_dir5="/hpc/group/G_MICRO/DOPnonDOP_noema/09b_metabat_MAG" #directory di output metabat 11b

10-11_par1=1500 #lunghezza minima contig
10-11_par2=32 #threads

#Variabili di configurazione 12-13
12-13_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/09_metabat_MAG" #directory di input
12-13_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm" #directory di output checkm
12-13_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/10_checkm2" #directory di output checkm2

12-13_par1=32 #threads checkm
12-13_par2=32 #threads pplacer
12-13_par3=30 #threads checkm2

#Variabili di configurazione 14

14_var1="/percorso/al/quality_report.tsv"
14_var2="/percorso/ai_MAGs_originali"
14_var3="/percorso/ai_MAGs_filtrati"
14_var4="/percorso/a_tutti_i_MAGs"
14_var5=50
14_var6=10
14_var7="my-metadata2.txt"
14_var8="my-metadata_thermophilus.txt"

#Variabili di configurazione 15

15_var1="/hpc/group/G_MICRO/DOPnonDOP_noema/11b_filtered_MAG_thermophilus/my-metadata_thermophilus.txt" #directory di input

15_par1="s12b_tormes_thermophilus/" #directory di output
15_par2=32 #threads
