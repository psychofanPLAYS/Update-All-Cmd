# Update All Cmd

Amber terminal-styled, local-first updater for Linux developer workstations and brave beginners who installed half the internet and now want help cleaning it up.

![Bash CLI](https://img.shields.io/badge/Bash-CLI-121011?logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-workstations-FCC624?logo=linux&logoColor=111111)
![License: MIT](https://img.shields.io/badge/license-MIT-0f766e)
![Dry run](https://img.shields.io/badge/dry--run-supported-2563eb)
![Local first](https://img.shields.io/badge/local--first-no%20cloud%20upload-16a34a)

So you installed OpenClaw, Hermes, a pile of npm tools, maybe some Python CLIs, maybe Homebrew on Linux, and now the terminal looks like it is speaking electricity? `update-all` is here to help.

`update-all` is a standalone Bash command that explains and updates the developer tools people actually use: system packages, desktop package managers, Node tooling, global CLIs, Python/Rust tools, Homebrew/Linuxbrew, and GitHub extensions.

It is meant for Ubuntu/Linux developer workstations. It is not a fleet patching system or production server automation.

```bash
./install.sh
update-all --dry-run
update-all
```

## What You Get

- One memorable command for many update surfaces.
- Plain-English explanations before scary-looking package-manager output.
- The original orange block `UPDATE ALL` intro.
- Thin readable section titles with restrained amber motion.
- A compact dark-teal binary divider under the opening art.
- Color-coded streamed logs for warnings, failures, updates, removals, funding notices, and important package names.
- Prominent package/tool cards with heavier package names and clear purpose notes before noisy updater output.
- Loud `VERSION BEFORE` and `VERSION AFTER` rows where the tool can measure them.
- Pending update lists before supported upgrade steps, including old -> new versions where the package manager exposes them cleanly.
- Dimmed normal package-manager chatter so live output stops becoming a wall of white text.
- Distinct apt colors for repository traffic versus summary lines such as `Fetched ...` and `Reading package lists...`.
- Before/after tracking and a final receipt summary.
- One receipt-level note explains metadata/source limits, instead of repeating source text on every package card.
- Quiet modes for logs, scripts, accessibility, and plain terminals.
- Public-safe configuration: no passwords, tokens, or private machine values stored in the repo.

## Who This Is For

This is for people who are learning by doing:

- You copied install commands from docs, Discord, GitHub, or a YouTube tutorial.
- You have `npm`, `pipx`, `uv`, `brew`, `gh`, `snap`, or random CLIs installed and you are not sure what updates what.
- You want the terminal to explain itself instead of dumping a wall of text and expecting you to already know everything.
- You want local-first tooling that teaches you what is happening before it changes your machine.

It is also useful for experienced developers who want a quick workstation update sweep with a readable receipt.

## Preview

```text
 ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗      █████╗ ██╗     ██╗
 ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝     ██╔══██╗██║     ██║
 ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗       ███████║██║     ██║
 ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝       ██╔══██║██║     ██║
 ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗     ██║  ██║███████╗███████╗
  ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚═╝  ╚═╝╚══════╝╚══════╝
      01110101  01110000  01100100  01100001  01110100  01100101
      00101101  01100001  01101100  01101100  00101101  00101110

▶  update-all

┏┓╻┏━┓┏┳┓
┃┗┫┣━┛┃┃┃
╹ ╹╹  ╹ ╹

── codex
   ▌ OPENAI CODEX CLI
   package          @openai/codex@latest
   ▶ VERSION BEFORE  /path/to/codex codex-cli 0.x
   purpose          OpenAI local coding-agent CLI for reading code, editing files, running checks, and helping ship changes.

$ npm install -g @openai/codex@latest --no-fund
   ▶ VERSION AFTER   /path/to/codex codex-cli 0.x
   result           UNCHANGED

== RECEIPT ==
receipt summary    0 updated  5 ok  13 unchanged  4 skipped  0 failed
STEP                          RESULT      BEFORE                        AFTER
codex                         = UNCHANGED  /path/to/codex 0.x            /path/to/codex 0.x
```

The real run streams package-manager output live. Use `--no-anim` or `--no-color` when you want simpler logs.

## Install

Run from the repository:

```bash
./bin/update-all --dry-run
```

Install into your user-local `PATH`:

```bash
./install.sh
update-all --dry-run
```

If `~/.local/bin` is not on your `PATH`, add it to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

```bash
update-all [options]
```

| Option | What it does |
| --- | --- |
| `--dry-run` | Prints the update commands and report path without intentionally applying updates. |
| `--no-anim` | Disables animated header/scanner effects. |
| `--no-color` | Disables ANSI color output. |
| `-h`, `--help` | Shows command help. |

Common flows:

```bash
# See the updater plan first
update-all --dry-run

# Run the workstation update sweep
update-all

# Quiet log-friendly output
update-all --no-anim --no-color

# Safest demo/smoke-test mode
update-all --dry-run --no-anim --no-color
```

## Supported Update Surfaces

Missing tools are reported as `SKIP`, not treated as fatal.

Current pending-update list support:

| Tool | Pending list source |
| --- | --- |
| `apt` | `apt list --upgradable`, parsed as package old -> new |
| `npm globals` | `npm outdated -g`, parsed as package current -> latest |
| Homebrew/Linuxbrew | `brew outdated --verbose`, parsed where Homebrew output includes old/new |

Other package managers still stream their native update output and are tracked in the final receipt. Broader registry-backed package discovery belongs to planned Safety Coach Mode.

| Tool | Area |
| --- | --- |
| `dpkg` / `apt` | Debian/Ubuntu package health, index updates, upgrades, opt-in cleanup |
| `snap` | Snap package refreshes |
| `flatpak` | Flatpak app updates |
| `node` / `update-node` | Local Node.js runtime upkeep |
| `corepack` | Node package-manager shims |
| `pnpm` | pnpm package-manager activation/update |
| `yarn` | Yarn package-manager activation/update |
| `npm` globals | Global npm CLIs |
| Claude Code | Anthropic's terminal coding assistant CLI |
| Codex | OpenAI's local coding-agent CLI |
| Homebrew/Linuxbrew | Brew-managed developer tools |
| `uv` | Python package/tool manager |
| `pipx` | Isolated Python CLI apps |
| `rustup` | Rust toolchains |
| `gh extension` | GitHub CLI extensions |

## Configuration

### Terminal Output

```bash
UPDATE_ALL_ANIM=0 update-all
UPDATE_ALL_COLOR=0 update-all
update-all --no-anim --no-color
```

### Corepack Timeout

Corepack steps are bounded so they do not hang forever:

```bash
UPDATE_ALL_COREPACK_TIMEOUT=120s update-all
```

### Optional Sudo Secret Helper

`update-all` does not store sudo passwords. If your workstation already has a compatible external `secret` helper, you can point the script at its key name:

```bash
export UPDATE_ALL_SUDO_SECRET_KEY="your-key-name"
```

Keep secret values out of shell history, committed files, screenshots, and logs. If this variable is not configured, normal interactive `sudo` behavior may apply.

## Safety And Privacy

`update-all` is designed to be visible and boringly safe.

- No cloud upload by default.
- No telemetry layer.
- Package managers still make their normal network requests to download updates; `update-all` just keeps the control flow local and visible.
- No tokens, API keys, or passwords stored in this repository.
- No replacement for first-party package managers; it calls them.
- Cleanup/removal steps ask first in live mode and skip if the terminal is not interactive.
- Apt cleanup uses apt-owned cleanup only: `apt-get autoremove --purge -y`, `apt-get autoclean`, and `apt-get clean`.
- `Hermes Agent` is intentionally skipped to avoid surprise-upgrading active agent workflows.
- Best for personal developer workstations, not production servers.

For production machines, use purpose-built patching, configuration-management, maintenance-window, and rollback tooling.

## Planned Safety Coach Mode

This is the next big direction for the project.

The goal is not "delete scary things automatically." The goal is:

1. Detect tools and package managers you have installed.
2. Pull package descriptions from trusted package-manager or registry metadata instead of hardcoding every package explanation.
3. Explain what each package is in plain language.
4. Flag packages that are deprecated, removed from their registry, reported malicious by trusted vulnerability databases, failing audits, or otherwise suspicious.
5. Ask before touching special stacks such as OpenClaw, Hermes, or other agent runtimes.
6. Ask again before removing anything.
7. Show the exact command it is about to run.
8. Leave a receipt so you can learn from what happened.

Safety Coach Mode should use first-party or well-known security sources where possible, such as package-manager metadata, registry deprecation flags, audit commands, and vulnerability databases such as OSV. It should never auto-remove a package just because a warning appeared.

Planned examples:

```text
OpenClaw detected.
This looks like an agent/runtime project, not a normal npm package.
Do you want update-all to check it, skip it, or leave it alone forever?
```

```text
Package flagged:
left-pad-example
Reason: package is deprecated, missing from registry metadata, or reported by a trusted advisory source.
Recommended action: review first. Do not auto-remove.
```

Removal will stay opt-in. A beginner-friendly tool should protect people from accidents, not create faster accidents.

## Verification

Run these before committing changes:

```bash
bash -n bin/update-all
bash -n install.sh
./bin/update-all --help
./bin/update-all --dry-run --no-anim --no-color
cspell README.md bin/update-all install.sh
git diff --check
```

`cspell` is optional for users, but useful for maintainers:

```bash
npm install -g cspell@latest --no-fund
```

## Project Layout

```text
.
|-- bin/
|   `-- update-all
|-- cspell.json
|-- install.sh
|-- LICENSE
|-- tests/
|   `-- test-output-format.sh
`-- README.md
```

Primary command: [bin/update-all](bin/update-all)

## Project Status

Personal utility, public-safe prototype. The command is useful today, but the repo is still early: there is no CI workflow yet and full integration tests should use mocked package-manager commands.

## Roadmap

- Add mocked integration tests for package-manager flows.
- Add Safety Coach Mode for deprecated/removed/advisory package flagging.
- Add interactive prompts for OpenClaw, Hermes, and other agent/runtime stacks.
- Add optional JSON or Markdown run receipts.
- Add a screenshot or asciinema demo for the README.
- Add clearer per-manager failure summaries.
- Add machine-readable output for agent/script workflows.
- Add safer detection for unusual distributions and package-manager variants.

## References

- GitHub recommends README files explain why a project is useful, what people can do with it, and how to use it.
- This README follows the current landing-page pattern: fast value proposition, quick start above the fold, truthful badges, visual preview, safety notes, and verification commands.
- npm package descriptions used by the script are intentionally short and source-aware where package metadata is available.

## License

MIT. See [LICENSE](LICENSE).
