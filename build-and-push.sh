#!/bin/bash
set -e

# Configuration
DOCKER_REGISTRY=${DOCKER_REGISTRY:-ghcr.io}
DOCKER_USERNAME=${DOCKER_USERNAME:-$GITHUB_ACTOR}
IMAGE_NAME=${IMAGE_NAME:-npm-audit-fix}
IMAGE_TAG=${IMAGE_TAG:-latest}

# Full image name
FULL_IMAGE_NAME="${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building Docker image: ${FULL_IMAGE_NAME}"
docker build -t ${FULL_IMAGE_NAME} .

if [ "${PUSH_IMAGE}" = "true" ]; then
  echo "Logging in to Docker registry ${DOCKER_REGISTRY}"
  echo "${DOCKER_PASSWORD}" | docker login ${DOCKER_REGISTRY} -u ${DOCKER_USERNAME} --password-stdin
  
  echo "Pushing Docker image: ${FULL_IMAGE_NAME}"
  docker push ${FULL_IMAGE_NAME}
  
  echo "Image pushed successfully!"
else
  echo "Image built successfully! To push, set PUSH_IMAGE=true"
fi 