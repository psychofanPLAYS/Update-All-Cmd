# CLAUDE.md — Update-All-Cmd

Single-file Bash workstation updater for Ubuntu/Linux dev boxes: one `update-all` command that explains
and updates apt/snap/npm/bun/pipx/uv/cargo/brew/gh/editor-ext/firmware and agent CLIs (`claude update`,
`codex update`), with an amber TUI, dry-run, upfront safety prompts, and a receipt summary.
Personal-workstation tool — **not** fleet/server automation.

## Architecture
- `bin/update-all` — the whole program (~74KB Bash). Everything lives here.
- `install.sh` — symlinks `bin/update-all` into `~/.local/bin/`.
- `tests/test-output-format.sh` — output-formatting smoke test. `docs/` = handoff notes + preview SVG.

## Commands
- Run: `./bin/update-all --dry-run` then `./bin/update-all`. Flags: `--dry-run`, `--no-anim`, `--no-color`, `-h`.
- Install: `./install.sh` (then ensure `~/.local/bin` is on PATH).
- Quality gate (mirror CI before committing):
  - `bash -n bin/update-all install.sh` (syntax)
  - `shellcheck bin/update-all install.sh tests/test-output-format.sh`
  - `bash tests/test-output-format.sh`
  - `./bin/update-all --dry-run --no-anim --no-color`
  - `cspell ...` (optional; `npm i -g cspell` — config in `cspell.json`)

## Gotchas
- **Public-safe repo.** CI scans for leaked secrets/PII — never commit real home-directory paths,
  private network IPs, API tokens, access keys, or screenshots containing credentials. Sanitize before pushing.
- Missing tools report `SKIP`, never fatal. Risky/cleanup choices are asked **upfront** so the live sweep
  runs unattended — preserve that pattern. Keep destructive/cleanup steps opt-in.
