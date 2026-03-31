#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/WhatTime"

if ! command -v swiftformat &>/dev/null; then
  echo "error: SwiftFormat not found. Install with: brew install swiftformat" >&2
  exit 1
fi

MODE="${1:---format}"

case "$MODE" in
  --check | --lint)
    echo "Checking formatting (dry run)..."
    swiftformat "$SOURCE_DIR" --lint --config "$ROOT_DIR/.swiftformat"
    echo "No formatting issues found."
    ;;
  --format | "")
    echo "Formatting source files..."
    swiftformat "$SOURCE_DIR" --config "$ROOT_DIR/.swiftformat"
    echo "Formatting complete."
    ;;
  *)
    echo "Usage: format.sh [--format | --check]" >&2
    exit 1
    ;;
esac
