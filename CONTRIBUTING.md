# Contributing to WhatTime

Thanks for your interest. Here's what you need to know before contributing.

## What's Welcome

- Bug fixes
- Expanding the timezone name map (`TimeZoneData.swift`) with missing city/country aliases
- Documentation improvements
- Test coverage improvements

## What's Out of Scope

WhatTime is intentionally minimal. The following will not be accepted regardless of implementation quality:

- External service integrations (calendar sync, notifications, etc.)
- Accounts or login
- iOS/iPadOS companion apps
- Significant UI overhauls
- Replacing the regex parser with a third-party NLP dependency

If you're unsure whether your idea fits, open an issue first and describe it before writing any code.

## Development Setup

**Requirements:**
- macOS 14 (Sonoma) or later
- Xcode 15 or later
- Homebrew

**First-time setup:**

```bash
git clone https://github.com/jeromecoloma/whattime
cd whattime
./scripts/setup.sh
```

This script installs dependencies (`xcodegen`, `swiftlint`, `swiftformat` via Homebrew), generates the Xcode project, and builds the app.

**Daily workflow:**

```bash
make run          # build and launch
make test         # run tests
make lint         # SwiftLint check
make format       # SwiftFormat
```

## Making Changes

1. Fork the repository
2. Create a branch: `git checkout -b your-branch-name`
3. Make your changes
4. Run tests: `make test`
5. Run lint: `make lint`
6. Run format: `make format`
7. Commit with a clear message
8. Open a pull request against `main`

## Pull Request Requirements

- All tests pass (`make test`)
- No SwiftLint errors (`make lint`)
- Code is formatted (`make format`)
- New behaviour is covered by tests
- PR description explains *what* changed and *why*

## Commit Style

Use present-tense imperative: `Add timezone alias for Auckland`, not `Added Auckland timezone`.

Prefix with a type when it helps:
- `feat:` — new feature or behaviour
- `fix:` — bug fix
- `test:` — test-only changes
- `docs:` — documentation only
- `chore:` — tooling, dependencies, formatting

## Reporting Bugs

Open a GitHub issue. Include:
- macOS version
- Exact query string that caused the problem
- What you expected vs. what happened

## Security Issues

Do not open public issues for security vulnerabilities. See [SECURITY.md](SECURITY.md).
