#Variabili di configurazione 00-01
00-01_Output00="/hpc/group/G_MICRO/DOPnonDOP_noema/rawdata"
00-01_Output01="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output"  

sed s/@00-01_Output00@/${00-01_var1}/g template_00-01.extract_and_adapter.sh > 00-01.extract_and_adapter.sh
sed -i s/@00-01_Output01@/${00-01_var2}/g 00-01.extract_and_adapter.sh

#Variabili di configurazione 02

02_reference_genome="/hpc/home/luca.bettera/Downloads/ncbi_dataset/data/GCA_002263795.4/GCA_002263795.4_ARS-UCD2.0_genomic.fna Bos_taurus"
sed s/@02-reference_genome@/${02_var1}/g template_02.bowtie-database.sh > 02.bowtie-database.sh

#Variabili di configurazione 03

03_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/01_AdpRem_output" #directory di input
03_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory di output
03_dir3="/hpc/group/G_MICRO/Metagenomica-database/Bos_taurus/Bos_taurus.bt2" #database

cp template_03.botwie-remove_host.sh 03.botwie-remove_host.sh

for var in 1 2 3; do
    eval value=\$03_dir${var}
    sed -i "s|@03_dir${var}@|$value|g" 03.botwie-remove_host.sh
done

#Variabili di configurazione 04
04_dir1="$GROUP/common/metaphlan_databases" #directory di database
04_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory dwi campioni
04_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/03_metaphlan_output" #directory di output

cp template_04.metaphlan.sh 04.metaphlan.sh

for var in 1 2 3; do
    eval value=\$04_dir${var}
    sed -i "s|@04_dir${var}@|$value|g" 04.metaphlan.sh
done

#Variabili di configurazione 05
05_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/temporanea" #mkdir
05_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory dei campioni

cp template_05.spades.assembly.sh 05.spades.assembly.sh

for var in 1 2; do
    eval value=\$05_dir${var}
    sed -i "s|@05_var${var}@|$value|g" template_05.spades.assembly.sh
done

#Variabili di configurazione 06
06_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/" #cd
06_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs" #mkdir e secondo cd
06_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" #secondo mkdir

cp template_06.filter.sh template_06.filter.sh


for var in 1 2 3; do
    eval value=\$06_dir${var}
    sed -i "s|@06_var${var}@|$value|g" template_06.filter.sh
done

#Variabili di configurazione 07

07_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" #directory di output
07_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/04_spades_output/contigs/filtered" #directory di input

sed s/@07_var1@/${07_dir1}/g template_07.bowtie-MAG_database.sh > 07.bowtie-MAG_database.sh
sed -i s/@07_var2@/${07_dir2}/g 07.bowtie-MAG_database.sh

#Variabili di configurazione 08

08-09_dir1="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory di fastq
08-09_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/06_Bowtie_Index" #directory di index
08-09_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/07_Bowtie_map" #directory di output

cp template_08-09.mapp_coverage.sh 08-09.mapp_coverage.sh

for var in 1 2 3; do
    eval value=\$08-09_dir${var}
    sed -i "s|@08-09_var${var}@|$value|g" 08-09.mapp_coverage.sh
done