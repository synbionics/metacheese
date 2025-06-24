#!/bin/bash

CONFIG=Config.yml

# sed 01
cp template_00-01.extract_and_adapter.sh 00-01.extract_and_adapter.sh
for var in {1..5}; do
    value=$(yq ".step00_01.dir${var}" "$CONFIG")
    sed -i "s|@00-01_var${var}@|$value|g" 00-01.extract_and_adapter.sh
done

for var in {1..6}; do
    value=$(yq ".step00_01.par${var}" "$CONFIG")
    sed -i "s|@00-01_par${var}@|$value|g" 00-01.extract_and_adapter.sh
done

# sed 02
reference_genome=$(yq '.step02.reference_genome' "$CONFIG")
sed "s|@02-reference_genome@|$reference_genome|g" template_02.bowtie-database.sh > 02.bowtie-database.sh

# sed 03
cp template_03.botwie-remove_host.sh 03.bowtie-remove_host.sh
for var in {1..3}; do
    value=$(yq ".step03.dir${var}" "$CONFIG")
    sed -i "s|@03_dir${var}@|$value|g" 03.bowtie-remove_host.sh
done

# sed 04
cp template_04.metaphlan.sh 04.metaphlan.sh
for var in {1..3}; do
    value=$(yq ".step04.dir${var}" "$CONFIG")
    sed -i "s|@04_dir${var}@|$value|g" 04.metaphlan.sh
done
rscript=$(yq '.step04.rscript' "$CONFIG")
sed "s|@04_Rscript@|$rscript|g" template_04.metaphlan.sh > 04.metaphlan.sh

# sed 05
cp template_05.spades.assembly.sh 05.spades.assembly.sh
for var in 1 2; do
    value=$(yq ".step05.dir${var}" "$CONFIG")
    sed -i "s|@05_var${var}@|$value|g" 05.spades.assembly.sh
done

# sed 06
cp template_06.filter.sh 06.filter.sh
for var in {1..3}; do
    value=$(yq ".step06.dir${var}" "$CONFIG")
    sed -i "s|@06_var${var}@|$value|g" 06.filter.sh
done

# sed 07
var1=$(yq '.step07.dir1' "$CONFIG")
var2=$(yq '.step07.dir2' "$CONFIG")
sed "s|@07_var1@|$var1|g" template_07.bowtie-MAG_database.sh > 07.bowtie-MAG_database.sh
sed -i "s|@07_var2@|$var2|g" 07.bowtie-MAG_database.sh

# sed 08-09
cp template_08-09.mapp_coverage.sh 08-09.mapp_coverage.sh
for var in {1..3}; do
    value=$(yq ".step08_09.dir${var}" "$CONFIG")
    sed -i "s|@08-09_var${var}@|$value|g" 08-09.mapp_coverage.sh
done

# sed 10-11-11b
cp template_10-11-11b.metabat.sh 10-11-11b.metabat.sh
for var in {1..5}; do
    value=$(yq ".step10_11.dir${var}" "$CONFIG")
    sed -i "s|@10-11_var${var}@|$value|g" 10-11-11b.metabat.sh
done
par1=$(yq '.step10_11.par1' "$CONFIG")
par2=$(yq '.step10_11.par2' "$CONFIG")
sed -i "s|@10-11_par1@|$par1|g" 10-11-11b.metabat.sh
sed -i "s|@10-11_par2@|$par2|g" 10-11-11b.metabat.sh

# sed 12-13
cp template_12-13.checkm.sh 12-13.checkm.sh
for var in {1..3}; do
    value=$(yq ".step12_13.dir${var}" "$CONFIG")
    sed -i "s|@12-13_var${var}@|$value|g" 12-13.checkm.sh
done
for var in {1..3}; do
    value=$(yq ".step12_13.par${var}" "$CONFIG")
    sed -i "s|@12-13_par${var}@|$value|g" 12-13.checkm.sh
done

# sed 14
cp template_14.filter-metadata.sh 14.filter-metadata.sh
for var in {1..8}; do
    value=$(yq ".step14.var${var}" "$CONFIG")
    sed -i "s|@14_var${var}@|$value|g" 14.filter-metadata.sh
done

# sed 15
var1=$(yq '.step15.var1' "$CONFIG")
par1=$(yq '.step15.par1' "$CONFIG")
par2=$(yq '.step15.par2' "$CONFIG")
sed "s|@15_var1@|$var1|g" template_15.tormes_MAG.sh > 15.tormes_MAG.sh
sed -i "s|@15_par1@|$par1|g" 15.tormes_MAG.sh
sed -i "s|@15_par2@|$par2|g" 15.tormes_MAG.sh