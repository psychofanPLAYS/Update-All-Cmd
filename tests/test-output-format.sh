#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPDATE_ALL="$ROOT_DIR/bin/update-all"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

output="$("$UPDATE_ALL" --dry-run --no-anim --no-color)"

printf '%s\n' "$output" | grep -F "OPENAI CODEX CLI" >/dev/null \
  || fail "expected prominent uppercase unit title for Codex"

printf '%s\n' "$output" | grep -F "claude update" >/dev/null \
  || fail "expected Claude Code to use its first-party updater"

printf '%s\n' "$output" | grep -F "codex update" >/dev/null \
  || fail "expected Codex CLI to use its first-party updater"

if printf '%s\n' "$output" | grep -F "npm install -g @anthropic-ai/claude-code@latest" >/dev/null; then
  fail "Claude Code should not be updated through npm install"
fi

if printf '%s\n' "$output" | grep -F "npm install -g @openai/codex@latest" >/dev/null; then
  fail "Codex CLI should not be updated through npm install"
fi

printf '%s\n' "$output" | grep -F "version before" >/dev/null \
  || fail "expected readable version before row"

printf '%s\n' "$output" | grep -F "after" >/dev/null \
  || fail "expected readable stacked version outcome rows"

printf '%s\n' "$output" | grep -F "path" >/dev/null \
  || fail "expected executable path rows when version output includes a path"

if printf '%s\n' "$output" | grep -F "version = " >/dev/null; then
  fail "version rows should show the version value directly, without noisy prefixes"
fi

if printf '%s\n' "$output" | grep -F "VERSION BEFORE" >/dev/null; then
  fail "version labels should not be shouty uppercase"
fi

printf '%s\n' "$output" | grep -F "purpose" >/dev/null \
  || fail "expected purpose label instead of does"

if printf '%s\n' "$output" | grep -F "does" >/dev/null; then
  fail "legacy does label should not be present"
fi

printf '%s\n' "$output" | grep -F "FLATPAK APPS" >/dev/null \
  || fail "expected missing tools to still show public-safe package cards"

printf '%s\n' "$output" | grep -F "result" >/dev/null \
  || fail "expected result rows for skipped tools"

if printf '%s\n' "$output" | grep -F "mode" >/dev/null; then
  fail "intro should not contain the old mode metadata line"
fi

if printf '%s\n' "$output" | grep -E "^[[:space:]]*UPDATE ALL$" >/dev/null; then
  fail "removed the old non-ascii UPDATE ALL banner header"
fi

if printf '%s\n' "$output" | grep -F "callsign" >/dev/null; then
  fail "intro should not contain the old callsign metadata line"
fi

printf '%s\n' "$output" | grep -F "01110101  01110000" >/dev/null \
  || fail "expected indented binary divider under the title art"

printf '%s\n' "$output" | grep -F "pending updates" >/dev/null \
  || fail "expected pending updates block before updater output"

printf '%s\n' "$output" | grep -F "COVERAGE PREFLIGHT" >/dev/null \
  || fail "expected coverage preflight before update work starts"

printf '%s\n' "$output" | grep -F "Secret safety:" >/dev/null \
  || fail "expected secret safety explanation in coverage preflight"

printf '%s\n' "$output" | grep -F "BUN RUNTIME" >/dev/null \
  || fail "expected Bun runtime to be covered or explicitly skipped"

printf '%s\n' "$output" | grep -F "CARGO-INSTALLED CLIS" >/dev/null \
  || fail "expected cargo-installed CLI coverage"

printf '%s\n' "$output" | grep -F "EDITOR EXTENSIONS" >/dev/null \
  || fail "expected editor extension coverage"

printf '%s\n' "$output" | grep -F "LINUX FIRMWARE UPDATES" >/dev/null \
  || fail "expected firmware update coverage"

printf '%s\n' "$output" | grep -F "fwupdmgr get-updates" >/dev/null \
  || fail "expected firmware dry-run to preview update inspection before applying updates"

printf '%s\n' "$output" | grep -F "apt-get -o Dpkg::Use-Pty=0 -o APT::Color=0 -o APT::Progress-Fancy=0 -o Dpkg::Progress-Fancy=0 update -y" >/dev/null \
  || fail "expected apt update to disable noisy pseudo-terminal progress output"

