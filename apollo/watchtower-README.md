# Watchtower Stack for Portainer

This file contains a single Docker Compose configuration for deploying Watchtower with Prometheus and Grafana monitoring as a stack in Portainer.

## Deployment Instructions

### 1. Prepare the Stack

1. Copy the contents of `watchtower.yml` to your clipboard.

### 2. Deploy in Portainer

1. Log in to your Portainer instance.
2. Navigate to "Stacks" in the left sidebar.
3. Click "Add stack".
4. Give your stack a name (e.g., "watchtower").
5. In the "Web editor" tab, paste the contents of `watchtower.yml`.
6. Before deploying, update the following values:
   - Replace `your-secure-token-here` with a secure token (in both the Watchtower environment and Prometheus config)
   - Replace `secure-password-here` with a secure password for Grafana admin
7. Click "Deploy the stack".

## Stack Components

The stack includes:

1. **Watchtower** - Automatically updates Docker containers to the latest version
   - Container name: `watchtower`
   - Port: 8081 (mapped to container port 8080)
   - API token required for access
   - Data stored at: `/portainer/Files/AppData/Config/watchtower`

2. **Prometheus** - Collects and stores metrics from Watchtower
   - Container name: `prometheus`
   - Port: 9092 (mapped to container port 9090)
   - Configuration embedded in the stack file
   - Data stored at: `/portainer/Files/AppData/Config/prometheus`

3. **Grafana** - Visualizes the metrics collected by Prometheus
   - Container name: `grafana`
   - Port: 3001 (mapped to container port 3000)
   - Default username: admin
   - Password: As specified during deployment
   - Data stored at: `/portainer/Files/AppData/Config/grafana`

## Accessing the Services

After deployment, you can access the services at:

- Watchtower API: http://your-server-ip:8081
- Prometheus: http://your-server-ip:9092
- Grafana: http://your-server-ip:3001

## Configuration Notes

- All services are on a dedicated bridge network called `apollo-watchtower-network`
- Data is stored in the standard Portainer location at `/portainer/Files/AppData/Config/`
- The configuration includes all necessary settings embedded in the stack file
- Make sure the directories exist before deploying:
  ```bash
  mkdir -p /portainer/Files/AppData/Config/watchtower
  mkdir -p /portainer/Files/AppData/Config/prometheus
  mkdir -p /portainer/Files/AppData/Config/grafana
  ```

## Customization

You can customize the stack by:

1. Uncommenting and configuring the notification settings in the Watchtower service
2. Adjusting the poll interval (default is once per day)
3. Adding additional scrape targets to Prometheus
4. Installing additional plugins for Grafana
