#!/bin/sh
set -e

#build Rust
cd ./rust-aws-lambda
sh build.sh
cd ./../
##
#build Go
cd ./dotnet-lambda
sh build.sh
cd ./../

#build Go
cd ./go-lambda
sh build.sh
cd ./../
#
#builds Java and GraalVM
cd ./java-graalvm-lambda
sh build.sh
cd ./../

## Deploy lambdas

alias sam='sam.cmd'
sam build --use-container NodeJsFunction -b nodejs
sam build --use-container RubyFunction -b ruby

sam deploy -t template.yaml --no-confirm-changeset --no-fail-on-empty-changeset --stack-name lambda-runtimes-performance --s3-bucket aws-lambda-runtime-performance-test --capabilities CAPABILITY_IAM