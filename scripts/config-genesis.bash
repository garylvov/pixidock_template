#!/bin/bash
# https://github.com/Genesis-Embodied-AI/Genesis/issues/1345

# I think this means CPU rendering only
export PYOPENGL_PLATFORM=osmesa
# For GPU, freezes on visualizer build ;(
# PYOPENGL_PLATFORM=egl
