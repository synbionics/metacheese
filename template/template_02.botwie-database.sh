module load bowtie2/2.3.3.1

#/hpc/home/luca.bettera/Downloads/ncbi_dataset/data/GCA_002263795.4/GCA_002263795.4_ARS-UCD2.0_genomic.fna  Bos_taurus
reference_genome= "@02-reference_genome@"
bowtie2-build $reference_genome

deactivate