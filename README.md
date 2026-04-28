# LabStart

**An interactive CLI wizard that generates a ready-to-run homelab in 5 minutes.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/endergate/LabStart)](https://github.com/endergate/LabStart/stargazers)

No Docker knowledge required. No YAML editing. Just answer a few questions and LabStart builds everything for you.

---

## ✨ Features

- ✅ **Zero Docker knowledge required** - Just answer questions
- ✅ **3 modern dashboards** - Dashy, Homepage, or Homarr with glass themes
- ✅ **Auto-configures everything** - No YAML editing needed
- ✅ **Smart setup wizards** - WireGuard QR codes, Pi-hole port conflict auto-fix
- ✅ **Organized sections** - Services grouped by category (Security, Media, Monitoring, etc.)
- ✅ **Beginner-friendly** - Clear instructions at every step
- ✅ **Docker auto-installer** - Installs Docker if you don't have it
- ✅ **Extensible** - Easy to add new services
- ✅ **Open source** - MIT license, community-driven

---

## 🚀 What is LabStart?

LabStart is a **wizard, not the software itself**. It automates the installation and configuration of popular open-source homelab applications by:

1. Asking what services you want
2. Auto-generating Docker Compose files
3. Configuring dashboards with your selected services
4. Starting everything for you

**LabStart does NOT create or maintain the services** - it simply makes them easier to install and configure. All credit goes to the original developers of each application.

---

## ⚡ Quick Start

```bash
git clone https://github.com/endergate/LabStart.git
cd LabStart
chmod +x labstart.sh
./labstart.sh
```

The wizard will guide you through the rest. Takes about 5 minutes.

---

## 🆚 Why LabStart?

| Manual Setup | LabStart |
|--------------|----------|
| Learn Docker, YAML syntax | Answer simple questions |
| Write docker-compose files | Auto-generated |
| Configure dashboards manually | Pre-configured with organized sections |
| Debug port conflicts | Auto-detects and fixes (Pi-hole) |
| Research each service's setup | Step-by-step wizard with explanations |
| 2-3 hours setup time | 5 minutes |

---

## 📦 Available Services

LabStart helps you install and configure these open-source applications:

### 🎨 Dashboards
- **[Dashy](https://github.com/Lissy93/dashy)** by [@Lissy93](https://github.com/Lissy93) - Feature-rich dashboard with material glass theme
- **[Homepage](https://github.com/gethomepage/homepage)** - Modern, fast dashboard with widget support
- **[Homarr](https://github.com/ajnart/homarr)** by [@ajnart](https://github.com/ajnart) - Sleek dashboard with drag-and-drop customization

### 🛡️ Ad Blocking
- **[Pi-hole](https://pi-hole.net/)** - Network-wide ad blocking via DNS
- **[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome)** - DNS-based ad blocker with DoH/DoT support

### 📈 Monitoring
- **[Uptime Kuma](https://github.com/louislam/uptime-kuma)** by [@louislam](https://github.com/louislam) - Service uptime monitoring with alerts
- **[Netdata](https://github.com/netdata/netdata)** - Real-time system performance monitoring

### 🎬 Media Servers
- **[Plex](https://www.plex.tv/)** - Popular media server with apps on every platform
- **[Jellyfin](https://jellyfin.org/)** - Free and open-source media system
- **[Emby](https://emby.media/)** - Media server with premium features

### 🐳 Container Management
- **[Portainer](https://www.portainer.io/)** - Feature-rich Docker management UI
- **[Yacht](https://github.com/SelfhostedPro/Yacht)** - Lightweight container management

### 🔒 VPN
- **[WireGuard](https://www.wireguard.com/)** - Modern, fast, secure VPN protocol
- **[Tailscale](https://tailscale.com/)** - Zero-config mesh VPN (easiest option)
- **[OpenVPN](https://openvpn.net/)** - Traditional VPN, widely supported
- **[Headscale](https://github.com/juanfont/headscale)** by [@juanfont](https://github.com/juanfont) - Self-hosted Tailscale control server

### 🌐 Dynamic DNS
- **[Cloudflare DDNS](https://www.cloudflare.com/)** - Keep your Cloudflare domain updated
- **[DuckDNS](https://www.duckdns.org/)** - Free subdomain DDNS service
- **[No-IP](https://www.noip.com/)** - Dynamic DNS provider

> **Note**: LabStart is a configuration tool. All services listed above are developed and maintained by their respective creators. LabStart simply automates their installation and setup.

---

## 📚 Documentation

### Setup Guides
Some services require additional configuration after installation:

- **[WireGuard Setup](docs/WIREGUARD.md)** - Generate configs and connect devices
- **[OpenVPN Setup](docs/OPENVPN.md)** - Create client certificates and configs
- **[Headscale Setup](docs/HEADSCALE.md)** - Configure self-hosted mesh VPN
- **[Homarr Setup](docs/HOMARR.md)** - Add service tiles to your dashboard

### Troubleshooting

**Containers won't start?**
```bash
# Check which containers are running
docker ps

# View logs for a specific container
docker logs <container-name>

# Restart a container
docker restart <container-name>
```

**Pi-hole fails with port 53 conflict?**
LabStart auto-detects and fixes this on Ubuntu, but if it fails manually:
```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
docker restart pihole
```

**Dashboard shows "Host validation failed"?**
This is fixed in the latest version. Pull the latest changes:
```bash
cd ~/LabStart
git pull
```

**Need more help?**
- [GitHub Issues](https://github.com/endergate/LabStart/issues)
- [GitHub Discussions](https://github.com/endergate/LabStart/discussions)

---

## 🖥️ System Requirements

**Supported Operating Systems:**
- Ubuntu 20.04+ (tested on 24.04)
- Debian 11+
- Linux Mint
- Pop!_OS
- Other Debian-based distributions with `apt` and `systemd`

> **Note:** LabStart currently supports Debian-based systems only. Support for RedHat/Fedora, Arch Linux, and other distributions is planned for future releases.

**Hardware:**
- **RAM**: 2GB minimum (4GB+ recommended)
- **Disk**: 20GB+ free space (more for media servers)
- **Network**: Static IP recommended for reliable access

LabStart will install Docker and Docker Compose for you if they're not already installed.

---

## 🤝 Contributing

Want to add a new service to LabStart? Contributions are welcome!

1. Fork the repository
2. Create a service file in `services/` following the existing pattern
3. Update the wizard menu in `labstart.sh`
4. Test thoroughly
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

LabStart is a configuration tool. All services it installs are subject to their own licenses:
- Dashy: MIT License
- Homepage: GPL-3.0 License
- Homarr: MIT License
- Pi-hole: EUPL-1.2 License
- (Individual service licenses apply)

---

## 🙏 Credits

LabStart is simply a wizard that makes installation easier. **All credit for the actual applications goes to their creators:**

- [Dashy](https://github.com/Lissy93/dashy) by Alicia Sykes
- [Homepage](https://github.com/gethomepage/homepage) by the Homepage team
- [Homarr](https://github.com/ajnart/homarr) by ajnart
- [Pi-hole](https://pi-hole.net/) by the Pi-hole team
- [Uptime Kuma](https://github.com/louislam/uptime-kuma) by Louis Lam
- And all other service developers listed above

LabStart is built **for** the homelab community, **by** the homelab community.

---

## 💬 Community & Support

- **Issues**: [Report bugs or request features](https://github.com/endergate/LabStart/issues)
- **Discussions**: [Ask questions or share setups](https://github.com/endergate/LabStart/discussions)
- **Reddit**: Share on [r/selfhosted](https://reddit.com/r/selfhosted) and [r/homelab](https://reddit.com/r/homelab)

---

## ☕ Support the Project

If LabStart saved you time, consider:
- ⭐ **Starring the repo** on GitHub
- 🐛 **Reporting bugs** or suggesting features
- 🤝 **Contributing** new services or improvements
- 💬 **Sharing** with the homelab community

---

**Built with ❤️ for the homelab community**

*Disclaimer: LabStart is an independent project and is not affiliated with, endorsed by, or sponsored by any of the applications it helps install.*