printf '%s\n' "$output" | grep -F "shell profiles" >/dev/null \
  || fail "expected shell profile boundary in coverage preflight"

printf '%s\n' "$output" | grep -F "receipt summary" >/dev/null \
  || fail "expected final receipt summary"

printf '%s\n' "$output" | grep -F "RUN DETAILS" >/dev/null \
  || fail "expected professional receipt details section"

printf '%s\n' "$output" | grep -F "CLEANUP NEXT STEPS" >/dev/null \
  || fail "expected final cleanup next-steps section"

printf '%s\n' "$output" | grep -F "AFTER-RUN CHECK-IN" >/dev/null \
  || fail "expected final after-run check-in for user concerns"

printf '%s\n' "$output" | grep -F "What to resolve after this run" >/dev/null \
  || fail "expected final check-in to frame post-run issues plainly"

printf '%s\n' "$output" | grep -F "Cleanup choices are collected before updates start" >/dev/null \
  || fail "expected final cleanup guidance to explain upfront cleanup choices"

printf '%s\n' "$output" | grep -F "OPTIONAL CHOICES PREFLIGHT" >/dev/null \
  || fail "expected optional choices preflight before update work starts"

printf '%s\n' "$output" | grep -F "Dry-run:" >/dev/null \
  || fail "expected dry-run to explain that optional prompt-gated steps are previewed without input"

printf '%s\n' "$output" | grep -F "RUN DETAILS" >/dev/null \
  || fail "expected professional receipt details section"

printf '%s\n' "$output" | grep -F "before" >/dev/null \
  || fail "receipt should show stacked before version rows"

printf '%s\n' "$output" | grep -F "after" >/dev/null \
  || fail "receipt should show stacked after version rows"

if printf '%s\n' "$output" | grep -F "STEP                          RESULT      BEFORE" >/dev/null; then
  fail "receipt should not use the cramped legacy table header"
fi

printf '%s\n' "$output" | grep -F "APT CLEANUP?" >/dev/null \
  || fail "expected large apt cleanup question in the upfront choices section"

printf '%s\n' "$output" | grep -F "sudo apt-get autoremove --purge -y" >/dev/null \
  || fail "expected cleanup to purge apt-owned auto-removable packages"

printf '%s\n' "$output" | grep -F "sudo apt-get autoclean" >/dev/null \
  || fail "expected cleanup to run apt autoclean"

printf '%s\n' "$output" | grep -F "sudo apt-get clean" >/dev/null \
  || fail "expected cleanup to run apt clean"

printf '%s\n' "$output" | grep -F "WORKSTATION CACHE CLEANUP?" >/dev/null \
  || fail "expected broader workstation cache cleanup prompt"

printf '%s\n' "$output" | grep -F "npm cache clean --force" >/dev/null \
  || fail "expected npm cache cleanup in dry-run"

printf '%s\n' "$output" | grep -F "timeout 20s uv cache prune" >/dev/null \
  || fail "expected bounded uv cache prune in dry-run"

printf '%s\n' "$output" | grep -F "disabled snap revisions" >/dev/null \
  || fail "expected disabled snap revision cleanup in dry-run"

printf '%s\n' "$output" | grep -F "journalctl --vacuum-size=512M" >/dev/null \
  || fail "expected journal vacuum in dry-run"

awk '
  /▌ NPM SELF-UPDATE/ { in_npm=1 }
  in_npm && /version before/ { before=NR }
  in_npm && /result/ { result=NR }
  in_npm && /^[[:space:]]*after[[:space:]]/ { after=NR; exit }
  END {
    if (!before || !result || !after || !(before < result && result < after)) {
      exit 1
    }
  }
' <<< "$output" || fail "expected npm self-update to show version before near the top and stacked version after as the final outcome row"

awk '
  /^╾──── / {
    expecting_card=1
    blank_gap=0
    next
  }
  expecting_card {
    if ($0 == "") {
      blank_gap++
      next
    }
    if ($0 ~ /^   ▌ /) {
      if (blank_gap < 1) {
        exit 1
      }
      expecting_card=0
      next
    }
    expecting_card=0
  }
