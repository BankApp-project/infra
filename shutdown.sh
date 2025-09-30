#!/bin/bash

set -e # Exit immediately if any command fails

# Configuration
COMPOSE_DIR="compose"

# Compose file names
PROXY_FILE="infra-proxy.yml"
MESSAGING_FILE="infra-messaging.yml"
AUTH_FILE="auth-stack.yml"
NOTIFICATION_FILE="notification-service.yml"

# Function to run docker compose down
run_compose_down() {
  local file=$1
  local description=$2

  echo ""
  echo "=========================================="
  echo "Stopping: $description"
  echo "File: $file"
  echo "=========================================="

  # Check if file exists
  if [ ! -f "$file" ]; then
    echo "WARNING: Compose file not found: $file (skipping)"
    return 0
  fi

  # Stop the services
  docker compose -f "$file" down

  echo "✓ Successfully stopped $description"
}

# Main execution
main() {
  echo "=========================================="
  echo "Infrastructure Shutdown Script"
  echo "=========================================="

  # Check if compose directory exists
  if [ ! -d "$COMPOSE_DIR" ]; then
    echo "ERROR: Compose directory '$COMPOSE_DIR' not found!"
    exit 1
  fi

  # Stop services in reverse order
  run_compose_down "$COMPOSE_DIR/$NOTIFICATION_FILE" "Notification Service"
  run_compose_down "$COMPOSE_DIR/$AUTH_FILE" "Auth Stack"
  run_compose_down "$COMPOSE_DIR/$MESSAGING_FILE" "Messaging Infrastructure"
  run_compose_down "$COMPOSE_DIR/$PROXY_FILE" "Edge/Proxy Layer"

  echo ""
  echo "=========================================="
  echo "✓ All services stopped successfully!"
  echo "=========================================="
}

# Run main function
main
