#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# The location of the file defining our production services.
COMPOSE_FILE="compose.prod.yml"

# The location of our secret environment variables.
ENV_FILE=".env"

# --- Pre-flight Checks ---
# Ensure the secrets file exists before we proceed.
if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: The environment file '$ENV_FILE' was not found."
    echo "Please create it before running the deployment."
    exit 1
fi

# --- Deployment Steps ---

echo "--- Loading environment variables from $ENV_FILE ---"
# Load the environment variables from the .env file.
# These will be available to this script and to docker-compose.
export $(grep -v '^#' $ENV_FILE | xargs)

echo "--- Logging into Docker Registry: $DOCKER_REGISTRY_URL ---"
# Use the credentials from the .env file to log in to your private registry.
echo "$DOCKER_REGISTRY_PASSWORD" | docker login $DOCKER_REGISTRY_URL -u "$DOCKER_REGISTRY_USER" --password-stdin

echo "--- Pulling the latest service images ---"
# Explicitly pull the latest versions of the images. This ensures we don't
# accidentally run old, cached versions of the images.
docker pull $DOCKER_REGISTRY_URL/api-gateway:latest
docker pull $DOCKER_REGISTRY_URL/auth-service:latest
docker pull $DOCKER_REGISTRY_URL/account-service:latest

echo "--- Shutting down any old running services ---"
# Use docker-compose to bring down the old stack if it's running.
# The `-v` flag removes anonymous volumes, ensuring a clean state.
docker-compose -f $COMPOSE_FILE down -v

echo "--- Starting the new application stack ---"
# Start the new application stack in detached mode (-d).
# Docker-compose will automatically use the new images we just pulled.
docker-compose -f $COMPOSE_FILE up -d

echo "--- Deployment Complete! ---"
