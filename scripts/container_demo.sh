#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update --error-on=any
apt-get install -y --no-install-recommends \
    ca-certificates curl git libc6-dev make python3 unzip
export LAB3_TOOLS_DIR=${LAB3_TOOLS_DIR:-/opt/lab3-tools}
bash scripts/setup_tools.sh
source "$LAB3_TOOLS_DIR/activate.sh"
if [[ ${1:-} == --check ]]; then
    make check
    exit 0
fi
printf '\nJe suis dans le terminal Linux du laboratoire 3.\n'
printf 'Je peux lancer : make test, make flow, make prove, make diagnostic.\n'
printf 'Je reviens au terminal Mac avec : exit\n\n'
export PS1='lab3-linux:\w\$ '
exec bash --noprofile --norc
