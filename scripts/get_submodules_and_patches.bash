#!/usr/bin/env bash
# Initialize submodules and apply patches

set -e

echo "Initializing git submodules..."
git submodule update --init --recursive

# Patch egl_probe CMakeLists.txt for modern CMake (3.5+)
# https://github.com/StanfordVL/egl_probe/issues/6
EGL_CMAKE="$PIXI_PROJECT_ROOT/patches/egl_probe/egl_probe/CMakeLists.txt"
if [ -f "$EGL_CMAKE" ]; then
    if ! grep -q '3.5...3.28' "$EGL_CMAKE" 2>/dev/null; then
        sed -i '1s/.*/cmake_minimum_required(VERSION 3.5...3.28)/' "$EGL_CMAKE"
        echo "Patched egl_probe CMakeLists.txt for modern CMake"
    else
        echo "egl_probe CMakeLists.txt already patched"
    fi
fi

echo "Submodules and patches applied successfully"
