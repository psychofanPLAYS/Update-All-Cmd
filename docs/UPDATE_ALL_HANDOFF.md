# Update All Handoff

Last updated: 2026-06-07 EDT

## Project

`update-all` is a Bash CLI for beginner-friendly Linux workstation updates.
Clone it anywhere you keep small tools, then use `install.sh` to place an
`update-all` command on your PATH.

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
- `CLEANUP NEXT STEPS` appears at the end of the receipt and summarizes apt cleanup, workstation cache cleanup, and the interactive cleanup rule for live runs.
- Claude Code and Codex use their first-party updaters (`claude update`, `codex update`) instead of relying on npm install to refresh the active binaries.
- `COVERAGE PREFLIGHT` appears before update work and tells the user which installed surfaces will be checked, which common surfaces are skipped, and which categories remain manual by design.
- Command output goes through a defensive redactor for common secret shapes before printing.
- Internal compound shell commands use `env -u BASH_ENV -u ENV bash --noprofile --norc -c ...` so update-all does not source shell startup files for its own control flow.
- `docs/terminal-preview.svg` is a sanitized colored SVG generated from a real `update-all --dry-run` terminal capture; keep it visually faithful when the CLI's first screen changes.

## Pending Update Lists

Implemented:

- `apt`: `apt list --upgradable`, parsed as package old -> new.
- `npm globals`: `npm outdated -g --depth=0`, parsed as current -> latest.
- Homebrew/Linuxbrew: `brew outdated --verbose`, parsed where brew output exposes old/new.

Not yet implemented as old -> new preflight tables:

- Snap, Flatpak, Bun, uv, pipx, rustup, cargo-installed CLIs, gh extensions,
  editor extensions, and firmware old -> new preflight lists. Their native
  output is still streamed and receipt-tracked.

## Coverage Behavior

`update-all` should update installed common workstation surfaces, then explain
manual boundaries instead of silently touching risky project-specific areas.

Currently handled or explicitly skipped:

- dpkg/apt, snap, flatpak, Node/update-node, corepack, pnpm, yarn, Bun, npm
  globals, Claude Code, Codex, Homebrew/Linuxbrew, uv, pipx, rustup,
  cargo-installed CLIs when `cargo-install-update` already exists, GitHub CLI
  extensions, VS Code/VSCodium extensions, firmware via `fwupdmgr`, apt cleanup,
  and workstation cache cleanup.

Manual by design:

- Project repositories, active agent runtimes, containers/images, conda
  environments, large LLM weights, and shell profile edits.

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

Do not delete archives, LLM weights, databases, project data, installed runtimes, or active virtualenvs from this cleanup path.

## Sudo And Secret Boundary

- `update-all` stores no sudo password, token, API key, or private value in the
  repository.
- If `UPDATE_ALL_SUDO_SECRET_KEY` is set, the external `secret` helper value is
  passed to `sudo -S` through stdin and the prompt is blanked; the value is not
  printed by update-all.
- All streamed command output passes through redaction for common OpenAI,
  GitHub, Slack, AWS, private-key-header, and `TOKEN=value` / `PASSWORD=value`
  shapes before printing.
- Compound shell commands remove `BASH_ENV`/`ENV` and use
  `bash --noprofile --norc`; do not replace this with `bash -lc`.
- This redaction is a guardrail, not a reason to store raw secrets in shell
  profiles or committed files.

## Safety Coach Scope

Safety Coach Mode is planned, not shipped.

One narrow slice is now shipped for Homebrew taps: before `brew update`,
`update-all` checks `brew tap-info` for Homebrew's `Untrusted` marker, explains
that this is a trust/provenance warning rather than proof of malware or an
expired-license problem, gives the gold-standard recommendation, shows the
exact `brew untap ...` command, and asks before untapping anything.

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
cspell README.md bin/update-all install.sh docs/UPDATE_ALL_HANDOFF.md cspell.json tests/test-output-format.sh CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md .github/*.md .github/*.yml .github/**/*.md .github/**/*.yml
git diff --check
```

Also verify the installed command path when changing install-facing behavior:

```bash
bash -n ~/.local/bin/update-all
update-all --dry-run --no-anim --no-color
```

## Known Limits

- Terminal font size cannot be changed per line from Bash; “bigger” means bold,
  uppercase, spacing, symbols, and stronger colors.
- Animated bars and spinner effects only show in live interactive TTY runs.
- `--no-anim` and dry-run intentionally suppress animations.
- Full malicious-package discovery is not safe to bolt on without a proper
  Safety Coach design and trusted-source policy.
