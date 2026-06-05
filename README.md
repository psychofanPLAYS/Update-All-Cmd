# Update All Cmd

Cyberpunk-flavored, local-first updater for Linux developer workstations.

`update-all` runs a full update sweep across the usual developer stack: apt, snap, flatpak, Node, corepack, pnpm, yarn, npm globals, Claude Code, Codex, Homebrew, uv, pipx, rustup, and GitHub CLI extensions.

## Why It Exists

Developer machines collect package managers. Updating them one by one is slow, easy to forget, and easy to misunderstand when tools print noisy funding notices or version messages.

`update-all` gives the update run one clear command, visible phases, version before/after tracking, and a final receipt.

## What It Does

- Shows a cyberpunk terminal intro, title zones, scanners, and progress-style animations.
- Color-codes streamed updater logs so installs, updates, warnings, failures, removals, funding notices, and important package names are easier to spot.
- Prints short tool/package cards before noisy steps so you can see what is being updated and why.
- Detects missing tools and records them as `SKIP` instead of failing the whole run.
- Tracks before/after versions where useful.
- Keeps sudo alive during the run after one authentication step.
- Uses an optional existing `secret` helper for sudo on hosts that already have it.
- Supports `--dry-run`, `--no-anim`, and `--no-color` for safer testing and CI output.

## First Run

```bash
./install.sh
update-all --dry-run
update-all
```

## Common Commands

```bash
update-all
update-all --dry-run
update-all --no-anim
update-all --no-color
UPDATE_ALL_COREPACK_TIMEOUT=120s update-all
```

## Example Output

```text
UPDATE ALL  //  CYBERPUNK SAFE APP
[##################################] booting update nexus
[+] SYSTEM ONLINE
>> apt update
| current  0 upgradable
| does     Ubuntu/Debian system package manager; updates OS packages and security fixes.
>> apt upgrade
[+] REPORT ONLINE
STEP                          RESULT      BEFORE                       AFTER
apt update                    OK OK
apt upgrade                   = UNCHANGED  0 upgradable                 0 upgradable
```

Package descriptions are intentionally short. npm package descriptions come from npm registry metadata; system-tool descriptions come from local package metadata or the tool's public role.

## How It Works

The command is a standalone Bash script in `bin/update-all`. It avoids storing credentials and does not require a service or daemon.

Each update action is wrapped with a small reporting layer:

- `OK` means the command exited successfully.
- `UPDATED` means before/after values changed.
- `UNCHANGED` means before/after values were available and equal.
- `SKIP` means the tool is not installed or intentionally excluded.
- `FAIL` means one step failed; the report shows which one.

## Requirements

- Bash
- Standard Unix tools: `sed`, `awk`, `tr`, `date`
- Optional: `sudo`, `timeout`, `tput`
- Optional package managers depending on your machine: apt, snap, flatpak, npm, brew, uv, pipx, rustup, gh

## Configuration

```bash
UPDATE_ALL_COREPACK_TIMEOUT=90s
UPDATE_ALL_ANIM=0
UPDATE_ALL_COLOR=0
UPDATE_ALL_SUDO_SECRET_KEY=my-sudo-secret
```

## Safety / Privacy Notes

- No API keys, tokens, passwords, or machine-specific secrets are stored in this repository.
- The script may call an existing `secret get "$UPDATE_ALL_SUDO_SECRET_KEY"` helper if you configure one, but that helper is optional and external to this project.
- `Hermes Agent` is intentionally not updated here, because changing an active agent runtime can break ongoing workflows.
- Use `update-all --dry-run` before a real run if you are adapting the command to a new machine.

## Project Status

Personal utility, public-safe prototype. It is best suited for Ubuntu/Linux developer machines and should be reviewed before use on production servers.

## Roadmap

- Optional JSON receipt output for agents.
- Optional log file output under `~/.local/state/update-all/`.
- Screenshot or asciinema demo for the GitHub README.
- Per-step allow/deny configuration.

## License

MIT
