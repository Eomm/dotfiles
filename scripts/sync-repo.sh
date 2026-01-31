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
  "${HOME}/.copilot/skills/"
  "${HOME}/.gnupg/gpg-agent.conf"
)

for src in "${SOURCE_FILES[@]}"; do
  # If the source ends with a slash, treat it as a directory
  if [[ "${src}" == */ ]]; then
    dir="${src%/}"
    if [[ -d "${dir}" ]]; then
      # Preserve path relative to $HOME for the directory
      rel_dir="${dir#${HOME}/}"
      dest_dir="${TARGET_DIR}/${rel_dir}"
      mkdir -p "${dest_dir}"
      printf "  - ${GREEN}Copying directory contents${RESET} %s/ -> %s/\n" "${dir}" "${dest_dir}"
      # Copy all files inside the directory, preserving structure
      cp -R "${dir}/." "${dest_dir}/"
    else
      printf "  - ${YELLOW}WARNING${RESET}: %s is not a directory, %sskipping%s\n" "${dir}" "${BLUE}" "${RESET}" >&2
    fi
  elif [[ -f "${src}" ]]; then
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

