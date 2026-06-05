#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$HOME/.local/bin/update-all"

mkdir -p "$HOME/.local/bin"
ln -sfn "$repo_dir/bin/update-all" "$target"
chmod +x "$repo_dir/bin/update-all"

printf 'Installed update-all -> %s\n' "$target"
printf 'Try: update-all --dry-run\n'
