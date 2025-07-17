#!/usr/bin/env bash

# Get the project name from the current directory
PROJECT_NAME=$(basename "$(pwd)")

# Build configurations
# CPU build: Uses Ubuntu base image without CUDA, suitable for systems without GPU support
# GPU build: Uses NVIDIA CUDA base image with GPU support enabled
CPU_BASE_IMAGE="ubuntu:22.04"
# Can try changing devel to base if you don't need to compile anything
GPU_BASE_IMAGE="cuda:12.6.1-devel-ubuntu22.04 "

# Default values
USE_CPU=false
TAG=""
IMAGE_NAME="${PROJECT_NAME,,}"  # Convert to lowercase

# Parse command line arguments
while [[ $# -gt 0 ]]; do
case "$1" in
--cpu)
    USE_CPU=true
    TAG=":cpu"
    shift
    ;;
--image-name)
    IMAGE_NAME="$2"
    shift 2
    ;;
*)
    # Unknown option
    echo "Unknown option: $1"
    echo "Usage: $0 [--cpu] [--image-name NAME]"
    exit 1
    ;;
esac
done

# Build the appropriate docker image
if [ "$USE_CPU" = true ]; then
    echo "Building CPU docker image for $PROJECT_NAME..."
    echo "Base image: $CPU_BASE_IMAGE"
    docker build --ulimit nofile=4096:4096 --build-arg BASE_IMAGE="$CPU_BASE_IMAGE" -t "$IMAGE_NAME:cpu" .
else
    echo "Building GPU docker image for $PROJECT_NAME..."
    echo "Base image: $GPU_BASE_IMAGE"
    docker build --ulimit nofile=4096:4096 --build-arg BASE_IMAGE="$GPU_BASE_IMAGE" -t "$IMAGE_NAME:latest" .
fi

# Base docker command
DOCKER_CMD="docker run -it \
--env=DISPLAY=$DISPLAY \
--env=QT_X11_NO_MITSHM=1 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
--network=host \
--privileged \
--volume=/dev/bus/usb:/dev/bus/usb:rw \
--volume=$(pwd):/workspace \
--workdir=/workspace"

# Add GPU flag if not using CPU
if [ "$USE_CPU" = false ]; then
DOCKER_CMD="$DOCKER_CMD \
--gpus all"
fi

# Execute the docker command
$DOCKER_CMD "$IMAGE_NAME$TAG"
