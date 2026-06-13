# Update All Handoff

Last updated: 2026-06-07 EDT

## Project

`update-all` is a Bash CLI for beginner-friendly Linux workstation updates.
It lives at `/home/clawski/_Programs/Update-All-Cmd`, with the installed command
symlinked at `/home/clawski/.local/bin/update-all`.

## Current Product Direction

- Keep it local-first and transparent.
- Do not replace package managers; call first-party/package-manager commands.
- Teach the user what is happening before scary output starts.
- Favor explicit prompts over surprise removal.
- Keep the public repo free of machine secrets and private paths in committed code.

## Current UX Contract

- Intro title art uses the current two-line binary divider (`update` on top, centered `all`), with no old plain-text `UPDATE ALL` line.
- Dark teal binary divider under the title.
- Large section banners with optional animation.
- Interactive section progress strips are 45 cells wide, up from the old 30-cell strip, and stay on the amber/orange brand color.
- Section headers include one blank line above and one blank line below the divider so each step has readable spacing while keeping the loading strip close.
- Prominent package/tool cards:
  - big uppercase unit title
  - bold package value
  - `version before` near the top, with a muted teal label and only the actual version value highlighted
  - separate quieter `path` row when the version probe includes an executable path
  - `version after` as the final outcome row after `result` and optional `note`, with a slightly brighter label than `version before`
  - muted purpose text
  - visible `result` and optional `note`
- Normal package-manager chatter is dimmed so logs stop becoming a wall of white.
- Apt repository lines (`Hit:`, `Get:`, `Ign:`) and progress lines (`Fetched`,
  `Reading package lists`) use separate colors.
- Missing tools still print cards and end as `SKIP` so beginners learn what they are.
- Final section is `RECEIPT`, with counts and per-step `before:`, `after:`, and `note:` detail rows.
- Claude Code and Codex use their first-party updaters (`claude update`, `codex update`) instead of relying on npm install to refresh the active binaries.

## Pending Update Lists

Implemented:

- `apt`: `apt list --upgradable`, parsed as package old -> new.
- `npm globals`: `npm outdated -g --depth=0`, parsed as current -> latest.
- Homebrew/Linuxbrew: `brew outdated --verbose`, parsed where brew output exposes old/new.

Not yet implemented:

- Snap, Flatpak, uv, pipx, rustup, and gh extension old -> new preflight lists.
  Their native output is still streamed and receipt-tracked.

## Cleanup Behavior

Cleanup is split into two explicit prompts. Removal stays opt-in and visible.

The first prompt is apt-owned only and gated by a large `APT CLEANUP?` prompt.
When the user answers yes, it runs:

```bash
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
```

The second prompt is `WORKSTATION CACHE CLEANUP?`. When the user answers yes, it removes only rebuildable caches and old update leftovers:

```bash
npm cache clean --force
rm -rf ~/.npm/_npx
pip3 cache purge
brew cleanup -s
timeout 20s uv cache prune
rm -rf selected ~/.cache tool/browser-automation caches
find ~ -xdev -type d \( -name __pycache__ -o -name .pytest_cache \) -prune -exec rm -rf -- {} +
rm -rf ~/.codex/.tmp/plugins ~/.codex/.tmp/plugins.sha
sudo remove disabled snap revisions
sudo journalctl --vacuum-size=512M
```

Do not delete archives, models, databases, project data, installed runtimes, or active virtualenvs from this cleanup path.

## Safety Coach Scope

Safety Coach Mode is planned, not shipped.

It should:

- Pull package descriptions from trusted package-manager/registry metadata.
- Use trusted advisory sources such as registry deprecation flags, audit commands,
  and OSV-style vulnerability databases.
- Flag deprecated, removed, suspicious, or advisory-hit packages.
- Ask before touching OpenClaw, Hermes, agent runtimes, or project directories.
- Queue possible removals for a final opt-in review.
- Show the exact command before deleting anything.
- Never auto-delete because a warning appeared.

## Verification Commands

Run these before commit/push:

```bash
bash -n bin/update-all
bash -n install.sh
bash tests/test-output-format.sh
./bin/update-all --help
./bin/update-all --dry-run --no-anim --no-color
cspell README.md bin/update-all install.sh
git diff --check
```

Also verify the installed command path when changing install-facing behavior:

```bash
bash -n /home/clawski/.local/bin/update-all
update-all --dry-run --no-anim --no-color
```

## Known Limits

- Terminal font size cannot be changed per line from Bash; “bigger” means bold,
  uppercase, spacing, symbols, and stronger colors.
- Animated bars and spinner effects only show in live interactive TTY runs.
- `--no-anim` and dry-run intentionally suppress animations.
- Full malicious-package discovery is not safe to bolt on without a proper
  Safety Coach design and trusted-source policy.
