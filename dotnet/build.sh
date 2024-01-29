#!/bin/sh
set -e


#builds a native binary and zip
docker build  -t dotnet .

#copy from the docker container to host
containerId=$(docker create -ti dotnet)
docker cp ${containerId}:/app/output ./