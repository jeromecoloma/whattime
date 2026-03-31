#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/WhatTime/WhatTime.xcodeproj"
ARCHIVE_PATH="$ROOT_DIR/dist/WhatTime.xcarchive"

VERSION=$(xcodebuild -project "$PROJECT_PATH" -scheme WhatTime -showBuildSettings 2>/dev/null \
  | awk '/MARKETING_VERSION/ { print $3; exit }')
BUILD=$(xcodebuild -project "$PROJECT_PATH" -scheme WhatTime -showBuildSettings 2>/dev/null \
  | awk '/CURRENT_PROJECT_VERSION/ { print $3; exit }')

echo "Archiving WhatTime $VERSION (build $BUILD)..."
rm -rf "$ARCHIVE_PATH"

xcodebuild archive \
  -project "$PROJECT_PATH" \
  -scheme WhatTime \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGN_STYLE=Automatic

echo ""
echo "Archive: $ARCHIVE_PATH"
echo ""
echo "Notarization checklist:"
echo "  [ ] Developer ID Application certificate present"
echo "  [ ] Hardened Runtime enabled"
echo "  [ ] xcrun notarytool submit <dmg> --apple-id <email> --team-id <team> --password <app-pw> --wait"
echo "  [ ] xcrun stapler staple <dmg>"
echo "  [ ] spctl --assess --type install <dmg>"
