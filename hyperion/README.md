# Hyperion Homelab Configuration

This directory contains Docker Compose configurations for the Hyperion server setup. All configurations are designed to be deployed as stacks in Portainer.

## Directory Structure

```
hyperion/
├── arrarray.yml         # Arr suite (Radarr, Sonarr, etc.) configuration
├── duckdns-npm.yml      # DuckDNS and NGINX Proxy Manager configuration
├── filebrowser.yml      # File Browser configuration
├── media-servers.yml    # Media servers (Plex, Jellyfin, Emby) configuration
├── timemachine.yml      # Time Machine backup configuration
├── watchtower.yml       # Watchtower, Prometheus, and Grafana configuration
└── README.md            # This file
```

## Storage Paths

- Media files: `/mnt/nfs/media`
- Downloads: `/mnt/nfs/download`
- Configuration: `/portainer/Files/AppData/Config/`

## Network Configuration

All services use dedicated bridge networks to isolate traffic, except for:
- Media servers (Plex, Jellyfin, Emby) use host networking for optimal performance
- DuckDNS uses host networking for proper IP detection
- Time Machine uses host networking for proper discovery

## Service Ports

Since Hyperion runs at a different location (IP: 192.168.101.235) than Apollo, standard ports are used:

| Service                | Port  | Description                |
|------------------------|-------|----------------------------|
| File Browser           | 8080  | Web-based file management  |
| Watchtower             | 8080  | Container updates          |
| NGINX Proxy Manager    | 80, 443, 81 | Reverse proxy (HTTP, HTTPS, Admin) |
| Transmission           | 9091  | Download client            |
| Prometheus             | 9090  | Metrics collection         |
| Prowlarr               | 9696  | Indexer management         |
| Radarr                 | 7878  | Movie management           |
| Sonarr                 | 8989  | TV show management         |
| Bazarr                 | 6767  | Subtitle management        |
| Grafana                | 3000  | Metrics visualization      |
| Plex                   | 32400 | Media server               |
| Jellyfin               | 8096  | Media server               |
| Emby                   | 8096  | Media server               |
| Tautulli               | 8181  | Plex monitoring            |
| Overseerr              | 5055  | Media requests             |

## Stack Descriptions

### Media Server Stack

The `media-servers.yml` file includes the following services:

### Core Media Servers

1. **Plex Media Server**
   - Container name: `plex`
   - Network mode: `host`
   - Web UI: http://[server-ip]:32400/web
   - Config location: `/portainer/Files/AppData/Config/Plex`
   - Media location: `/mnt/nfs/media`

2. **Jellyfin Media Server**
   - Container name: `jellyfin`
   - Network mode: `host`
   - Web UI: http://[server-ip]:8096
   - Config location: `/portainer/Files/AppData/Config/Jellyfin`
   - Media location: `/mnt/nfs/media`

3. **Emby Media Server**
   - Container name: `emby`
   - Network mode: `host`
   - Web UI: http://[server-ip]:8096
   - Config location: `/portainer/Files/AppData/Config/Emby`
   - Media location: `/mnt/nfs/media`

### Supporting Services

4. **Bazarr** - Subtitle Management
   - Container name: `bazarr`
   - Port: 6767
   - Web UI: http://[server-ip]:6767
   - Config location: `/portainer/Files/AppData/Config/Bazarr`
   - Media location: `/mnt/nfs/media`

5. **Tautulli** - Plex Monitoring
   - Container name: `tautulli`
   - Port: 8181
   - Web UI: http://[server-ip]:8181
   - Config location: `/portainer/Files/AppData/Config/Tautulli`

6. **Overseerr** - Media Request Management
   - Container name: `overseerr`
   - Port: 5055
   - Web UI: http://[server-ip]:5055
   - Config location: `/portainer/Files/AppData/Config/Overseerr`

## Additional Stacks

### Arr Suite (arrarray.yml)

Media management and download services:
- Transmission (Download client)
- Prowlarr (Indexer management)
- Radarr (Movie management)
- Sonarr (TV show management)
- Bazarr (Subtitle management)