' <<< "$output" || fail "expected section headers to keep spacing before section card output"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cat > "$tmpdir/brew" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  --version)
    printf 'Homebrew 6.0.0\n'
    ;;
  tap)
    printf 'example/tap\n'
    ;;
  tap-info)
    cat <<'INFO'
example/tap: Installed
Untrusted
From: https://github.com/example/homebrew-tap
==> Formulae
mcporter
poltergeist
INFO
    ;;
  list)
    if [ "$2" = "--formula" ] || [ "$2" = "--cask" ]; then
      exit 0
    fi
    ;;
  outdated)
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
EOF
chmod +x "$tmpdir/brew"

cat > "$tmpdir/yarn" <<'EOF'
#!/usr/bin/env bash
if [ "${COREPACK_ENABLE_DOWNLOAD_PROMPT:-}" != "0" ]; then
  printf 'missing COREPACK_ENABLE_DOWNLOAD_PROMPT=0\n' >&2
  exit 42
fi
case "$1" in
  --version) printf '99.0.0-test\n' ;;
  *) exit 0 ;;
esac
EOF
chmod +x "$tmpdir/yarn"

cat > "$tmpdir/secret" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  has)
    [ "$2" = "test-sudo-key" ]
    ;;
  get)
    [ "$2" = "test-sudo-key" ] || exit 1
    printf 'fake-password\n'
    ;;
  *)
    exit 1
    ;;
esac
EOF
chmod +x "$tmpdir/secret"

cat > "$tmpdir/sudo" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$UPDATE_ALL_FAKE_SUDO_LOG"
if [ "$1" = "-n" ]; then
  exit 1
fi
if [ "$1" = "-S" ]; then
  shift
  [ "$1" = "-p" ] && shift 2
  IFS= read -r _password || true
  if [ "$1" = "-v" ]; then
    printf '^@sudo validation should not run when a sudo secret is available\n'
    exit 0
  fi
  "$@"
  exit $?
fi
if [ "$1" = "-v" ]; then
  printf '^@sudo validation should not run when a sudo secret is available\n'
  exit 0
fi
"$@"
EOF
chmod +x "$tmpdir/sudo"

sudo_log="$tmpdir/sudo.log"
sudo_output="$(PATH="$tmpdir:$PATH" UPDATE_ALL_SUDO_SECRET_KEY=test-sudo-key UPDATE_ALL_FAKE_SUDO_LOG="$sudo_log" UPDATE_ALL_SUDO_SELFTEST=secret-prime "$UPDATE_ALL" --no-anim --no-color)"
printf '%s\n' "$sudo_output" | grep -F "sudo command ok" >/dev/null \
  || fail "expected sudo secret selftest command to run"
if printf '%s\n' "$sudo_output" | grep -F "^@" >/dev/null; then
  fail "sudo secret selftest should not leak validation control markers"
fi
if grep -F -- "-v" "$sudo_log" >/dev/null; then
  fail "sudo secret selftest should skip sudo validation when secret helper is available"
fi

receipt_output="$(UPDATE_ALL_RECEIPT_SELFTEST=visual "$UPDATE_ALL" --no-anim --no-color)"
printf '%s\n' "$receipt_output" | grep -F "WHAT CHANGED" >/dev/null \
  || fail "expected final receipt to lead with a clear what-changed section"
printf '%s\n' "$receipt_output" | grep -F "old -> new" >/dev/null \
  || fail "expected final receipt to explain version arrows"
printf '%s\n' "$receipt_output" | grep -F "yarn (corepack)" >/dev/null \
  || fail "expected changed tool name in what-changed section"
printf '%s\n' "$receipt_output" | grep -F "before 1.22.22" >/dev/null \
  || fail "expected updated tools to show old version on a stacked before row"
printf '%s\n' "$receipt_output" | grep -F "after  4.17.0" >/dev/null \
  || fail "expected updated tools to show new version on a stacked after row"
printf '%s\n' "$receipt_output" | grep -F "before libevent 2.1.12_1" >/dev/null \
  || fail "expected Homebrew formula old version on a stacked before row"
printf '%s\n' "$receipt_output" | grep -F "after  2.1.13" >/dev/null \
  || fail "expected Homebrew formula new version on a stacked after row"
