#!/usr/bin/env bash
workspace_root="$(pwd)"
export COLCON_DEFAULTS_FILE="${workspace_root}/jazzy_ws/colcon-defaults.yaml"

if [ -f "${workspace_root}/jazzy_ws/install/setup.bash" ]; then
    source "${workspace_root}/jazzy_ws/install/setup.bash"
fi
