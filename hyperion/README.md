# Hyperion Media Server Stack

This directory contains Docker Compose configurations for the Hyperion media server setup. The configuration is designed to be deployed as a stack in Portainer.

## Media Server Stack

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

## Setup Instructions

### Prerequisites

1. Ensure Docker and Portainer are installed on your Hyperion server
2. Make sure the NFS mount is properly set up at `/mnt/nfs/media`
3. Create the necessary configuration directories:

```bash
sudo mkdir -p /portainer/Files/AppData/Config/Plex
sudo mkdir -p /portainer/Files/AppData/Config/Jellyfin
sudo mkdir -p /portainer/Files/AppData/Config/Jellyfin/cache
sudo mkdir -p /portainer/Files/AppData/Config/Emby
sudo mkdir -p /portainer/Files/AppData/Config/Bazarr
sudo mkdir -p /portainer/Files/AppData/Config/Tautulli
sudo mkdir -p /portainer/Files/AppData/Config/Overseerr
```

### Deployment

1. In Portainer, navigate to "Stacks"
2. Click "Add stack"
3. Name your stack (e.g., "hyperion-media")
4. Paste the contents of `media-servers.yml`
5. Update the Plex claim code and Jellyfin server URL
6. Click "Deploy the stack"

## Configuration Notes

### Plex Media Server

- You'll need to obtain a Plex claim code from https://plex.tv/claim
- Replace `claim-xxxxxxxxxxxxxxxxxxxxx` with your actual claim code
- The claim code is only valid for 4 minutes, so deploy quickly after generating it

### Jellyfin Media Server

- Update the `JELLYFIN_PublishedServerUrl` with your Hyperion server's IP address
- Hardware acceleration is set to use Intel QuickSync (QSV)

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
