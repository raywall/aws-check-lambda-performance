#!/bin/sh
set -e

mkdir -p "output"
mkdir -p "output-arm"
mkdir -p "output-custom-runtime"
#builds a native binary and zip
docker build  -t golang .

#copy from the docker container to host
containerId=$(docker create -ti golang bash)
docker cp ${containerId}:/go/src/app/golang ./output

#builds a native binary and zip
docker build --file Dockerfile.arm -t golang-arm .

#copy from the docker container to host
containerId=$(docker create -ti golang-arm bash)
docker cp ${containerId}:/go/src/app/function.zip ./output-arm

#builds a native binary and zip
docker build --file Dockerfile.custom-runtime -t golang-custom-runtime .

#copy from the docker container to host
containerId=$(docker create -ti golang-custom-runtime bash)
docker cp ${containerId}:/go/src/app/function.zip ./output-custom-runtime