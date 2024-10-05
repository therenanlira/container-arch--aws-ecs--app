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

# App Build

# App Publish

# Terraform Apply