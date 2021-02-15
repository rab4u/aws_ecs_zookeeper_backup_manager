#!/bin/bash
set -e

# Dependency check
dependencies=( aws docker )
for cmd in "${dependencies[@]}"
do
	if command -v "${cmd}" >/dev/null 2>&1 ; then
    echo "[INFO] ${cmd} command found. proceeding to the next steps..."
  else
    echo "[Error] ${cmd} command not found. please install latest ${cmd}"
    exit 1
  fi
done

source_path="$1"
repository_url="$2"
tag="${3:-latest}"

region="$(echo "$repository_url" | cut -d. -f4)"
image_name="$(echo "$repository_url" | cut -d/ -f2)"

(cd "$source_path" && docker build -t "$image_name":"$tag" .)

aws ecr get-login-password \
--region "$region" | docker login \
--username AWS \
--password-stdin "$repository_url"
if [ $? -eq 0 ]; then
    docker tag "$image_name":"$tag" "$repository_url":"$tag"
    docker push "$repository_url":"$tag"
else
    echo "[ERROR] FAILED IN EXECUTING THE COMMAND :"
    echo """
    aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $repository_url
    """
    exit 1
fi

