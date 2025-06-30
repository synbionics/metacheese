#!/bin/bash --login

module load apptainer
module load tormes

cd /hpc/group/DOPnonDOP_noema/

INPUT=/hpc/group/DOPnonDOP_noema/

apptainer exec "$TORMES_CONTAINER" tormes --metadata $INPUT --output ../../data/processed/15_tormes_MAGs --threads 16