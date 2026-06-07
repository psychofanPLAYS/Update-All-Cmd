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

- Orange `UPDATE ALL` title art.
- Dark teal binary divider under the title.
- Large section banners with optional animation.
- Prominent package/tool cards:
  - big uppercase unit title
  - bold package value
  - loud `VERSION BEFORE`
  - rust-orange `purpose`
  - loud `VERSION AFTER` when measurable
  - visible `result` and optional `note`
- Normal package-manager chatter is dimmed so logs stop becoming a wall of white.
- Apt repository lines (`Hit:`, `Get:`, `Ign:`) and progress lines (`Fetched`,
  `Reading package lists`) use separate colors.
- Missing tools still print cards and end as `SKIP` so beginners learn what they are.
- Final section is `RECEIPT`, with counts and a before/after table.

## Pending Update Lists

Implemented:

- `apt`: `apt list --upgradable`, parsed as package old -> new.
- `npm globals`: `npm outdated -g --depth=0`, parsed as current -> latest.
- Homebrew/Linuxbrew: `brew outdated --verbose`, parsed where brew output exposes old/new.

Not yet implemented:

- Snap, Flatpak, uv, pipx, rustup, and gh extension old -> new preflight lists.
  Their native output is still streamed and receipt-tracked.

## Cleanup Behavior

Cleanup is intentionally apt-owned only and gated by a large `APT CLEANUP?` prompt.
When the user answers yes, it runs:

```bash
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
```

Do not add random cache deletion without a separate prompt and rollback story.

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
