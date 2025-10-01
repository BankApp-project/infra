#!/bin/bash

set -e

echo "Creating Docker networks..."
./create-docker-networks.sh

echo "Cloning frontend repository..."
./clone-fe.sh

echo "Starting infra-proxy..."
cd infra-proxy && docker compose up -d && cd ..

echo "Starting infra-messaging..."
cd infra-messaging && docker compose up -d && cd ..

echo "Starting auth-service..."
cd auth-service && docker compose up -d && cd ..

echo "Starting notification-service..."
cd notification-service && docker compose up -d && cd ..

echo "All services started successfully!"