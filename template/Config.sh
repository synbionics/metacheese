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
04_dir2="/hpc/group/G_MICRO/DOPnonDOP_noema/02_Bowtie2_output" #directory di campioni
04_dir3="/hpc/group/G_MICRO/DOPnonDOP_noema/03_metaphlan_output" #directory di output

cp template_04.metaphlan.sh 04.metaphlan.sh

for var in 1 2 3; do
    eval value=\$04_dir${var}
    sed -i "s|@04_dir${var}@|$value|g" 04.metaphlan.sh
done