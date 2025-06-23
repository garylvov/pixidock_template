#!/usr/bin/env bash

# Get the project name from the current directory
PROJECT_NAME=$(basename "$(pwd)")

# Default values
BASE_IMAGE="nvidia/cuda:12.4.1-base-ubuntu22.04"
IMAGE_NAME="${PROJECT_NAME,,}"  # Convert to lowercase
TAG="latest"
BUILD_ARGS=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
case "$1" in
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
    echo "  --base-image IMAGE    Base Docker image to use (default: nvidia/cuda:12.4.1-base-ubuntu22.04)"
    echo "  --image-name NAME     Docker image name (default: project name in lowercase)"
    echo "  --tag TAG             Docker image tag (default: latest)"
    echo "  --build-arg KEY=VAL   Additional build arguments"
    echo "  --help, -h            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0"
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

echo "Building Docker image for $PROJECT_NAME..."
echo "Base image: $BASE_IMAGE"
echo "Image name: $IMAGE_NAME:$TAG"
echo "Build args: $BUILD_ARGS"

# Build the docker image
docker build \
    --ulimit nofile=4096:4096 \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    $BUILD_ARGS \
    -t "$IMAGE_NAME:$TAG" \
    .

echo "Build completed: $IMAGE_NAME:$TAG"
