# Simple NGINX Proxy Manager and DuckDNS Setup

This guide explains the simplified setup for NGINX Proxy Manager (NPM) and DuckDNS on Hyperion.

## What's Different About This Setup?

1. **No External Database**: Using the jlesage/nginx-proxy-manager image which includes SQLite
2. **Host Networking**: Both services use host networking for direct access
3. **Simplified Configuration**: Minimal configuration for easier maintenance

## Setup Instructions

### 1. Prepare the Environment

Run the setup script to create directories and set permissions:

```bash
chmod +x hyperion/setup-npm-simple.sh
sudo ./hyperion/setup-npm-simple.sh
```

### 2. Deploy the Stack

```bash
docker-compose -f hyperion/duckdns-npm.yml up -d
```

### 3. Access NPM Admin Interface

- Go to http://[hyperion-ip]:81
- The default login credentials will be shown in the NPM logs
- Check logs with: `docker logs nginx-proxy-manager`

## Configuration Details

### DuckDNS

- Updates the "skynerhouse.duckdns.org" domain
- Uses host networking for proper IP detection
- Logs are stored in /portainer/Files/AppData/Config/duckdns

### NGINX Proxy Manager

- Uses SQLite instead of MySQL/MariaDB
- Runs with host networking
- All configuration stored in /portainer/Files/AppData/Config/npm

## Troubleshooting

### If NPM Won't Start

1. **Check for port conflicts**:
   ```bash
   sudo netstat -tulpn | grep -E ':80|:81|:443'
   ```

2. **Check NPM logs**:
   ```bash
   docker logs nginx-proxy-manager
   ```

3. **Verify permissions**:
   ```bash
   ls -la /portainer/Files/AppData/Config/npm/
   ```

### If DuckDNS Updates Fail

1. **Check DuckDNS logs**:
   ```bash
   docker logs duckdns
   ```

2. **Verify internet connectivity**:
   ```bash
   ping -c 4 www.duckdns.org
   ```

## Setting Up Proxy Hosts

1. Log in to the NPM admin interface
2. Go to "Hosts" → "Proxy Hosts"
3. Click "Add Proxy Host"
4. Enter the following:
   - Domain: skynerhouse.duckdns.org
   - Scheme: http
   - Forward Hostname/IP: The internal IP of the service
   - Forward Port: The port of the service
5. Enable SSL if desired (Let's Encrypt)

## Maintenance

### Updating Containers

```bash
docker-compose -f hyperion/duckdns-npm.yml pull
docker-compose -f hyperion/duckdns-npm.yml up -d
```

### Backing Up Configuration

```bash
sudo tar -czvf npm-backup.tar.gz /portainer/Files/AppData/Config/npm/
sudo tar -czvf duckdns-backup.tar.gz /portainer/Files/AppData/Config/duckdns/
```
