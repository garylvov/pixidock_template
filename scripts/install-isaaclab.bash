#!/usr/bin/env bash

# Isaac Lab can't be easily added to the the pixi.toml like Genesis currently is
# due the package platform being incorrectly identified as incompatible through Pixi-based uv PyPi installation,
# Pip doesn't fail on the platform check, and is more easily deceived

set -e  # Exit on error

# Install Isaac Sim Python package
pip install 'isaacsim[all,extscache]==4.5.0' --extra-index-url https://pypi.nvidia.com

echo "Cloning IsaacLab repo and egl_probe if not present..."

# Clone egl_probe if not already present
# This is to patch a 4 year old library Isaac Lab wants to get it to play nice...
# Peak python: https://github.com/StanfordVL/egl_probe/issues/6
# Yes I should submit an issue reporting this I'm sorry lol
if [ ! -d "egl_probe" ]; then
  git clone https://github.com/StanfordVL/egl_probe.git egl_probe
  # Patch the CMakeLists.txt to use CMake >= 3.5
else
  echo "egl_probe already exists, skipping clone "
fi

sed -i '1s/.*/cmake_minimum_required(VERSION 3.5...3.28)/' egl_probe/egl_probe/CMakeLists.txt
pip install ./egl_probe


# Clone IsaacLab if not already present
if [ ! -d "IsaacLab" ]; then
  git clone git@github.com:isaac-sim/IsaacLab.git
else
  echo "IsaacLab already exists, skipping clone and install."
fi

cd IsaacLab
./isaaclab.sh -i

echo "Isaac Lab installation complete, see at IsaacLab"
