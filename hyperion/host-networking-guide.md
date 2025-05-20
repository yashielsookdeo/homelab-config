# Host Networking Guide for NGINX Proxy Manager

This guide explains how to troubleshoot and optimize the NGINX Proxy Manager (NPM) stack when using host networking mode.

## Understanding Host Networking

When using `network_mode: host`, Docker containers share the host's network namespace. This means:

1. Containers use the host's IP address directly
2. Containers bind directly to ports on the host
3. No port mapping is needed (or possible)
4. Containers can communicate with each other via localhost (127.0.0.1)

## Common Issues with Host Networking

### 1. Port Conflicts

**Problem**: Since containers bind directly to host ports, only one service can use each port.

**Solution**:
- Ensure no other services are using ports 80, 81, 443, and 3306
- Check with: `sudo netstat -tulpn | grep -E ':80|:81|:443|:3306'`
- Stop any conflicting services before starting NPM

### 2. Permission Issues

**Problem**: Binding to privileged ports (below 1024) requires root privileges.

**Solution**:
- Run NPM as root user (already configured in our setup)
- Ensure proper directory permissions (use the setup-npm-permissions.sh script)

### 3. Database Connection Issues

**Problem**: With host networking, container DNS resolution works differently.

**Solution**:
- Use 127.0.0.1 instead of container names for connections
- Ensure the database is configured to listen on 127.0.0.1
- Check database logs: `docker logs npm-db`

## Troubleshooting Steps

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

### If Database Won't Connect

1. **Check database logs**:
   ```bash
   docker logs npm-db
   ```

2. **Verify database is running**:
   ```bash
   docker ps | grep npm-db
   ```

3. **Test database connection**:
   ```bash
   docker exec -it npm-db mysql -u npm -p
   # Enter password: npm
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

## Advantages of Host Networking for NPM

1. **Simplified Network Configuration**: No need for complex network setups
2. **Direct Access to Host Network**: Better for services that need to discover the real IP
3. **Improved Performance**: Slightly better network performance without Docker's network overhead
4. **Easier Firewall Management**: Only need to configure the host firewall

## Recommended Security Practices

1. **Restrict Database Access**:
   - MariaDB is configured to only listen on 127.0.0.1
   - This prevents external access to your database

2. **Use Strong Passwords**:
   - Change the default NPM admin password immediately
   - Use a strong password for the MariaDB root user

3. **Keep Containers Updated**:
   - Regularly update your containers for security patches
   - Use Watchtower for automatic updates

4. **Monitor Logs**:
   - Regularly check logs for suspicious activity
   - Consider setting up log rotation

## Additional Resources

- [Docker Host Networking Documentation](https://docs.docker.com/network/host/)
- [NGINX Proxy Manager Documentation](https://nginxproxymanager.com/)
- [MariaDB Security Documentation](https://mariadb.com/kb/en/securing-mariadb/)
