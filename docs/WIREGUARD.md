# WireGuard Setup Guide

WireGuard is a VPN that lets you securely access your homelab from anywhere. LabStart installs the WireGuard server, but you need to complete a few steps to connect your devices.

## What LabStart Does For You
- Installs WireGuard server container
- Generates server keys automatically
- Creates your first client config
- Shows QR code for mobile setup

## What You Need To Do

### 1. Port Forward on Your Router
Forward **port 51820/UDP** to your server's IP address.

Example (UniFi):
- Go to Settings → Routing → Port Forwarding
- Create New Rule:
  - Name: WireGuard
  - Protocol: UDP
  - Port: 51820
  - Forward IP: [your server IP]
  - Forward Port: 51820

### 2. Get Your Client Config
After LabStart finishes, your first client config is at: 
~/LabStart/config/wireguard/peer1/peer1.conf

View the QR code:
```bash
sudo docker exec wireguard /app/show-peer peer1
```

### 3. Connect Your Devices

**Mobile (iOS/Android):**
1. Install WireGuard app
2. Scan the QR code

**Desktop (Windows/Mac/Linux):**
1. Install WireGuard from wireguard.com
2. Import the `peer1.conf` file

### 4. Add More Devices
Generate additional client configs:
```bash
sudo docker exec wireguard wg-quick add peer2
sudo docker exec wireguard /app/show-peer peer2
```

## Troubleshooting

**Can't connect?**
- Check port forwarding is active
- Verify your domain/IP is correct in client config
- Check firewall allows UDP 51820

**Need help?** Open an issue: https://github.com/endergate/LabStart/issues