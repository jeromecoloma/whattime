#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_PNG="$ROOT_DIR/_assets/logo/WhatTime_Icon.png"
ICONSET_DIR="$ROOT_DIR/WhatTime/Assets.xcassets/AppIcon.appiconset"

fail() {
  echo "$1" >&2
  exit 1
}

[[ -f "$SOURCE_PNG" ]] || fail "Missing PNG source: $SOURCE_PNG"

mkdir -p "$ICONSET_DIR"

make_icon() {
  local pixel_size="$1"
  local file_name="$2"

  sips -z "$pixel_size" "$pixel_size" "$SOURCE_PNG" --out "$ICONSET_DIR/$file_name" >/dev/null
}

make_icon 16 icon_16x16.png
make_icon 32 icon_16x16@2x.png
make_icon 32 icon_32x32.png
make_icon 64 icon_32x32@2x.png
make_icon 128 icon_128x128.png
make_icon 256 icon_128x128@2x.png
make_icon 256 icon_256x256.png
make_icon 512 icon_256x256@2x.png
cp "$SOURCE_PNG" "$ICONSET_DIR/icon_512x512.png"
make_icon 1024 icon_512x512@2x.png
