#!/bin/bash --login

module load apptainer
module load tormes

cd /hpc/group/DOPnonDOP_noema/

INPUT="/hpc/group/G_MICRO/DOPnonDOP_noema/11b_filtered_MAG_thermophilus/my-metadata_thermophilus.txt"

apptainer exec "$TORMES_CONTAINER" tormes --metadata $INPUT --output 12b_tormes_thermophilus/ --threads 32