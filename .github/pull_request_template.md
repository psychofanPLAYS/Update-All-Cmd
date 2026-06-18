## Summary

- Briefly describe the change and why it is safe.

## Verification

- [ ] `bash -n bin/update-all install.sh tests/test-output-format.sh`
- [ ] `bash tests/test-output-format.sh`
- [ ] `./bin/update-all --dry-run --no-anim --no-color`
- [ ] `cspell README.md bin/update-all install.sh docs/UPDATE_ALL_HANDOFF.md cspell.json tests/test-output-format.sh CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md .github/*.md .github/*.yml .github/**/*.md .github/**/*.yml`
- [ ] Public-safety scan if docs/output changed

## Safety Notes

- [ ] No secrets, private paths, machine hostnames, or local IPs were added.
- [ ] Destructive or cleanup behavior is prompt-gated.
- [ ] First-party/package-manager commands are preferred over custom update logic.
