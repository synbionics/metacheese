#!/bin/bash
set -euo pipefail

# Activate conda only if needed (optional, depends on how the container is configured)
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Define input/output directories (modify as needed)
taxon_dir="@04_1_var1@"
input_dir="@04_1_var2@"
output_dir="@04_1_var3@"

mkdir -p "$output_dir"

# List all forward files and sort
samples=($(ls -1 ${input_dir}/*.1.fq.gz | sort))

# Select the sample using SLURM_ARRAY_TASK_ID
sample=${samples[$((SLURM_ARRAY_TASK_ID-1))]}
sample_name=$(basename "$sample" .1.fq.gz)

input_file="${input_dir}/${sample_name}.1.fq.gz"
taxonomic_profile="${taxon_dir}/${sample_name}.txt"

# Verify that the files exist
if [[ -f "$input_file" && -f "$taxonomic_profile" ]]; then
    echo "Processing sample: $sample_name"

    # Run docker with the required bind mounts (replace "humann_image" with the correct image name)
    docker run --rm \
        -v "$input_dir":/input:ro \
        -v "$taxon_dir":/taxon:ro \
        -v "$output_dir":/output \
        humann_image humann \
            --input "/input/${sample_name}.1.fq.gz" \
            --output /output \
            --threads 4 \
            --remove-temp-output \
            --taxonomic-profile "/taxon/${sample_name}.txt"
else
    echo "WARNING: Input or taxonomic profile missing for sample: $sample_name. Skipping..." >&2
fi

echo "HUMAnN processing complete for sample: $sample_name"
