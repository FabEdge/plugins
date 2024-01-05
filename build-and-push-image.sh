#!/bin/bash

VERSION=${1:-latest}

if [[ $(docker buildx ls) != *"mybuilder"* ]]; then
  docker buildx create --name mybuilder --bootstrap --use
fi
docker buildx use mybuilder

docker buildx build \
    --build-arg="pluginVersion=${VERSION}" \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    --push \
    -t fabedge/cni-plugins:${VERSION} . 

docker buildx use default
