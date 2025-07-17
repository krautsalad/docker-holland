#!/bin/sh
set -ex

docker build --no-cache --progress=plain -t krautsalad/holland:latest -f docker/Dockerfile .
docker push krautsalad/holland:latest

VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)")

docker tag krautsalad/holland:latest krautsalad/holland:${VERSION}
docker push krautsalad/holland:${VERSION}
