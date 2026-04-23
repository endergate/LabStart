# LabStart

An interactive CLI wizard that generates a ready-to-run homelab Docker setup for beginners.

## What is LabStart?

LabStart asks you a few simple questions about what you want in your homelab, then generates a ready-to-run `docker-compose.yml` and `.env` file for you. No YAML knowledge required.

## Quick Start

```bash
git clone https://github.com/endergate/LabStart.git
cd LabStart
chmod +x labstart.sh
./labstart.sh
```

## What it includes

- Dashboards — Dashy, Homepage, Homarr
- DNS Blockers — Pi-hole, AdGuard Home
- Monitoring — Uptime Kuma, Netdata
- Media Servers — Jellyfin, Plex, Emby
- Container Management — Portainer, Yacht, Komodo
- VPN — WireGuard, Tailscale, OpenVPN, Headscale
- DDNS — Cloudflare, DuckDNS, No-IP, Dynu

## 📚 Service Guides

Some services require additional setup after installation:

- **[WireGuard VPN Setup](docs/WIREGUARD.md)** - Complete guide for connecting devices to your VPN

## Requirements

- Linux (Ubuntu, Debian, Fedora, Arch)
- Docker + Docker Compose
- Bash

## Contributing

Want to add a new service? Check out [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT