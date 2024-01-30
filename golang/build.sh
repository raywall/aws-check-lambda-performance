#!/bin/sh
set -e

mkdir -p "output"

#builds a native binary and zip
docker build --file Dockerfile -t golang-arm .

#copy from the docker container to host
containerId=$(docker create -ti golang-arm bash)
docker cp ${containerId}:/go/src/app/function.zip ./output