printf '%s\n' "$receipt_output" | grep -F "before pillow 12.2.0" >/dev/null \
  || fail "expected uv tool old version on a stacked before row"
printf '%s\n' "$receipt_output" | grep -F "after  12.3.0" >/dev/null \
  || fail "expected uv tool new version on a stacked after row"
printf '%s\n' "$receipt_output" | grep -F "NO ACTION NEEDED" >/dev/null \
  || fail "expected final receipt to group unchanged, ok, and skipped rows separately"
printf '%s\n' "$receipt_output" | grep -F "NEEDS YOUR ATTENTION" >/dev/null \
  || fail "expected final receipt to group manual follow-up items"
printf '%s\n' "$receipt_output" | grep -F "Firmware needs manual attention" >/dev/null \
  || fail "expected manual firmware attention to be visible in the terminal receipt"
printf '%s\n' "$receipt_output" | grep -F "means:" >/dev/null \
  || fail "expected attention items to explain what they mean"
printf '%s\n' "$receipt_output" | grep -F "action:" >/dev/null \
  || fail "expected attention items to state the next action"

brew_output="$(PATH="$tmpdir:$PATH" "$UPDATE_ALL" --dry-run --no-anim --no-color)"

printf '%s\n' "$brew_output" | grep -F "99.0.0-test" >/dev/null \
  || fail "expected Corepack-managed yarn version probe to run with download prompts disabled"

if printf '%s\n' "$brew_output" | grep -F "missing COREPACK_ENABLE_DOWNLOAD_PROMPT=0" >/dev/null; then
  fail "yarn version probe should not allow Corepack download prompts"
fi

printf '%s\n' "$brew_output" | grep -F "brew tap trust preflight" >/dev/null \
  || fail "expected Homebrew tap trust preflight section"

printf '%s\n' "$brew_output" | grep -F "Plain English:" >/dev/null \
  || fail "expected plain-English explanation for untrusted taps"

printf '%s\n' "$brew_output" | grep -F "Gold standard:" >/dev/null \
  || fail "expected recommended gold-standard action for untrusted taps"

printf '%s\n' "$brew_output" | grep -F "INSIGHT" >/dev/null \
  || fail "expected pretty insight panel for untrusted taps"

printf '%s\n' "$brew_output" | grep -F "A tap is an extra Homebrew package source" >/dev/null \
  || fail "expected tap to be explained in plain English"

printf '%s\n' "$brew_output" | grep -F "not a malware verdict" >/dev/null \
  || fail "expected calm malware-vs-trust clarification"

printf '%s\n' "$brew_output" | grep -F "Do not panic" >/dev/null \
  || fail "expected explicit panic guidance"

printf '%s\n' "$brew_output" | grep -F "Untap means" >/dev/null \
  || fail "expected untap to be explained in plain English"

printf '%s\n' "$brew_output" | grep -F "removes this package source from Homebrew" >/dev/null \
  || fail "expected untap effect to be clear"

printf '%s\n' "$brew_output" | grep -F "does not delete your projects" >/dev/null \
  || fail "expected untap safety boundary to be clear"

printf '%s\n' "$brew_output" | grep -F "Homebrew may refuse if installed tools still depend on it" >/dev/null \
  || fail "expected untap dependency/refusal caveat"

printf '%s\n' "$brew_output" | grep -F "Recommended: untap it now" >/dev/null \
  || fail "expected unused untrusted tap removal recommendation"

printf '%s\n' "$brew_output" | grep -F "Trust source action" >/dev/null \
  || fail "expected untrusted tap action in final check-in"

printf '%s\n' "$brew_output" | grep -F "brew untap example/tap" >/dev/null \
  || fail "expected exact untap command to be shown in dry-run"

printf '%s\n' "$brew_output" | grep -F "env -u BASH_ENV -u ENV bash --noprofile --norc -c" >/dev/null \
  || fail "expected compound shell commands to avoid shell startup files"

openai_token="sk-$(printf 'a%.0s' {1..24})"
github_token="ghp_$(printf 'b%.0s' {1..24})"
redacted="$(printf 'OPENAI_API_KEY=%s GITHUB_TOKEN=%s\n' "$openai_token" "$github_token" | UPDATE_ALL_REDACTION_SELFTEST=1 "$UPDATE_ALL" --no-anim --no-color)"

