# Security Policy

## Supported Version

The supported branch is `main`.

This is a personal workstation updater, not a production fleet patching system. Security fixes should target the current public branch.

## Reporting A Vulnerability

Please do not open a public issue for vulnerabilities, leaked secrets, or exploit details.

Use GitHub's private vulnerability reporting for this repository when available, or contact the maintainer through GitHub with a minimal, redacted description.

Include:

- affected command or workflow,
- expected impact,
- safe reproduction steps,
- whether cleanup/removal/system state is involved.

Do not include:

- real API keys,
- sudo passwords,
- private hostnames,
- local IP inventory,
- full shell startup files,
- unredacted machine logs.

## Security Boundaries

`update-all` is designed to:

- call first-party/package-manager commands instead of replacing them,
- keep cleanup/removal prompt-gated,
- avoid storing sudo passwords or tokens,
- redact common secret shapes from streamed output,
- avoid sourcing shell startup files for its internal compound shell commands,
- keep active agent runtimes and project repositories manual by design.

Redaction is a guardrail, not a substitute for secret hygiene. Do not store raw secrets in shell profiles, committed files, screenshots, or issue comments.

## Safe Testing

Please use:

```bash
update-all --dry-run --no-anim --no-color
```

Avoid running destructive cleanup, firmware updates, or system mutation tests on machines you cannot restore.
