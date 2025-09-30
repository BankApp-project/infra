#!/bin/bash

# Script to create Docker network for bank application infrastructure

NETWORK_NAME="bankapp-infra"

echo "Creating Docker network: $NETWORK_NAME"

# Check if network already exists
if docker network ls | grep -q "$NETWORK_NAME"; then
  echo "Network '$NETWORK_NAME' already exists."
  exit 0
fi

# Create the Docker network
if docker network create "$NETWORK_NAME"; then
  echo "Network '$NETWORK_NAME' created successfully!"
else
  echo "Failed to create network '$NETWORK_NAME'"
  exit 1
fi
