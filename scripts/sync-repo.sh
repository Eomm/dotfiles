#!/usr/bin/env bash

set -euo pipefail

# Determine repository root (one level up from this script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET_DIR="${REPO_ROOT}/home"

# Basic colors for readability
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
BOLD="\033[1m"
RESET="\033[0m"

mkdir -p "${TARGET_DIR}"

printf "${BOLD}Syncing dotfiles into${RESET} ${YELLOW}%s${RESET} ...\n" "${TARGET_DIR}"

SOURCE_FILES=(
  "${HOME}/.zshrc"
  "${HOME}/.gitconfig"
  "${HOME}/workspace/_experiments/.gitconfig"
  "${HOME}/.gitignore"
)

for src in "${SOURCE_FILES[@]}"; do
  if [[ -f "${src}" ]]; then
    # Preserve path relative to $HOME so nested files (e.g. ~/workspace/_experiments/.gitconfig)
    # are stored under the same structure inside ${TARGET_DIR}.
    rel_path="${src#${HOME}/}"
    dest="${TARGET_DIR}/${rel_path}"
    mkdir -p "$(dirname "${dest}")"
    printf "  - ${GREEN}Copying${RESET} %s -> %s\n" "${src}" "${dest}"
    cp "${src}" "${dest}"
  else
    printf "  - ${YELLOW}WARNING${RESET}: %s does not exist, %sskipping%s\n" "${src}" "${BLUE}" "${RESET}" >&2
  fi
done

printf "${GREEN}Done.${RESET}\n"

