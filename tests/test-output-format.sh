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

printf '%s\n' "$output" | grep -F "version after" >/dev/null \
  || fail "expected readable version after row"

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

printf '%s\n' "$output" | grep -F "receipt summary" >/dev/null \
  || fail "expected final receipt summary"

printf '%s\n' "$output" | grep -F "RUN DETAILS" >/dev/null \
  || fail "expected professional receipt details section"

printf '%s\n' "$output" | grep -F "before:" >/dev/null \
  || fail "expected receipt before detail rows"

printf '%s\n' "$output" | grep -F "after:" >/dev/null \
  || fail "expected receipt after detail rows"

if printf '%s\n' "$output" | grep -F "STEP                          RESULT      BEFORE" >/dev/null; then
  fail "receipt should not use the cramped legacy table header"
fi

printf '%s\n' "$output" | grep -F "APT CLEANUP?" >/dev/null \
  || fail "expected large apt cleanup question near the end"

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
  in_npm && /version after/ { after=NR; exit }
  END {
    if (!before || !result || !after || !(before < result && result < after)) {
      exit 1
    }
  }
' <<< "$output" || fail "expected npm self-update to show version before near the top and version after as the final outcome row"

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
