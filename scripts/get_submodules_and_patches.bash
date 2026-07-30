#!/usr/bin/env bash
# Initialize submodules and apply patches

set -e

echo "Initializing git submodules..."
git submodule update --init --recursive

# Serialize pixi env solves (pixi build-dispatch race workaround; see README).
if command -v pixi >/dev/null 2>&1; then
  pixi config set --local concurrency.solves 1 >/dev/null 2>&1 && echo "Pixi solve concurrency serialized"
fi
echo "Submodules and patches applied successfully"
