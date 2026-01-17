#!/usr/bin/env bash

set -euo pipefail

# Determine repository root (one level up from this script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/home"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "ERROR: Source directory ${SOURCE_DIR} does not exist." >&2
  exit 1
fi

echo "Syncing dotfiles from ${SOURCE_DIR} to ${HOME} ..."

# Collect all regular files under SOURCE_DIR, preserving paths relative to it.
SOURCE_FILES=()
while IFS= read -r -d '' src; do
  SOURCE_FILES+=("${src}")
done < <(find "${SOURCE_DIR}" -type f -print0)

if [[ ${#SOURCE_FILES[@]} -eq 0 ]]; then
  echo "No files found in ${SOURCE_DIR}. Nothing to sync."
  exit 0
fi

for src in "${SOURCE_FILES[@]}"; do
  rel_path="${src#${SOURCE_DIR}/}"
  dest="${HOME}/${rel_path}"

  if [[ -e "${dest}" ]]; then
    read -r -p "${dest} exists. Overwrite? [y/N] " answer
    case "${answer}" in
      [Yy]*)
        echo "  - Overwriting ${dest}"
        cp "${src}" "${dest}"
        ;;
      *)
        echo "  - Skipping ${dest}"
        ;;
    esac
  else
    echo "  - Creating ${dest}"
    mkdir -p "$(dirname "${dest}")"
    cp "${src}" "${dest}"
  fi
done

echo "Done."

