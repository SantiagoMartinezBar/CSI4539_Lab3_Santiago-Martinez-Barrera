#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
if ! command -v docker >/dev/null 2>&1; then
    echo 'Je dois installer et ouvrir Docker Desktop avant de continuer.' >&2
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "Je dois ouvrir Docker Desktop et attendre que son moteur fonctionne." >&2
    exit 1
fi
docker run --rm -it --platform linux/amd64 \
    --mount "type=bind,source=$root,target=/project" \
    --mount type=volume,source=csi4539-lab3-tools,target=/opt/lab3-tools \
    --workdir /project \
    debian:trixie-slim bash scripts/container_demo.sh
