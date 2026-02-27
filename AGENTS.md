# AGENTS.md

This file is a working guide for humans/agents who work in this repository.

## Purpose

- This repository contains configurations intended to be deployed as symlinks from `~/dotfiles` into `HOME`.
- The main entry point is [`install.sh`](./install.sh).
- Target OSes are macOS and Linux (primarily `apt-get` based environments).

## Key Files

- `install.sh`: Main setup script. Creates links, installs dependencies, and runs OS-specific logic.
- `readme.md`: Installation steps and operational notes.
- `.config/`, `.local/`: Configuration directories symlinked individually under `HOME`.

## Principles for Changes

- Prioritize not breaking existing environments, and keep all operations idempotent (safe to re-run).
- Preserve the non-stop-on-failure design (`run_step`) and integrate new steps into the same flow.
- Avoid changes with high impact on existing user environments (for example default shell changes or destructive operations).
- Keep network install steps minimal and use only trustworthy official sources.

## `install.sh` Editing Rules

- Keep the Bash assumptions (`#!/usr/bin/env bash` + `set -euo pipefail`).
- Use verb-first function names consistently, and wrap side-effecting logic in functions called from `run_step`.
- When adding a new install step:
  - Split responsibilities so each function has a single role.
  - If failure is acceptable, add it to the final execution list with `run_step "name" function_name`.
  - Add branching so Linux environments without `sudo` do not break.
- Maintain the current link-update policy using `ln -sfn`, and avoid changes that could destroy existing files.

## Validation Steps

- Syntax check:
  - `bash -n install.sh`
- Static analysis when possible:
  - `shellcheck install.sh`
- If a change affects installation behavior:
  - Update the corresponding steps/explanations in `readme.md` at the same time.

## Documentation Policy

- Treat `readme.md` as the source of truth for user-facing instructions, and keep it in sync whenever behavior changes.
- Do not add environment-specific temporary notes directly to the README; only include them after confirming necessity.
