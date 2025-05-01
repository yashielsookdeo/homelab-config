# Homelab Configuration

This repository contains configuration files and documentation for my personal homelab setup, consisting of three servers: Titan, Hyperion, and Apollo. Each server has a specific role in the homelab ecosystem, running various services for media management, backups, and more.

## Server Specifications

### Titan
- **OS**: Proxmox
- **CPU**: Intel Xeon E5606
- **RAM**: 16GB DDR3 1333MHz
- **Storage**: 6×2TB WD Purple + 256GB SSD
- **RAID**: Intel RS2BL040

### Hyperion
- **OS**: Ubuntu Server
- **CPU**: Intel Xeon E5620
- **RAM**: 16GB DDR3 1333MHz
- **Storage**: 6×4TB WD Purple + 256GB SSD

### Apollo
- **OS**: Ubuntu Server
- **CPU**: Intel i3 4150T
- **RAM**: 8GB DDR3
- **Storage**: 256GB SSD + 2×2TB SSDs

## Repository Structure

```
homelab-config/
├── apollo/           # Apollo server configurations
│   ├── arrarray.yml         # Prowlarr, Radarr, Sonarr configuration
│   ├── nginxproxymanager.yml # Nginx Proxy Manager configuration
│   ├── plex.yml             # Plex Media Server configuration
│   ├── timemachine.yml      # Time Machine backup service configuration
│   └── transmission.yml     # Transmission torrent client configuration
├── hyperion/         # Hyperion server configurations
└── titan/            # Titan server configurations
```

## Services Overview

### Apollo Services

#### Media Management
- **Plex**: Media server for organizing and streaming movies, TV shows, music, and photos
- **Sonarr**: TV show management and automated downloads
- **Radarr**: Movie management and automated downloads
- **Prowlarr**: Indexer manager/proxy for Sonarr, Radarr, etc.

#### Download Management
- **Transmission**: BitTorrent client for downloading media

#### Backup Solutions
- **Time Machine**: Backup service for macOS devices

#### Network Management
- **Nginx Proxy Manager**: Web proxy for managing access to services with SSL support

## Setup and Usage

### Prerequisites
- Docker and Docker Compose installed on the respective servers
- Proper network configuration for inter-server communication
- Storage volumes properly mounted and accessible

### Deployment

To deploy services on Apollo:

1. Clone this repository:
   ```bash
   git clone https://github.com/yashielsookdeo/homelab-config.git
   cd homelab-config
   ```

2. Navigate to the server directory:
   ```bash
   cd apollo
   ```

3. Deploy a specific service:
   ```bash
   docker-compose -f plex.yml up -d
   ```

4. Or deploy all services:
   ```bash
   for file in *.yml; do docker-compose -f $file up -d; done
   ```

## Maintenance

### Updating Services

To update a service to the latest version:

```bash
docker-compose -f service.yml pull
docker-compose -f service.yml up -d
```

### Backup Configuration

It's recommended to regularly back up the configuration directories:

```bash
# Example backup command
tar -czf homelab-config-backup-$(date +%Y%m%d).tar.gz /path/to/homelab-config
```

## Contributing

This repository is primarily for personal use, but suggestions and improvements are welcome. Feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
