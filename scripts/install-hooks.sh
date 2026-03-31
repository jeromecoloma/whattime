#!/usr/bin/env zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.git/hooks"
SOURCE_DIR="$ROOT_DIR/scripts/hooks"

echo "==> Installing git hooks..."

for hook in "$SOURCE_DIR"/*; do
  name="$(basename "$hook")"
  cp "$hook" "$HOOKS_DIR/$name"
  chmod +x "$HOOKS_DIR/$name"
  echo "    installed $name"
done

echo "Git hooks installed."
