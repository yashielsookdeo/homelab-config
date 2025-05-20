# NGINX Proxy Manager Troubleshooting Guide

This guide will help you resolve the "Invalid domain or IP" error when setting up domains in NGINX Proxy Manager (NPM).

## Common Issues and Solutions

### 1. Domain Not Resolving to Correct IP

**Problem**: NPM can't verify that your domain (skyner.duckdns.org) points to the server where NPM is running.

**Solutions**:

a) **Verify DuckDNS is updating correctly**:
   - Check DuckDNS logs: `docker logs duckdns`
   - Look for successful updates like "Updating DNS for skyner.duckdns.org"
   - If you see errors, check your token and subdomain settings

b) **Verify domain resolution**:
   ```bash
   nslookup skyner.duckdns.org
   ```
   - The result should show your server's public IP address
   - If not, wait a few minutes for DNS propagation or check DuckDNS settings

c) **Check your server's public IP**:
   ```bash
   curl ifconfig.me
   ```
   - Compare this with what DuckDNS shows for your domain

### 2. Network Configuration Issues

**Problem**: NPM might be running in a container network that can't properly access the internet.

**Solutions**:

a) **Use host networking for NPM**:
   - We've updated the configuration to use host networking
   - This ensures NPM can access the network directly

b) **Check firewall settings**:
   - Make sure ports 80 and 443 are open on your server
   - Check any router/firewall rules that might block these ports

### 3. Proxy Host Configuration

**Problem**: The proxy host settings in NPM might be incorrect.

**Solutions**:

a) **Correct proxy host setup**:
   - In NPM admin UI (http://your-server-ip:81)
   - Add a new proxy host with these settings:
     - Domain Names: skyner.duckdns.org (and *.skyner.duckdns.org if needed)
     - Scheme: http
     - Forward Hostname/IP: The internal IP of the service you want to proxy
     - Forward Port: The port of the service you want to proxy
   - Do NOT use "Block Common Exploits" initially (can cause issues)

b) **Test with a simple service first**:
   - Try setting up a proxy to a simple web server first
   - Once that works, move on to more complex services

### 4. SSL Certificate Issues

**Problem**: SSL certificate validation can fail if domain verification fails.

**Solutions**:

a) **Start without SSL**:
   - First set up the proxy without SSL
   - Verify it works with plain HTTP
   - Then add SSL once the basic proxy is working

b) **Use DNS validation for Let's Encrypt**:
   - If HTTP validation fails, try DNS validation instead
   - This requires additional setup with your DNS provider

## Step-by-Step Verification Process

1. **Verify DuckDNS is working**:
   ```bash
   docker logs duckdns
   ```

2. **Check domain resolution**:
   ```bash
   nslookup skyner.duckdns.org
   ```

3. **Verify NPM is running properly**:
   ```bash
   docker logs nginx-proxy-manager
   ```

4. **Restart NPM after configuration changes**:
   ```bash
   docker restart nginx-proxy-manager
   ```

5. **Access NPM admin interface**:
   - Go to http://your-server-ip:81
   - Default login: admin@example.com / changeme
   - Change credentials on first login

6. **Set up a basic proxy host and test**

## Additional Resources

- [NGINX Proxy Manager Documentation](https://nginxproxymanager.com/guide/)
- [DuckDNS Documentation](https://www.duckdns.org/spec.jsp)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
