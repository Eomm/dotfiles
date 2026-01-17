# dotfiles

Personal dotfiles managed via this git repo.

## Layout

- [home/](home/) – tracked dotfiles that should live in your `$HOME` (e.g. `.zshrc`, `.gitconfig`).
- [scripts/](scripts/) – helper scripts to sync between your machine and this repo.

## Scripts

- [scripts/sync-repo.sh](scripts/sync-repo.sh)
  - Copies selected dotfiles from `$HOME` into [home/](home/).
  - Usage (from repo root):

    ```bash
    scripts/sync-repo.sh
    ```

- [scripts/sync-local-machine.sh](scripts/sync-local-machine.sh)
  - Copies files from [home/](home/) into your `$HOME` directory, preserving their paths under `home/`.
  - Prompts before overwriting existing files.
  - Usage (from repo root):

    ```bash
    scripts/sync-local-machine.sh
    ```

## Typical workflow

1. Edit dotfiles locally in `$HOME`.
2. Run `scripts/sync-repo.sh` to pull changes into the repo.
3. Commit and push.
4. On another machine, clone the repo and run `scripts/sync-local-machine.sh` to apply dotfiles.
