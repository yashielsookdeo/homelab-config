#!/bin/bash

# Setup script for SonarQube Elasticsearch requirements
# This script sets the required kernel parameters for Elasticsearch

echo "Setting kernel parameters for Elasticsearch..."
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144

echo "Elasticsearch kernel parameters set successfully!"
echo "You can now deploy SonarQube in Portainer."
