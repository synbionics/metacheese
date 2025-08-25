#!/bin/bash
set -eo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate tormes-1.3.0

WORKDIR="@15_var1@"
INPUT="@15_var2@"
OUTPUT="@15_par1@"
THREADS="@15_par2@"

cd "$WORKDIR"

[[ -d "$WORKDIR" ]] || { echo "Error: working directory $WORKDIR not found" >&2; exit 1; }
[[ -f "$INPUT" ]] || { echo "Error: metadata file $INPUT not found" >&2; exit 1; }

echo "Running TORMES on $INPUT in directory $WORKDIR, output to $OUTPUT using $THREADS threads"

tormes --metadata "$INPUT" --output "$OUTPUT" --threads "$THREADS"

echo "TORMES successfully completed in $WORKDIR/$OUTPUT"

conda deactivate
