# OpenVPN Setup Guide

OpenVPN is a VPN that lets you securely access your homelab from anywhere. LabStart installs the OpenVPN server, but you need to complete setup via CLI.

## What LabStart Does For You
- Installs OpenVPN server container
- Mounts config directory at `~/LabStart/config/openvpn`

## What You Need To Do

### 1. Initialize OpenVPN Server
Generate server configuration and certificates:

```bash
sudo docker exec -it openvpn ovpn_genconfig -u udp://YOUR_SERVER_IP_OR_DOMAIN
sudo docker exec -it openvpn ovpn_initpki
```

You'll be prompted to:
- Set a CA key passphrase
- Confirm the passphrase
- Set a Common Name (use your domain or IP)

### 2. Port Forward on Your Router
Forward **port 1194/UDP** to your server's IP address.

Example (UniFi):
- Go to Settings → Routing → Port Forwarding
- Create New Rule:
  - Name: OpenVPN
  - Protocol: UDP
  - Port: 1194
  - Forward IP: [your server IP]
  - Forward Port: 1194

### 3. Generate Client Config
Create a client certificate and config file:

```bash
sudo docker exec -it openvpn easyrsa build-client-full CLIENTNAME nopass
sudo docker exec openvpn ovpn_getclient CLIENTNAME > ~/client.ovpn
```

Replace `CLIENTNAME` with a device identifier (e.g., `laptop`, `phone`).

### 4. Connect Your Devices

**Desktop (Windows/Mac/Linux):**
1. Install OpenVPN from https://openvpn.net/community-downloads/
2. Import the `client.ovpn` file
3. Connect

**Mobile (iOS/Android):**
1. Install OpenVPN Connect app
2. Import the `client.ovpn` file
3. Connect

### 5. Add More Clients
Repeat step 3 with different client names:

```bash
sudo docker exec -it openvpn easyrsa build-client-full laptop nopass
sudo docker exec openvpn ovpn_getclient laptop > ~/laptop.ovpn
```

## Troubleshooting

**Can't connect?**
- Check port forwarding is active (UDP 1194)
- Verify your server IP/domain is correct in client config
- Check firewall allows UDP 1194
- Restart OpenVPN container: `sudo docker restart openvpn`

**Certificate errors?**
- Make sure you ran `ovpn_initpki` first
- Check CA passphrase is correct

**Need to revoke a client?**
```bash
sudo docker exec -it openvpn easyrsa revoke CLIENTNAME
sudo docker exec -it openvpn easyrsa gen-crl
sudo docker restart openvpn
```

**Need help?** Open an issue: https://github.com/endergate/LabStart/issues