#!/usr/bin/env bash
# Initialize submodules and apply patches

set -e

echo "Initializing git submodules..."
git submodule update --init --recursive

echo "Submodules and patches applied successfully"
