#!/bin/sh
set -e

#build Rust
cd rust
sh build.sh
cd ..

#build .net
cd dotnet
sh build.sh
cd ..

#build Go
cd golang
sh build.sh
cd ..

#builds Java and GraalVM
cd java
sh build.sh
cd ..

## Deploy lambdas
alias sam='sam.cmd'

sam build --use-container NodeJsFunction -b nodejs
sam build --use-container RubyFunction -b ruby

sam deploy -t template.yaml --no-confirm-changeset --no-fail-on-empty-changeset --stack-name lambda-runtimes-performance --s3-bucket aws-lambda-runtime-performance-test --capabilities CAPABILITY_IAM