#sed 01
sed s/@00-01_Output00@/${00-01_var1}/g template_00-01.extract_and_adapter.sh > 00-01.extract_and_adapter.sh
sed -i s/@00-01_Output01@/${00-01_var2}/g 00-01.extract_and_adapter.sh

#sed 02
sed s/@02-reference_genome@/${02_var1}/g template_02.bowtie-database.sh > 02.bowtie-database.sh

#sed 03
cp template_03.botwie-remove_host.sh 03.botwie-remove_host.sh

for var in 1 2 3; do
    eval value=\$03_dir${var}
    sed -i "s|@03_dir${var}@|$value|g" 03.bowtie-remove_host.sh
done

#sed 04
cp template_04.metaphlan.sh 04.metaphlan.sh

for var in 1 2 3; do
    eval value=\$04_dir${var}
    sed -i "s|@04_dir${var}@|$value|g" 04.metaphlan.sh
done

#sed 05
cp template_05.spades.assembly.sh 05.spades.assembly.sh

for var in 1 2; do
    eval value=\$05_dir${var}
    sed -i "s|@05_var${var}@|$value|g" template_05.spades.assembly.sh
done

#sed 06
cp template_06.filter.sh template_06.filter.sh

for var in 1 2 3; do
    eval value=\$06_dir${var}
    sed -i "s|@06_var${var}@|$value|g" template_06.filter.sh
done

#sed 07
sed s/@07_var1@/${07_dir1}/g template_07.bowtie-MAG_database.sh > 07.bowtie-MAG_database.sh
sed -i s/@07_var2@/${07_dir2}/g 07.bowtie-MAG_database.sh

#sed 08-09
cp template_08-09.mapp_coverage.sh 08-09.mapp_coverage.sh

for var in 1 2 3; do
    eval value=\$08-09_dir${var}
    sed -i "s|@08-09_var${var}@|$value|g" 08-09.mapp_coverage.sh
done

