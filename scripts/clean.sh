#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Cleaning build artifacts..."
[[ -d "$ROOT_DIR/dist/DerivedData" ]] && rm -rf "$ROOT_DIR/dist/DerivedData" && echo "  Removed DerivedData"
[[ -d "$ROOT_DIR/dist/TestResults.xcresult" ]] && rm -rf "$ROOT_DIR/dist/TestResults.xcresult" && echo "  Removed TestResults.xcresult"
echo "Clean complete."
