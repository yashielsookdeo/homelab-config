#!/bin/bash

# Simple setup script for NGINX Proxy Manager and DuckDNS
# This script creates the necessary directories and sets permissions

# Create directories
echo "Creating directories..."
mkdir -p /portainer/Files/AppData/Config/duckdns
mkdir -p /portainer/Files/AppData/Config/npm

# Set permissions
echo "Setting permissions..."
sudo chown -R 1000:1000 /portainer/Files/AppData/Config/duckdns
sudo chown -R 1000:1000 /portainer/Files/AppData/Config/npm
sudo chmod -R 755 /portainer/Files/AppData/Config/duckdns
sudo chmod -R 755 /portainer/Files/AppData/Config/npm

# Check if ports are available
echo "Checking if required ports are available..."
PORT_80=$(netstat -tuln | grep ":80 " | wc -l)
PORT_81=$(netstat -tuln | grep ":81 " | wc -l)
PORT_443=$(netstat -tuln | grep ":443 " | wc -l)

if [ $PORT_80 -gt 0 ]; then
  echo "WARNING: Port 80 is already in use. NPM may not start correctly."
fi

if [ $PORT_81 -gt 0 ]; then
  echo "WARNING: Port 81 is already in use. NPM admin interface may not be accessible."
fi

if [ $PORT_443 -gt 0 ]; then
  echo "WARNING: Port 443 is already in use. NPM HTTPS may not work correctly."
fi

echo "Setup complete!"
echo "You can now start the services with: docker-compose -f hyperion/duckdns-npm.yml up -d"
echo ""
echo "Access the NPM admin interface at: http://your-server-ip:81"
echo "Default login credentials will be shown in the NPM logs after first startup."
echo "Check logs with: docker logs nginx-proxy-manager"
