#!/bin/bash

set -e # Exit immediately if any command fails

# Configuration
COMPOSE_DIR="compose"

# Compose file names
PROXY_FILE="infra-proxy.yml"
MESSAGING_FILE="infra-messaging.yml"
AUTH_FILE="auth-stack.yml"
NOTIFICATION_FILE="notification-service.yml"

# Function to run docker compose
run_compose() {
  local file=$1
  local description=$2

  echo ""
  echo "=========================================="
  echo "Starting: $description"
  echo "File: $file"
  echo "=========================================="

  # Check if file exists
  if [ ! -f "$file" ]; then
    echo "ERROR: Compose file not found: $file"
    return 1
  fi

  # Start the services
  docker compose -f "$file" up -d

  echo "✓ Successfully started $description"
}

# Main execution
main() {
  echo "=========================================="
  echo "Infrastructure Deployment Script"
  echo "=========================================="

  # Check if compose directory exists
  if [ ! -d "$COMPOSE_DIR" ]; then
    echo "ERROR: Compose directory '$COMPOSE_DIR' not found!"
    exit 1
  fi

  # Start services in order
  run_compose "$COMPOSE_DIR/$PROXY_FILE" "Edge/Proxy Layer"
  run_compose "$COMPOSE_DIR/$MESSAGING_FILE" "Messaging Infrastructure"
  run_compose "$COMPOSE_DIR/$AUTH_FILE" "Auth Stack"
  run_compose "$COMPOSE_DIR/$NOTIFICATION_FILE" "Notification Service"

  echo ""
  echo "=========================================="
  echo "✓ All services started successfully!"
  echo "=========================================="
}

# Run main function
main
