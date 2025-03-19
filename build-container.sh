#!/bin/sh
set -ex
docker build --no-cache --progress=plain -t krautsalad/holland:latest -f Dockerfile .
