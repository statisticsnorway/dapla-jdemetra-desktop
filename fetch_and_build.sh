#!/bin/bash

# URL of the jdemetra binary
BINARY_URL="https://github.com/jdemetra/jdemetra-app/releases/download/v2.2.4/jdemetra-2.2.4-bin.zip"

# Directory where the binary should be saved
BINARY_DIR="./resources/binaries"

# Image name for Docker
DOCKER_IMAGE_NAME="trygu/nbdemetra:1.2"

# Build gcsfuse-token-provider
cd gcsfuse-token-provider || exit
poetry install
poetry build
cd ..

# Ensure the binaries directory exists
mkdir -p "$BINARY_DIR"

# Download the binary
echo "Downloading jdemetra-2.2.4-bin.zip..."
wget -O "$BINARY_DIR/jdemetra-2.2.4-bin.zip" "$BINARY_URL" || {
    echo "Failed to download the binary."
    exit 1
}

echo "Download complete. The binary is saved in $BINARY_DIR."

# Build the Docker image
echo "Building Docker image: $DOCKER_IMAGE_NAME"
docker build --platform linux/amd64 -t "$DOCKER_IMAGE_NAME" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image $DOCKER_IMAGE_NAME built successfully."
    # Push the Docker image
    echo "Pushing Docker image to the registry..."
    docker push "$DOCKER_IMAGE_NAME" && echo "Image pushed successfully." || echo "Failed to push the image."
else
    echo "Failed to build Docker image."
    exit 1
fi
