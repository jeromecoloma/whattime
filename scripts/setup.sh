#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Setting up WhatTime..."
echo ""

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Dependencies ──────────────────────────────────────────────────────────────
DEPS=(xcodegen swiftlint swiftformat)
echo "==> Installing dependencies: ${DEPS[*]}..."
brew install "${DEPS[@]}" 2>/dev/null \
  || brew upgrade "${DEPS[@]}" 2>/dev/null \
  || true

# ── Generate .xcodeproj ───────────────────────────────────────────────────────
echo ""
echo "==> Generating WhatTime.xcodeproj (XcodeGen)..."
cd "$ROOT_DIR"
xcodegen generate --spec project.yml --project WhatTime

# ── Build ─────────────────────────────────────────────────────────────────────
echo ""
echo "==> Building WhatTime..."
"$ROOT_DIR/scripts/build.sh"

echo ""
echo "✓ WhatTime is ready."
echo ""
echo "  Run the app:      make run"
echo "  Open in Xcode:    open WhatTime/WhatTime.xcodeproj   (optional)"
echo "  Run tests:        make test"
echo "  Lint:             make lint"
