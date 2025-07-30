#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# This MUST match the compose file used in your deploy.sh script
# to ensure you're shutting down the correct stack.
COMPOSE_FILE="compose.prod.yml"


# --- Pre-flight Checks ---
# A simple check to see if the compose file exists.
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "ERROR: The compose file '$COMPOSE_FILE' was not found."
    echo "Cannot determine which services to shut down."
    exit 1
fi


# --- Shutdown Logic ---

echo "--- Shutting down the application stack defined in $COMPOSE_FILE ---"

# The 'down' command is the inverse of 'up'. It stops all the containers
# and removes the networks created by docker-compose.
#
# IMPORTANT: By default, 'down' does NOT remove named volumes like our
# 'postgres-data'. This is a safety feature to prevent accidental data loss.
# We also use '--remove-orphans' to clean up any containers for services
# that may have been removed from the compose file.
docker-compose -f $COMPOSE_FILE down --remove-orphans

echo "--- Application has been shut down successfully. ---"
