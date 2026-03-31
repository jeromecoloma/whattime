#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v swiftlint &>/dev/null; then
  echo "error: SwiftLint not found. Install with: brew install swiftlint" >&2
  exit 1
fi

EXTRA_ARGS=()
if [[ "${1:-}" == "--fix" ]]; then
  EXTRA_ARGS+=(--fix)
  echo "SwiftLint (autocorrect)..."
else
  echo "SwiftLint..."
fi

cd "$ROOT_DIR"
swiftlint lint "${EXTRA_ARGS[@]}"
echo "SwiftLint complete."
