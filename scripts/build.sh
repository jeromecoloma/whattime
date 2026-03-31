#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/WhatTime/WhatTime.xcodeproj"
DERIVED_DATA_PATH="$ROOT_DIR/dist/DerivedData"
CONFIGURATION="${1:-Debug}"
BUILT_APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/WhatTime.app"
DIST_APP_PATH="$ROOT_DIR/dist/WhatTime.app"

echo "Building WhatTime ($CONFIGURATION)..."
"$ROOT_DIR/scripts/generate_app_icon.sh"

if command -v xcpretty &>/dev/null; then
  xcodebuild \
    -project "$PROJECT_PATH" \
    -scheme WhatTime \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build \
    | xcpretty --color
else
  xcodebuild \
    -project "$PROJECT_PATH" \
    -scheme WhatTime \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build
fi

rm -rf "$DIST_APP_PATH"
ditto "$BUILT_APP_PATH" "$DIST_APP_PATH"

echo "Build complete ($CONFIGURATION)."
