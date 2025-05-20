# DuckDNS and NGINX Proxy Manager Stack

This Docker Compose configuration sets up DuckDNS for automatic IP address updates and NGINX Proxy Manager for reverse proxy management. It's designed to be deployed as a stack in Portainer.

## Services

### DuckDNS

DuckDNS is a free dynamic DNS service that allows you to point a subdomain to your home IP address. This container will automatically update your DuckDNS subdomain(s) with your current IP address.

- **Image**: LinuxServer.io DuckDNS
- **Configuration**: Stored at `/portainer/Files/AppData/Config/duckdns`
- **Updates**: Automatically updates your IP address every 5 minutes

### NGINX Proxy Manager

NGINX Proxy Manager provides a user-friendly web interface to configure NGINX as a reverse proxy with SSL termination.

- **Image**: jc21/nginx-proxy-manager
- **Configuration**: Stored at `/portainer/Files/AppData/Config/npm`
- **Ports**:
  - 80: HTTP
  - 443: HTTPS
  - 81: Admin Web UI

### MariaDB

A database for NGINX Proxy Manager to store its configuration.

- **Image**: mariadb:latest
- **Data**: Stored at `/portainer/Files/AppData/Config/npm/mysql`

## Setup Instructions

### Prerequisites

1. A DuckDNS account and subdomain(s)
2. Your DuckDNS token

### Deployment Steps

1. **Prepare the Configuration**:
   - Edit the `duckdns-npm.yml` file
   - Replace `your-domain` with your DuckDNS subdomain(s) (comma-separated if multiple)
   - Replace `your-token` with your DuckDNS token

2. **Create Required Directories**:
   ```bash
   sudo mkdir -p /portainer/Files/AppData/Config/duckdns
   sudo mkdir -p /portainer/Files/AppData/Config/npm/data
   sudo mkdir -p /portainer/Files/AppData/Config/npm/letsencrypt
   sudo mkdir -p /portainer/Files/AppData/Config/npm/mysql
   ```

3. **Deploy in Portainer**:
   - Go to Stacks in Portainer
   - Click "Add stack"
   - Name your stack (e.g., "duckdns-npm")
   - Paste the contents of `duckdns-npm.yml`
   - Click "Deploy the stack"

## Accessing NGINX Proxy Manager

After deployment, you can access the NGINX Proxy Manager admin interface at:

```
http://your-server-ip:81
```

Default login credentials:
- Email: `admin@example.com`
- Password: `changeme`

**Important**: Change the default credentials immediately after first login.

## Using NGINX Proxy Manager with DuckDNS

1. Log in to NGINX Proxy Manager
2. Add a new proxy host:
   - Domain Names: `your-subdomain.duckdns.org`
   - Scheme: `http`
   - Forward Hostname/IP: The internal IP of the service you want to proxy
   - Forward Port: The port of the service you want to proxy
3. Enable SSL (optional):
   - Request a new SSL certificate with Let's Encrypt

## Troubleshooting

### DuckDNS Not Updating

If you see errors like "Something went wrong" or "KO" in the logs:

1. **Verify your token and subdomain**:
   - Double-check that your DuckDNS token is correct
   - Ensure your subdomain is spelled correctly
   - Try logging into the DuckDNS website to confirm your credentials

2. **Check IP detection**:
   - The container might be having trouble detecting your public IP
   - Add `VALIDATION=true` to the environment variables (already included in the updated config)
   - You can also try specifying your IP manually with `SUBDOMAINS=subdomain,ipv4-address`

3. **Check network connectivity**:
   - Ensure the container can reach the DuckDNS servers (www.duckdns.org)
   - Try running `docker exec -it duckdns ping www.duckdns.org`

4. **Check the logs**:
   ```bash
   docker logs duckdns
   ```

5. **Check the update script**:
   ```bash
   docker exec -it duckdns cat /app/duck.sh
   ```

### NGINX Proxy Manager Issues

1. **Database connection issues**:
   - Check if the MariaDB container is running: `docker ps | grep npm-db`
   - Verify the database credentials in the docker-compose file

2. **Permission issues**:
   - Ensure the volume directories have the correct permissions
   - Try: `sudo chown -R 1000:1000 /portainer/Files/AppData/Config/npm`

3. **Check the logs**:
   ```bash
   docker logs nginx-proxy-manager
   docker logs npm-db
   ```

4. **First-time setup issues**:
   - If you can't access the admin interface, try restarting the container
   - If the default credentials don't work, the database might not be initializing correctly

## Maintenance

### Updating the Stack

To update the services to their latest versions:

1. In Portainer, go to your stack
2. Click "Editor"
3. Make any necessary changes
4. Click "Update the stack"

### Backing Up Configuration

The configuration is stored in the volumes at `/portainer/Files/AppData/Config/`. Back up these directories to preserve your settings.
