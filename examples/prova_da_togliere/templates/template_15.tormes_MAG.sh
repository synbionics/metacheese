#!/bin/bash --login

module load apptainer
module load tormes

cd /hpc/group/DOPnonDOP_noema/

INPUT=@15_var1@

apptainer exec "$TORMES_CONTAINER" tormes --metadata $INPUT --output @15_par1@ --threads @15_par2@