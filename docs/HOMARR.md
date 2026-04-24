# Homarr Setup Guide

Homarr is a modern dashboard with drag-and-drop customization. LabStart installs Homarr, but you need to add your service tiles manually through the web UI.

## Initial Setup

### 1. Access Homarr
Open your browser and go to `http://YOUR_SERVER_IP:7575`

### 2. Create Your Account
On first visit, create an admin account with a username and password.

### 3. Add Your Services
After logging in, you'll see the Homarr dashboard.

**To add a service tile:**
1. Click the **Settings icon** (gear) in the top right
2. Click **"Customize"** or **"Edit Mode"**
3. Click **"Add a tile"** or **"Add app"**
4. Fill in the details:
   - **Name**: Service name (e.g., "Pi-hole", "Plex")
   - **URL**: `http://YOUR_SERVER_IP:PORT` (see table below)
   - **Icon**: Select from the icon library or use a custom URL

### 4. Organize Your Dashboard
Drag and drop tiles to arrange them however you like.

## Service URLs

Here are the URLs for services installed by LabStart:

| Service | URL | Port |
|---------|-----|------|
| **Pi-hole** | `http://YOUR_IP:8080/admin` | 8080 |
| **AdGuard Home** | `http://YOUR_IP:3000` | 3000 |
| **Uptime Kuma** | `http://YOUR_IP:3001` | 3001 |
| **Netdata** | `http://YOUR_IP:19999` | 19999 |
| **Jellyfin** | `http://YOUR_IP:8096` | 8096 |
| **Plex** | `http://YOUR_IP:32400` | 32400 |
| **Emby** | `http://YOUR_IP:8097` | 8097 |
| **Portainer** | `http://YOUR_IP:9000` | 9000 |
| **Yacht** | `http://YOUR_IP:8001` | 8001 |

Replace `YOUR_IP` with your server's IP address (e.g., `10.2.20.254`).

## Customization Tips

**Themes:**
- Click Settings → Appearance
- Choose from built-in themes or customize colors
- Enable backdrop blur for a glass/frosted effect

**Widgets:**
- Add weather, clock, calendar, and other widgets
- Drag to reposition anywhere on your dashboard

**Categories:**
- Group related services together
- Create sections like "Media", "Monitoring", "Management"

## Troubleshooting

**Dashboard is blank after login?**
- This is normal — Homarr starts empty
- Follow the steps above to add your services

**Can't access Homarr?**
- Check container is running: `sudo docker ps | grep homarr`
- Verify firewall allows port 7575
- Restart container: `sudo docker restart homarr`

**Tiles not loading?**
- Verify service URLs are correct
- Check services are running: `sudo docker ps`
- Test URLs in your browser first

**Need help?** Open an issue: https://github.com/endergate/LabStart/issues