# Headscale Setup Guide

Headscale is a self-hosted control server for Tailscale. It's CLI-only and requires manual setup after installation.

## What LabStart Does For You
- Installs Headscale server container
- Mounts config directory at `~/LabStart/config/headscale`

## What You Need To Do

### 1. Create Admin User
First, create a user namespace:

```bash
sudo docker exec headscale headscale users create admin
```

### 2. Configure Your Server URL
Edit the Headscale config to use your domain or IP:

```bash
nano ~/LabStart/config/headscale/config.yaml
```

Find and update:
```yaml
server_url: http://YOUR_SERVER_IP_OR_DOMAIN:8085
```

Save and restart:
```bash
sudo docker restart headscale
```

### 3. Port Forward (Optional)
If you want external access, forward **port 8085/TCP** to your server's IP.

### 4. Generate Pre-Auth Keys
Create authentication keys for your devices:

```bash
sudo docker exec headscale headscale preauthkeys create --user admin --reusable --expiration 24h
```

Copy the key that's output.

### 5. Connect Devices

**Install Tailscale on your device:**
- Desktop: https://tailscale.com/download
- Mobile: Install Tailscale app from app store

**Connect to your Headscale server:**

```bash
# Linux/Mac
sudo tailscale up --login-server=http://YOUR_SERVER_IP:8085 --authkey=YOUR_PREAUTH_KEY

# Windows (PowerShell as Admin)
tailscale up --login-server=http://YOUR_SERVER_IP:8085 --authkey=YOUR_PREAUTH_KEY
```

Replace `YOUR_SERVER_IP` and `YOUR_PREAUTH_KEY` with your values.

### 6. Verify Connected Devices

```bash
sudo docker exec headscale headscale nodes list
```

### 7. Add More Devices
Generate a new pre-auth key and repeat step 5 on each device.

## Troubleshooting

**Devices won't connect?**
- Verify `server_url` in config.yaml is correct
- Check firewall allows port 8085
- Restart Headscale: `sudo docker restart headscale`

**Can't create users?**
- Check container is running: `sudo docker ps | grep headscale`
- View logs: `sudo docker logs headscale`

**Need to remove a device?**
```bash
sudo docker exec headscale headscale nodes delete --identifier DEVICE_ID
```

Get DEVICE_ID from `headscale nodes list`.

**Want a web UI?**
Headscale doesn't have an official web UI, but third-party options exist:
- https://github.com/GoodiesHQ/headscale-admin (community project)

**Need help?** Open an issue: https://github.com/endergate/LabStart/issues