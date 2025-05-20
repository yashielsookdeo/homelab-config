#!/bin/bash

# This script sets up the correct permissions for NGINX Proxy Manager directories
# Run this script before starting the NPM stack

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

echo "Permissions set successfully for NGINX Proxy Manager directories"
echo "You can now start the NPM stack"
