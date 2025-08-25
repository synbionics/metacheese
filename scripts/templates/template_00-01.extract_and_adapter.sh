#!/bin/bash
set -euo pipefail

# Initialize Conda and activate bioenv environment
source /opt/conda/etc/profile.d/conda.sh
conda activate bioenv

# Step 1: Extraction of .fq.gz files from .tar archives
cd @00-01_dir1@
output_dir00="@00-01_dir2@"
output_dir01="@00-01_dir3@"

mkdir -p "$output_dir00" "$output_dir01"

# Step 2: AdapterRemoval remains unchanged
echo "Starting adapter removal with AdapterRemoval..."
for file_L1 in "@00-01_dir1@"/*_1.fq.gz; do
    file_base=${file_L1%_1.fq.gz}
    file_L2="${file_base}_2.fq.gz"
    sample_name=$(basename "$file_base")

    if [[ ! -f "$file_L2" ]]; then
        echo "Error: paired file $file_L2 missing for $file_L1" >&2
        exit 1
    fi

    AdapterRemoval \
        --file1 "$file_L1" --file2 "$file_L2" \
        --output1 "$output_dir01/${sample_name}_cleaned_L1.fq.gz" \
        --output2 "$output_dir01/${sample_name}_cleaned_L2.fq.gz" \
        --threads @00-01_par1@ \
        --gzip \
        --minlength @00-01_par2@ \
        --trimqualities \
        --minquality @00-01_par3@ \
        --trimns \
        --maxns @00-01_par4@ \
        --trim5p @00-01_par5@ \
        --trim3p @00-01_par6@
done

echo "Adapter removal completed."
