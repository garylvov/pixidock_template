#!/usr/bin/env bash
set -e  # Exit on error

# Install Isaac Sim Python package
pip install 'isaacsim[all,extscache]==4.5.0' --extra-index-url https://pypi.nvidia.com

echo "Cloning IsaacLab repo and egl_probe if not present..."

# Clone egl_probe if not already present
# This is to patch a 4 year old library to get it to play nice...
# Peak python: https://github.com/StanfordVL/egl_probe
if [ ! -d "egl_probe" ]; then
  git clone https://github.com/StanfordVL/egl_probe.git egl_probe
  # Patch the CMakeLists.txt to use CMake >= 3.5
  sed -i '1s/.*/cmake_minimum_required(VERSION 3.5...3.28)/' egl_probe/CMakeLists.txt
  pip install ./egl_probe
else
  echo "egl_probe already exists, skipping clone and install."
fi

# Clone IsaacLab if not already present
if [ ! -d "IsaacLab" ]; then
  git clone git@github.com:isaac-sim/IsaacLab.git
  cd IsaacLab
  ./isaaclab.sh -i
else
  echo "IsaacLab already exists, skipping clone and install."
fi
echo "Isaac Lab installation complete, see at IsaacLab"
