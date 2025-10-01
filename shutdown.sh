#!/bin/bash

set -e

echo "Stopping notification-service..."
cd notification-service && docker compose down && cd ..

echo "Stopping auth-service..."
cd auth-service && docker compose down && cd ..

echo "Stopping infra-messaging..."
cd infra-messaging && docker compose down && cd ..

echo "Stopping infra-proxy..."
cd infra-proxy && docker compose down && cd ..

echo "All services stopped successfully!"