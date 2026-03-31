#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_PATH="$ROOT_DIR/dist/WhatTime.app"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister"

"$ROOT_DIR/scripts/build.sh"

pkill -x WhatTime 2>/dev/null || true

# Refresh the bundle mtime and re-register it so macOS updates
# Dock/Cmd-Tab metadata for iterative local builds.
touch "$APP_PATH"
"$LSREGISTER" -f -R -trusted "$APP_PATH" >/dev/null 2>&1 || true

# Launch a fresh instance from the just-built bundle instead of
# re-focusing an older running copy.
open -n "$APP_PATH"
