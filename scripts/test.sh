#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/WhatTime/WhatTime.xcodeproj"
DERIVED_DATA_PATH="$ROOT_DIR/dist/DerivedData"
RESULTS_PATH="$ROOT_DIR/dist/TestResults.xcresult"

rm -rf "$RESULTS_PATH"

echo "Running unit tests..."

if command -v xcpretty &>/dev/null; then
  PRETTY="xcpretty --color"
else
  PRETTY="cat"
fi

xcodebuild test \
  -project "$PROJECT_PATH" \
  -scheme WhatTime \
  -destination "platform=macOS" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -resultBundlePath "$RESULTS_PATH" \
  -only-testing:WhatTimeTests \
  | eval "$PRETTY" || {
    echo ""
    echo "Tests failed. Open results: open $RESULTS_PATH"
    exit 1
  }

echo "All tests passed."
