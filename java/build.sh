#!/bin/sh
set -e

mkdir -p "output"
mvn compile dependency:copy-dependencies -DincludeScope=runtime

# builds a native binary and zip
docker build --platform linux/amd64 -t java-lambda .