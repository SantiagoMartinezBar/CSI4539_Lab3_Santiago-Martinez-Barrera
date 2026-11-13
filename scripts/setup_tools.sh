#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
tools=${LAB3_TOOLS_DIR:-$root/.tools}
if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
    echo 'Je dois utiliser ce script sur Linux x86_64 (machine du cours).'
    exit 1
fi
mkdir -p "$tools/settings"
if [[ ! -x $tools/bin/alr ]]; then
    curl -fsSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o "$tools/alr.zip"
    printf '%s  %s\n' e3b32cb0afe981b23d1a68da77452cf81ee1d82de8ebaf01c5e233be8b463fbe "$tools/alr.zip" | sha256sum -c -
    unzip -q "$tools/alr.zip" -d "$tools"
fi
if [[ ! -x $tools/prefix/bin/gnatprove || ! -x $tools/prefix/bin/gprbuild ]]; then
    "$tools/bin/alr" -s "$tools/settings" -n install --prefix="$tools/prefix" \
        gnat_native=16.1.0 gprbuild=26.0.1 gnatprove=16.1.0
fi
printf 'export PATH=%q:%q:$PATH\n' "$tools/prefix/bin" "$tools/bin" > "$tools/activate.sh"
export PATH="$tools/prefix/bin:$tools/bin:$PATH"
gnatprove --version
gprbuild --version
echo "Je peux activer la chaîne avec : source $tools/activate.sh"
