# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.x   | Yes       |

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities privately via [GitHub's private security advisory feature](https://github.com/jeromecoloma/whattime/security/advisories/new).

Include:
- A description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested mitigations (optional)

**Response time:** You will receive an acknowledgement within 48 hours.

**Disclosure timeline:** We aim to release a fix or mitigation within 90 days of a confirmed report. We will coordinate the public disclosure date with you.

## Scope

WhatTime is a local macOS application with no network access, no accounts, and no external service integrations. The attack surface is limited to:

- Input parsing (the natural language query field)
- Local file system access (macOS sandbox applies)

Reports related to the macOS sandbox, Xcode toolchain, or Apple system libraries are out of scope — report those to Apple.
