# syntax=docker/dockerfile:1
FROM public.ecr.aws/lambda/dotnet:7

COPY output/. ${LAMBDA_TASK_ROOT}/.

CMD [ "dotnet-lambda::dotnet_lambda.Function::FunctionHandler" ]