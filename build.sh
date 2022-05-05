#!/bin/bash

# GIT
git checkout master
git pull

# ENVIRONMENT
GIT_LAST_TAG=`git describe --tags --abbrev=0`
DOCKER_REPO=oxystin/drone-runner-ssh
export DOCKER_BUILDKIT=1
export DOCKER_CLI_EXPERIMENTAL=enabled

# COMPILE
docker run --rm -it -v ~/git/drone-runner-ssh:/go golang:1.18.1 scripts/build.sh

# QEMU CONFIG
# https://github.com/multiarch/qemu-user-static
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# AMD64
docker build \
    --platform linux/amd64 \
    --file docker/Dockerfile.linux.amd64 \
    --tag ${DOCKER_REPO}:${GIT_LAST_TAG}-amd64 .
docker push ${DOCKER_REPO}:${GIT_LAST_TAG}-amd64

# ARM32V6
docker build \
    --platform=linux/arm/v6 \
    --file docker/Dockerfile.linux.arm \
    --tag ${DOCKER_REPO}:${GIT_LAST_TAG}-armv6 .
docker push ${DOCKER_REPO}:${GIT_LAST_TAG}-armv6

# ARM32V7
docker build \
    --platform=linux/arm/v7 \
    --file docker/Dockerfile.linux.arm \
    --tag ${DOCKER_REPO}:${GIT_LAST_TAG}-armv7 .
docker push ${DOCKER_REPO}:${GIT_LAST_TAG}-armv7

# ARM64V8
docker build \
    --platform linux/arm64/v8 \
    --file docker/Dockerfile.linux.arm64 \
    --tag ${DOCKER_REPO}:${GIT_LAST_TAG}-arm64 .
docker push ${DOCKER_REPO}:${GIT_LAST_TAG}-arm64

# MANIFEST
docker manifest rm ${DOCKER_REPO}:latest
docker manifest create \
  ${DOCKER_REPO}:latest \
  --amend ${DOCKER_REPO}:${GIT_LAST_TAG}-amd64 \
  --amend ${DOCKER_REPO}:${GIT_LAST_TAG}-armv6 \
  --amend ${DOCKER_REPO}:${GIT_LAST_TAG}-armv7 \
  --amend ${DOCKER_REPO}:${GIT_LAST_TAG}-arm64
docker manifest push ${DOCKER_REPO}:latest