#!/bin/bash

# Parar em caso de erro
set -e

docker buildx build --platform linux/arm64/v8 . -t lambda_langs_test_go
docker tag lambda_langs_test_go:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/lambda_langs_test_go:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/lambda_langs_test_go:latest

aws lambda create-function \
    --function-name lambda_langs_test_go \
    --memory-size 640  \
    --architectures arm64 \
    --code ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/lambda_langs_test_go:latest \
    --timeout 900 \
    --role ${LAMBDA_IAM_ROLE}