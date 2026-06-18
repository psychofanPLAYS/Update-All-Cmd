# Contributing

Thanks for taking a look at `update-all`.

This project is a local-first Bash CLI for personal Linux workstations. The goal is to make update workflows clearer and safer, especially for people who are still learning what each package manager does.

## Before You Start

- Keep changes small and easy to review.
- Prefer first-party package-manager commands over custom update logic.
- Do not add telemetry, cloud upload, or secret collection.
- Do not paste sudo passwords, tokens, private paths, hostnames, or full machine logs into issues or pull requests.
- Cleanup and removal behavior must stay prompt-gated.

## Local Checks

Run these before opening a pull request:

```bash
bash -n bin/update-all install.sh tests/test-output-format.sh
bash tests/test-output-format.sh
./bin/update-all --dry-run --no-anim --no-color
cspell README.md bin/update-all install.sh docs/UPDATE_ALL_HANDOFF.md cspell.json tests/test-output-format.sh CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md .github/*.md .github/*.yml .github/**/*.md .github/**/*.yml
git diff --check
```

If ShellCheck is installed, also run:

```bash
shellcheck bin/update-all install.sh tests/test-output-format.sh
```

## Design Rules

- Explain scary-looking output in plain English.
- Show exact commands before running risky actions.
- Use `--dry-run --no-anim --no-color` as the stable smoke-test path.
- Keep public examples generic and portable.
- Treat active agent runtimes, project repositories, firmware, containers, and LLM weights as special cases that need explicit user intent.

## Pull Requests

Please include:

- what changed,
- why it is safe,
- which commands you ran,
- any known limitations.

For security reports, use the security policy instead of a public issue.
