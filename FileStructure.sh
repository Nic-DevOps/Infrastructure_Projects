#!/bin/bash

# Define project root inside the infrastructure_projects directory
ROOT_DIR="infrastructure_projects"
PROJECT_NAME="Project_5_GCP_HTTP_Server"
PROJECT_ROOT="$ROOT_DIR/$PROJECT_NAME"

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

echo "Project 5 directory structure created successfully in $PROJECT_ROOT."
