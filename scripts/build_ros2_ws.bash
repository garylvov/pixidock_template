#!/usr/bin/env bash

git submodule update --init --recursive && \
cd ros2_ws/ && \
    colcon build \
    --symlink-install \
    --parallel-workers $(nproc) && \
    source install/setup.bash \
    && \
cd -
