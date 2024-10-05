#!/bin/zsh

# Initial setup
set -e

export AWS_ACCOUNT_ID=923672208632
export AWS_PAGER=""
export APP_NAME="linuxtips-app"

# App CI
echo "APP - LINT"

pushd app/
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.59.1
golangci-lint run ./... -E errcheck

echo "APP - TEST"
go test -v ./...

popd

# Terraform CI
echo "TERRAFORM - CI"

pushd terraform/

echo "TERRAFORM - FORMAT CHECK"
terraform fmt -recursive -check

echo "TERRAFORM - VALIDATE"
terraform validate

popd

# App Build
echo "APP BUILD"

pushd app/

GIT_COMMIT_HASH=$(git rev-parse --short HEAD)
echo "GIT_COMMIT_HASH: $GIT_COMMIT_HASH"

echo "APP BUILD - ECR LOGIN"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

set +e

REPO_NAME="linuxtips/$APP_NAME"
REPO_EXISTS=$(aws ecr describe-repositories --repository-names $REPO_NAME 2>&1)

if [[ $REPO_EXISTS == *"RepositoryNotFoundException"* ]]; then
  echo "APP BUILD - CREATE ECR REPOSITORY"
  aws ecr create-repository --repository-name $REPO_NAME

  if [ $? -ne 0 ]; then
    echo "APP BUILD - CREATE ECR REPOSITORY FAILED"
    exit 1
  fi

else
  echo "APP BUILD - ECR REPOSITORY EXISTS"
fi

set -e

echo "APP BUILD - BUILD"
docker build -t app .
docker tag app:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_NAME:$GIT_COMMIT_HASH

echo "APP BUILD - PUSH"
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_NAME:$GIT_COMMIT_HASH

# App Publish

# Terraform Apply