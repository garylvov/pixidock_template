#!/usr/bin/env bash
workspace_root="$(pwd)"
export COLCON_DEFAULTS_FILE="${workspace_root}/humble_ws/colcon-defaults.yaml"

if [ -f "${workspace_root}/humble_ws/install/setup.bash" ]; then
    source "${workspace_root}/humble_ws/install/setup.bash"
fi