printf '%s\n' "$redacted" | grep -F "[REDACTED_OPENAI_KEY]" >/dev/null \
  || fail "expected OpenAI-style token redaction"

printf '%s\n' "$redacted" | grep -F "[REDACTED_GITHUB_TOKEN]" >/dev/null \
  || fail "expected GitHub-style token redaction"

if printf '%s\n' "$redacted" | grep -F "$openai_token" >/dev/null; then
  fail "OpenAI-style test token leaked through redaction"
fi

if printf '%s\n' "$redacted" | grep -F "$github_token" >/dev/null; then
  fail "GitHub-style test token leaked through redaction"
fi

control_cleaned="$(printf '^@Hit:1 https://example.invalid stable InRelease\n' | UPDATE_ALL_REDACTION_SELFTEST=1 "$UPDATE_ALL" --no-anim --no-color)"
if printf '%s\n' "$control_cleaned" | grep -F "^@" >/dev/null; then
  fail "log stream should strip literal NUL marker noise before coloring output"
fi

actual_nul_cleaned="$(printf '\000Hit:1 https://example.invalid stable InRelease\n' | UPDATE_ALL_REDACTION_SELFTEST=1 "$UPDATE_ALL" --no-anim --no-color)"
printf '%s\n' "$actual_nul_cleaned" | grep -F "Hit:1 https://example.invalid stable InRelease" >/dev/null \
  || fail "log stream should keep apt source lines after stripping actual NUL bytes"
if printf '%s\n' "$actual_nul_cleaned" | grep -F "^@" >/dev/null; then
  fail "log stream should strip actual NUL byte noise before coloring output"
fi

stdin_runner_output="$(printf 'keyboard\nkeyboard\nkeyboard\nkeyboard\nkeyboard\n' | UPDATE_ALL_STDIN_SELFTEST=1 "$UPDATE_ALL" --no-anim --no-color)"
printf '%s\n' "$stdin_runner_output" | grep -F "run-cmd-closed" >/dev/null \
  || fail "run_cmd should not consume keyboard input from update-all stdin"
printf '%s\n' "$stdin_runner_output" | grep -F "run-capture-closed" >/dev/null \
  || fail "run_cmd_capture should not consume keyboard input from update-all stdin"
printf '%s\n' "$stdin_runner_output" | grep -F "run-bounded-closed" >/dev/null \
  || fail "run_bounded should not consume keyboard input from update-all stdin"
printf '%s\n' "$stdin_runner_output" | grep -F "run-shell-closed" >/dev/null \
  || fail "run_shell should not consume keyboard input from update-all stdin"
printf '%s\n' "$stdin_runner_output" | grep -F "run-shell-capture-closed" >/dev/null \
  || fail "run_shell_capture should not consume keyboard input from update-all stdin"
if printf '%s\n' "$stdin_runner_output" | grep -F -- "-open" >/dev/null; then
  fail "updater-managed commands must not read from update-all stdin"
fi

printf 'Update State:       Failed\nUpdate Error:       failed to write data to efivarsfs\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=fwupd-manual "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected fwupd efivars failure to classify as manual firmware attention"

printf 'npm warn allow-scripts   @anthropic-ai/claude-code@2.1.195 (postinstall: node install.cjs)\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=npm-claude-script "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected npm Claude Code allow-scripts warning to trigger trusted script retry"

# shellcheck disable=SC2016 # Fixture intentionally contains literal backticks from uv output.
printf 'warning: The package `typer==0.26.8` does not have an extra named `all`\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=uv-stale-extra "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected uv stale optional-extra warning to be recognized"

printf '==> Upgraded 3 outdated packages\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=updated-output "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected Homebrew upgraded package output to count as an updated step"

printf '==> Upgraded 1 outdated package\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=updated-output "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected singular Homebrew upgraded package output to count as an updated step"

printf 'changed 2 packages in 5s\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=updated-output "$UPDATE_ALL" --no-anim --no-color \
  || fail "expected npm changed package output to count as an updated step"

if printf 'Already up-to-date.\n' \
  | UPDATE_ALL_CLASSIFY_SELFTEST=updated-output "$UPDATE_ALL" --no-anim --no-color; then
  fail "already-up-to-date output should not count as an updated step"
