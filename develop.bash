#!/usr/bin/env bash

# Get the project name from the current directory
PROJECT_NAME=$(basename "$(pwd)")

# Default values
CPU_BASE_IMAGE="ubuntu:22.04"
GPU_BASE_IMAGE="nvidia/cuda:12.4.1-base-ubuntu22.04"
BASE_IMAGE="$GPU_BASE_IMAGE"
IMAGE_NAME="${PROJECT_NAME,,}"
TAG="latest"
BUILD_ARGS=""
USE_CPU=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
case "$1" in
    --cpu)
        USE_CPU=true
        BASE_IMAGE="$CPU_BASE_IMAGE"
        TAG="cpu"
        shift
        ;;
    --base-image)
        BASE_IMAGE="$2"
        shift 2
        ;;
    --image-name)
        IMAGE_NAME="$2"
        shift 2
        ;;
    --tag)
        TAG="$2"
        shift 2
        ;;
    --build-arg)
        BUILD_ARGS="$BUILD_ARGS --build-arg $2"
        shift 2
        ;;
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --cpu                Build for CPU only (default: GPU)"
        echo "  --base-image IMAGE   Base Docker image to use (default: nvidia/cuda:12.4.1-base-ubuntu22.04 for GPU, ubuntu:22.04 for CPU)"
        echo "  --image-name NAME    Docker image name (default: project name in lowercase)"
        echo "  --tag TAG            Docker image tag (default: latest for GPU, cpu for CPU)"
        echo "  --build-arg KEY=VAL  Additional build arguments (can be used multiple times)"
        echo "  --help, -h           Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0"
        echo "  $0 --cpu"
        echo "  $0 --base-image ubuntu:22.04 --tag cpu"
        echo "  $0 --base-image nvidia/cuda:11.8-base-ubuntu20.04 --image-name myproject --tag v1.0"
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
done

# Build the docker image

echo "Building Docker image for $PROJECT_NAME..."
echo "Base image: $BASE_IMAGE"
echo "Image name: $IMAGE_NAME:$TAG"
echo "Build args: $BUILD_ARGS"

docker build \
    --ulimit nofile=4096:4096 \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    $BUILD_ARGS \
    -t "$IMAGE_NAME:$TAG" \
    .

echo "Build completed: $IMAGE_NAME:$TAG"

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
$DOCKER_CMD "$IMAGE_NAME:$TAG"
