#!/usr/bin/env bash

set -euo pipefail

# Determine repository root (one level up from this script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET_DIR="${REPO_ROOT}/home"

mkdir -p "${TARGET_DIR}"

echo "Syncing dotfiles into ${TARGET_DIR} ..."

SOURCE_FILES=(
  "${HOME}/.zshrc"
  "${HOME}/.gitconfig"
  "${HOME}/.gitignore"
)

for src in "${SOURCE_FILES[@]}"; do
  if [[ -f "${src}" ]]; then
    base_name="$(basename "${src}")"
    dest="${TARGET_DIR}/${base_name}"
    echo "  - Copying ${src} -> ${dest}"
    cp "${src}" "${dest}"
  else
    echo "  - WARNING: ${src} does not exist, skipping" >&2
  fi
done

echo "Done."