fi

firmware_fixture='Razer Blade
│
├─KEK CA:
│ │   Device ID:          b7a1d3d90faa1f6275d9a98da4fb3be7118e61c7
│ │   Current version:    2011
│ │   GUIDs:              814e950f-1449-566a-a190-42c9d3a3a2df
│ └─Secure Boot KEK Configuration Update:
│       New version:      2023
│       Summary:          UEFI Secure Boot Key Exchange Key
│       Urgency:          High
│       Checksum:         103ebd21a803540296daff93fa7e1595bf323b4db78fbc6287aed945ab5965fb
└─UEFI dbx:
  │   Current version:    20230501
  └─Secure Boot dbx Configuration Update:
        New version:      20260402
        Summary:          UEFI Secure Boot Forbidden Signature Database
        Urgency:          High
        Issue:            CVE-2026-8863
'

firmware_summary="$(printf '%s\n' "$firmware_fixture" | UPDATE_ALL_FIRMWARE_SELFTEST=summary "$UPDATE_ALL" --no-anim --no-color)"
printf '%s\n' "$firmware_summary" | grep -F "FIRMWARE REVIEW" >/dev/null \
  || fail "expected firmware output to be summarized as a clear review card"
printf '%s\n' "$firmware_summary" | grep -F "Plain English:" >/dev/null \
  || fail "expected firmware summary to explain the situation plainly"
printf '%s\n' "$firmware_summary" | grep -F "KEK CA" >/dev/null \
  || fail "expected firmware summary to keep device names"
printf '%s\n' "$firmware_summary" | grep -F "2011 -> 2023" >/dev/null \
  || fail "expected firmware summary to show current firmware to new firmware"
printf '%s\n' "$firmware_summary" | grep -F "UEFI dbx" >/dev/null \
  || fail "expected firmware summary to show all firmware devices needing attention"
printf '%s\n' "$firmware_summary" | grep -F "20230501 -> 20260402" >/dev/null \
  || fail "expected firmware summary to show dbx current to new version"
printf '%s\n' "$firmware_summary" | grep -F "action:" >/dev/null \
  || fail "expected firmware summary to include a next action"
if printf '%s\n' "$firmware_summary" | grep -E "Device ID|GUID|Checksum" >/dev/null; then
  fail "default firmware summary should not dump raw scary firmware identifiers"
fi

cat > "$tmpdir/fwupdmgr" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$tmpdir/fwupdmgr"

all_prompt_output="$(
  {
    printf 'a\n' \
      | timeout 12s script --quiet --flush --return --command "env PATH='$tmpdir:$PATH' UPDATE_ALL_PROMPT_SELFTEST=1 '$UPDATE_ALL' --no-anim --no-color" /dev/null
  } || true
)"

prompt_count="$(printf '%s\n' "$all_prompt_output" | grep -c '^? ' || true)"
[ "$prompt_count" -eq 1 ] \
  || fail "typing a should answer every optional prompt after one question"

printf '%s\n' "$all_prompt_output" | grep -F "all mode: yes to every remaining optional question" >/dev/null \
  || fail "expected a/all mode to explain that remaining optional questions are answered yes"

printf '%s\n' "$all_prompt_output" | grep -F "firmware choice: yes" >/dev/null \
  || fail "expected all mode to save yes for firmware"

printf '%s\n' "$all_prompt_output" | grep -F "brew untap example/tap: yes" >/dev/null \
  || fail "expected all mode to save yes for Homebrew untap"

printf '%s\n' "$all_prompt_output" | grep -F "apt cleanup choice: yes" >/dev/null \
  || fail "expected all mode to save yes for apt cleanup"

printf '%s\n' "$all_prompt_output" | grep -F "workstation cleanup choice: yes" >/dev/null \
  || fail "expected all mode to save yes for workstation cache cleanup"

late_prompt_calls="$(grep -nE 'elif confirm_step|if confirm_step' "$UPDATE_ALL" || true)"
if [ -n "$late_prompt_calls" ]; then
  printf '%s\n' "$late_prompt_calls" >&2
  fail "optional y/N prompts should be collected up front, not called mid-run"
fi
