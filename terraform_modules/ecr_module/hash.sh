#!/bin/bash
set -e

source_path=${1:-.}

# Hash all source files of the Docker image
file_hashes="$(
    cd "$source_path" \
    && find . -type f \( -name 'Dockerfile' -o -name '*' \) -exec md5sum {} \;
)"

hash="$(echo "$file_hashes" | md5sum | cut -d' ' -f1)"

echo '{ "hash": "'"$hash"'" }'