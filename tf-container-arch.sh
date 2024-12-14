#!/bin/bash

# Arrays to hold directories
vpc_dirs=()
cluster_dirs=()
other_dirs=()
REPO_NAME="linuxtips/linuxtips-app"
REPO_EXISTS=$(aws ecr describe-repositories --repository-names $REPO_NAME 2>&1)

export AWS_REGION="us-east-1"

# Change directory to the root of the repository
cd ../

# Iterate through each directory in container-arch
for dir in */; do
  # Remove the trailing slash from the directory name
  dir=${dir%/}
  
  if [[ "$dir" == *"vpc"* ]]; then
    vpc_dirs+=("$dir")
  elif [[ "$dir" == *"cluster"* ]]; then
    cluster_dirs+=("$dir")
  else
    other_dirs+=("$dir")
  fi
done

# Function to destroy terraform infrastructure in a directory
destroy_terraform() {
  local dir=$1
  if [[ "$dir" == "container-arch--aws-ecs--module" ]]; then
    echo
    echo "Skipping directory: $dir"
    return
  fi
  if [[ "$dir" == "container-arch--aws-ecs--app" ]]; then
    pushd "$dir/terraform"

    if [[ $REPO_EXISTS != *"RepositoryNotFoundException"* ]]; then
      aws ecr delete-repository --repository-name "$REPO_NAME" --force --output text > /dev/null

      if [ $? -ne 0 ]; then
        echo "ECR delete failed"
        exit 1
      fi
    fi

  else
    pushd "$dir"
  fi
  terraform destroy --auto-approve -var-file="environment/dev/terraform.tfvars"
  popd
}

# Function to apply terraform infrastructure in a directory
apply_terraform() {
  local dir=$1

  if [[ "$dir" == "container-arch--aws-ecs--module" ]]; then
    echo
    echo "Skipping directory: $dir"
    return
  fi

  if [[ "$dir" == "container-arch--aws-ecs--app" ]]; then
    # Check if ECR repository exists

    if [[ $REPO_EXISTS == *"RepositoryNotFoundException"* ]]; then
      aws ecr create-repository --repository-name $REPO_NAME --output text > /dev/null  

      if [ $? -ne 0 ]; then
        echo "ECR create failed"
        exit 1
      fi
    fi

    # Push "fidelissauro/chip:v2" image to the ECR
    CONTAINER_IMAGE="923672208632.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:latest"
    docker pull fidelissauro/chip:v2
    docker tag fidelissauro/chip:v2 $CONTAINER_IMAGE
    docker push $CONTAINER_IMAGE
    pushd "$dir/terraform"

  else
    pushd "$dir"
  fi

  terraform apply --auto-approve -var-file="environment/dev/terraform.tfvars"
  popd

  if [[ "$dir" == "container-arch--aws-ecs--app" ]]; then
    pushd "$dir"
    ./pipeline.sh
    popd
  fi
}

case $1 in
  --apply|-a)
    # Ensure that user wants to apply infrastructure
    read -p "Are you sure you want to apply all infrastructure? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit 0
    fi

    # Apply vpc directories first
    for dir in "${vpc_dirs[@]}"; do
      apply_terraform "$dir"
    done

    # Apply cluster directories next
    for dir in "${cluster_dirs[@]}"; do
      apply_terraform "$dir"
    done

    # Apply other directories last
    for dir in "${other_dirs[@]}"; do
      apply_terraform "$dir"
    done
    exit 0
    ;;
  --destroy|-d)
    # Ensure that user wants to destroy infrastructure
    read -p "Are you sure you want to destroy all infrastructure? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit 0
    fi

    # Destroy other directories first
    for dir in "${other_dirs[@]}"; do
      destroy_terraform "$dir"
    done

    # Destroy cluster directories next
    for dir in "${cluster_dirs[@]}"; do
      destroy_terraform "$dir"
    done

    # Destroy vpc directories last
    for dir in "${vpc_dirs[@]}"; do
      destroy_terraform "$dir"
    done
    exit 0
    ;;
  *)
    echo "Usage: $0 [apply|destroy]"
    exit 1
    ;;
esac
