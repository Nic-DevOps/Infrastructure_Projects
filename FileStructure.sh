#!/bin/bash

# Confirm we're in Infrastructure_Projects directory
EXPECTED_DIR="Infrastructure_Projects"
CURRENT_DIR_NAME=$(basename "$PWD")

if [ "$CURRENT_DIR_NAME" != "$EXPECTED_DIR" ]; then
  echo "Error: Please run this script from inside the '$EXPECTED_DIR' directory."
  echo "Current directory: $CURRENT_DIR_NAME"
  exit 1
fi

# Define project name and root
PROJECT_NAME="Project_5_GCP_HTTP_Server"
PROJECT_ROOT="./$PROJECT_NAME"

# Create folder structure
mkdir -p "$PROJECT_ROOT/terraform"
mkdir -p "$PROJECT_ROOT/ansible/roles/webserver/tasks"
mkdir -p "$PROJECT_ROOT/ansible/roles/webserver/handlers"
mkdir -p "$PROJECT_ROOT/files"

# Create empty files
touch "$PROJECT_ROOT/terraform/main.tf"
touch "$PROJECT_ROOT/terraform/variables.tf"
touch "$PROJECT_ROOT/terraform/outputs.tf"

touch "$PROJECT_ROOT/ansible/inventory.ini"
touch "$PROJECT_ROOT/ansible/playbook.yml"
touch "$PROJECT_ROOT/ansible/roles/webserver/tasks/main.yml"
touch "$PROJECT_ROOT/ansible/roles/webserver/handlers/main.yml"

touch "$PROJECT_ROOT/files/index.html"
touch "$PROJECT_ROOT/README.md"

echo "✅ Project 5 directory structure created successfully in $PROJECT_ROOT"
