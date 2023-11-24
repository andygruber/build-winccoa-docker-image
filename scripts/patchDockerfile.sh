#!/bin/bash

# Check if a file path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_dockerfile>"
    exit 1
fi

# File paths
original_dockerfile="$1"
backup_dockerfile="${original_dockerfile}.backup"

# Create a backup of the original Dockerfile
cp "$original_dockerfile" "$backup_dockerfile"

# Apply changes
sed -i '/^COPY \*.deb/s/^/#/' "$original_dockerfile"
sed -i '/^RUN find \/tmp\/deb\//s/^/#/' "$original_dockerfile"
sed -i '/^\s*-name \\\*.deb/s/^/#/' "$original_dockerfile"
sed -i '/^\s*-not -name/s/^/#/' "$original_dockerfile"
sed -i '/^\s*-exec apt-get install/s/^/#/' "$original_dockerfile"
sed -i '/^\s*apt-get clean/s/^/#/' "$original_dockerfile"
