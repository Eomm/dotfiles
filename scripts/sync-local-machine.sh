#!/usr/bin/env bash

set -euo pipefail

# Determine repository root (one level up from this script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/home"

# Basic colors for readability
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
BOLD="\033[1m"
RESET="\033[0m"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  printf "${RED}ERROR${RESET}: Source directory %s does not exist.\n" "${SOURCE_DIR}" >&2
  exit 1
fi

printf "${BOLD}Syncing dotfiles from${RESET} ${YELLOW}%s${RESET} to ${GREEN}%s${RESET} ...\n" "${SOURCE_DIR}" "${HOME}"

# Collect all regular files under SOURCE_DIR, preserving paths relative to it.
SOURCE_FILES=()
while IFS= read -r -d '' src; do
  SOURCE_FILES+=("${src}")
done < <(find "${SOURCE_DIR}" -type f -print0)

if [[ ${#SOURCE_FILES[@]} -eq 0 ]]; then
  printf "${YELLOW}No files found in %s. Nothing to sync.${RESET}\n" "${SOURCE_DIR}"
  exit 0
fi

for src in "${SOURCE_FILES[@]}"; do
  rel_path="${src#${SOURCE_DIR}/}"
  dest="${HOME}/${rel_path}"

  if [[ -e "${dest}" ]]; then
    read -r -p "${dest} exists. Overwrite? [y/N] " answer
    case "${answer}" in
      [Yy]*)
        printf "  - ${YELLOW}Overwriting${RESET} %s\n" "${dest}"
        cp "${src}" "${dest}"
        ;;
      *)
        printf "  - ${BLUE}Skipping${RESET} %s\n" "${dest}"
        ;;
    esac
  else
    printf "  - ${GREEN}Creating${RESET} %s\n" "${dest}"
    mkdir -p "$(dirname "${dest}")"
    cp "${src}" "${dest}"
  fi
done
printf "${GREEN}Done.${RESET}\n"