### Watchtower (watchtower.yml)

Container update and monitoring:
- Watchtower (Automatic container updates)
- Prometheus (Metrics collection)
- Grafana (Metrics visualization)

### DuckDNS and NGINX Proxy Manager (duckdns-npm.yml)

Domain and proxy management:
- DuckDNS (Dynamic DNS updates)
- NGINX Proxy Manager (Reverse proxy)
- MariaDB (Database for NGINX Proxy Manager)

### File Browser (filebrowser.yml)

Web-based file management:
- File Browser (Web UI for file management)

### Time Machine (timemachine.yml)

macOS backup solution:
- Time Machine (SMB-based backup for macOS)

## Setup Instructions

### Prerequisites

1. Ensure Docker and Portainer are installed on your Hyperion server
2. Make sure the NFS mounts are properly set up:
   ```bash
   sudo mkdir -p /mnt/nfs/media
   sudo mkdir -p /mnt/nfs/download
   ```
3. Create the necessary configuration directories:
   ```bash
   sudo mkdir -p /portainer/Files/AppData/Config/Plex
   sudo mkdir -p /portainer/Files/AppData/Config/Jellyfin
   sudo mkdir -p /portainer/Files/AppData/Config/Jellyfin/cache
   sudo mkdir -p /portainer/Files/AppData/Config/Emby
   sudo mkdir -p /portainer/Files/AppData/Config/Bazarr
   sudo mkdir -p /portainer/Files/AppData/Config/Tautulli
   sudo mkdir -p /portainer/Files/AppData/Config/Overseerr
   sudo mkdir -p /portainer/Files/AppData/Config/Transmission
   sudo mkdir -p /portainer/Files/AppData/Config/prowlarr/data
   sudo mkdir -p /portainer/Files/AppData/Config/radarr/data
   sudo mkdir -p /portainer/Files/AppData/Config/sonarr/data
   sudo mkdir -p /portainer/Files/AppData/Config/watchtower
   sudo mkdir -p /portainer/Files/AppData/Config/prometheus
   sudo mkdir -p /portainer/Files/AppData/Config/grafana
   sudo mkdir -p /portainer/Files/AppData/Config/duckdns
   sudo mkdir -p /portainer/Files/AppData/Config/npm/data
   sudo mkdir -p /portainer/Files/AppData/Config/npm/letsencrypt
   sudo mkdir -p /portainer/Files/AppData/Config/npm/mysql
   ```

### Deployment

1. In Portainer, navigate to "Stacks"
2. Click "Add stack"
3. Name your stack (e.g., "hyperion-media", "hyperion-arr", etc.)
4. Paste the contents of the corresponding YAML file
5. Update any necessary configuration values (like Plex claim code)
6. Click "Deploy the stack"

## Configuration Notes

### Plex Media Server

- You'll need to obtain a Plex claim code from https://plex.tv/claim
- Replace `claim-xxxxxxxxxxxxxxxxxxxxx` with your actual claim code
- The claim code is only valid for 4 minutes, so deploy quickly after generating it

### Hardware Acceleration Note

- Hyperion has a Matrox MGA G200e [Pilot] ServerEngines (SEP1) GPU
- This GPU does not support hardware transcoding
- All hardware acceleration has been disabled in the media server configurations
- For heavy transcoding workloads, consider using direct play or pre-transcoding your media

### Jellyfin Media Server

- The `JELLYFIN_PublishedServerUrl` is set to Hyperion's IP address (192.168.101.235)

### Network Configuration

- Plex, Jellyfin, and Emby use host networking for optimal performance and compatibility
- Supporting services (Bazarr, Tautulli, Overseerr) use bridge networking on the `media-stack-network`

## Maintenance

### Updating Containers

To update all containers to their latest versions:

1. In Portainer, go to your stack
2. Click "Editor"
3. Click "Update the stack"

### Accessing Logs

To view logs for a specific container:

```bash
docker logs [container-name]
```

For example:
```bash
docker logs plex
```
