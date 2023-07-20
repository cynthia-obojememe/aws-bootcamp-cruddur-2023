#!/bin/bash

# Set up PostgreSQL
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get install -y postgresql-client-13 libpq-dev
sudo apt-get install -y apt-utils

# Export environment variable GITPOD_IP
export GITPOD_IP=$(curl ifconfig.me)

# Run your desired command
source "/workspaces/aws-bootcamp-cruddur-2023/backend-flask/bin/db-update-sg-rule"
