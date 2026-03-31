#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v xcodegen &>/dev/null; then
  echo "error: xcodegen not found. Run: brew install xcodegen" >&2
  exit 1
fi

echo "Regenerating WhatTime.xcodeproj..."
cd "$ROOT_DIR"
xcodegen generate --spec project.yml --project WhatTime
echo "Done. Project regenerated at WhatTime/WhatTime.xcodeproj"
