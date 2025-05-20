#!/bin/bash

# This script sets up the correct permissions for NGINX Proxy Manager directories
# Run this script before starting the NPM stack
#
# IMPORTANT: All services in this stack use host networking
# Make sure ports 80, 81, 443, and 3306 are not in use by other services

# Create directories if they don't exist
mkdir -p /portainer/Files/AppData/Config/npm/data
mkdir -p /portainer/Files/AppData/Config/npm/letsencrypt
mkdir -p /portainer/Files/AppData/Config/npm/mysql

# Set ownership to root for NPM directories (since we're running as root)
sudo chown -R root:root /portainer/Files/AppData/Config/npm/data
sudo chown -R root:root /portainer/Files/AppData/Config/npm/letsencrypt

# Set ownership to 1000:1000 for MariaDB directory
sudo chown -R 1000:1000 /portainer/Files/AppData/Config/npm/mysql

# Set permissions
sudo chmod -R 755 /portainer/Files/AppData/Config/npm

# Check if ports are already in use
echo "Checking if required ports are available..."
PORT_80=$(netstat -tuln | grep ":80 " | wc -l)
PORT_81=$(netstat -tuln | grep ":81 " | wc -l)
PORT_443=$(netstat -tuln | grep ":443 " | wc -l)
PORT_3306=$(netstat -tuln | grep ":3306 " | wc -l)

if [ $PORT_80 -gt 0 ]; then
  echo "WARNING: Port 80 is already in use. NPM may not start correctly."
fi

if [ $PORT_81 -gt 0 ]; then
  echo "WARNING: Port 81 is already in use. NPM admin interface may not be accessible."
fi

if [ $PORT_443 -gt 0 ]; then
  echo "WARNING: Port 443 is already in use. NPM HTTPS may not work correctly."
fi

if [ $PORT_3306 -gt 0 ]; then
  echo "WARNING: Port 3306 is already in use. MariaDB may not start correctly."
fi

echo "Permissions set successfully for NGINX Proxy Manager directories"
echo "You can now start the NPM stack with: docker-compose -f hyperion/duckdns-npm.yml up -d"
echo ""
echo "Access the NPM admin interface at: http://your-server-ip:81"
echo "Default login: admin@example.com / changeme"
