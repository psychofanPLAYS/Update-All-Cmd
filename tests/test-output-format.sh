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

printf '%s\n' "$output" | grep -F "VERSION BEFORE" >/dev/null \
  || fail "expected loud version before marker"

printf '%s\n' "$output" | grep -F "VERSION AFTER" >/dev/null \
  || fail "expected loud version after marker"

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

if printf '%s\n' "$output" | grep -F "callsign" >/dev/null; then
  fail "intro should not contain the old callsign metadata line"
fi

printf '%s\n' "$output" | grep -F "01110101  01110000" >/dev/null \
  || fail "expected indented binary divider under the title art"

printf '%s\n' "$output" | grep -F "pending updates" >/dev/null \
  || fail "expected pending updates block before updater output"

printf '%s\n' "$output" | grep -F "receipt summary" >/dev/null \
  || fail "expected final receipt summary"

printf '%s\n' "$output" | grep -F "APT CLEANUP?" >/dev/null \
  || fail "expected large apt cleanup question near the end"

printf '%s\n' "$output" | grep -F "sudo apt-get autoremove --purge -y" >/dev/null \
  || fail "expected cleanup to purge apt-owned auto-removable packages"

printf '%s\n' "$output" | grep -F "sudo apt-get autoclean" >/dev/null \
  || fail "expected cleanup to run apt autoclean"

printf '%s\n' "$output" | grep -F "sudo apt-get clean" >/dev/null \
  || fail "expected cleanup to run apt clean"
