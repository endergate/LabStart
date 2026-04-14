#!/usr/bin/env bash
#LabStart - Homelab setup wizard
# github.com/endergate/labstart

COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

# --- Colors ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- Greeting ---
clear
printf "${CYAN}"
echo "  ______           _            _____       _          ____  _____   _____ "
echo " |  ____|         | |          / ____|     | |        / __ \|  __ \ / ____|"
echo " | |__   _ __   __| | ___ _ __| |  __  __ _| |_ ___  | |  | | |__) | (___  "
echo " |  __| | '_ \ / _' |/ _ \ '__| | |_ |/ _' | __/ _ \ | |  | |  ___/ \___ \ "
echo " | |____| | | | (_| |  __/ |  | |__| | (_| | ||  __/ | |__| | |     ____) |"
echo " |______|_| |_|\__,_|\___|_|   \_____|\__,_|\__\___|  \____/|_|    |_____/ "
echo ""
echo "========================================"
echo "  Let's build your homelab!"
echo "========================================"
echo ""
sleep 4

printf "${NC}\n"
printf "${CYAN}Welcome to LabStart - Your Homelab Setup Wizard!${NC}\n"
printf "This tool will generate a docker-compose.yml for your homelab.\n"
printf "Answer the questions below and we'll build it for you.\n"
echo ""

sleep 10



# -- Dashboard Selection --
printf "${CYAN}[ Select Your Favorite Dashboard ]${NC}\n"
echo "A dashboard gives you one place to see all your services."
echo ""
echo "  1) Dashy"
echo "  2) Homepage"
echo "  3) Homarr"
echo "  4) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-4]: ${NC}"
read DASHBOARD_CHOICE
case $DASHBOARD_CHOICE in
    1) DASHBOARD="dashy"  ; break;;
    2) DASHBOARD="homepage"  ; break;;
    3) DASHBOARD="homarr"  ; break;;
    4) DASHBOARD="skip"  ; break;;
    *) printf "${RED}Invalid option. Please choose 1-4.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# -- Basic Setup for Dashy --
echo ""
printf "${CYAN}[ Basic Setup ]${NC}\n"
echo ""
printf "${YELLOW}Dashboard title (e.g. My Homelab): ${NC}"
read DASHBOARD_TITLE
[ -z "$DASHBOARD_TITLE" ] && DASHBOARD_TITLE="My Homelab"


# Auto-detect IP
LOCAL_IP=$(hostname -I | awk '{print $1}')

printf "${YELLOW}Detected server IP: ${GREEN}$LOCAL_IP${NC}\n"
printf "${YELLOW}Is this correct? [y/n]: ${NC}"
read IP_CONFIRM

if [ "$IP_CONFIRM" = "n" ] || [ "$IP_CONFIRM" = "N" ]; then
    while true; do
        printf "${YELLOW}Enter your server IP: ${NC}"
        read LOCAL_IP
        if [[ $LOCAL_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            break
        else
            printf "${RED}Invalid IP address. Please use format: 0.0.0.0${NC}\n"
        fi
    done
fi

# Timezone

printf "${YELLOW}Your timezone (e.g. America/New_York): ${NC}"
read TIMEZONE
[ -z "$TIMEZONE" ] && TIMEZONE="America/New_York"

printf "${GREEN}✔ Got it!${NC} Setting up your lab...\n"
sleep 1

# -- DNS Blocker --
echo ""
printf "${CYAN}[ Select your Favorite DNS Blocker ]${NC}\n"
echo "Blocks ads and trackers at the network level."
echo ""
echo "  1) Pi-hole"
echo "  2) AdGuard Home"
echo "  3) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-3]: ${NC}"
read DNS_CHOICE
case $DNS_CHOICE in
    1) DNS="pihole"  ; break;;
    2) DNS="adguard"  ; break;;
    3) DNS="skip"  ; break ;;
    *) printf "${RED}Invalid option. Please choose 1-3.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# -- Monitoring --
echo ""
printf "${CYAN}[ Select your Monitoring Tool ]${NC}\n"
echo "Track your services and get alerted when something goes down."
echo ""
echo "  1) Uptime Kuma"
echo "  2) Netdata"
echo "  3) Skip"
echo ""

while true; do
    printf "${YELLOW}Choose an option [1-3]: ${NC}"
    read MONITORING_CHOICE
    case $MONITORING_CHOICE in
        1) MONITORING="uptime-kuma" ; break ;;
        2) MONITORING="netdata" ; break ;;
        3) MONITORING="skip" ; break ;;
        *) printf "${RED}Invalid option. Please choose 1-3.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# -- Media Server --
echo ""
printf "${CYAN}[ Select your Media Server ]${NC}\n"
echo " Host and Stream your movies and shows to any device within your network."
echo ""
echo "  1) Plex"
echo "  2) Jellyfin"
echo "  3) Emby"
echo "  4) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-4]: ${NC}"
read MEDIA_CHOICE
case $MEDIA_CHOICE in
    1) MEDIA="plex"  ; break;;
    2) MEDIA="jellyfin"  ; break;;
    3) MEDIA="emby"  ; break;;
    4) MEDIA="skip"  ; break;;
    *) printf "${RED}Invalid option. Please choose 1-4.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# --Container Manager --
echo ""
printf "${CYAN}[ Select your Container Manager ]${NC}\n"
echo "Easily manage your  Docker containers with a web interface."
echo ""
echo "  1) Portainer"
echo "  2) Yacht"
echo "  3) Komodo"
echo "  4) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-4]: ${NC}"
read CONTAINER_CHOICE
case $CONTAINER_CHOICE in
    1) CONTAINER="portainer"  ; break;;
    2) CONTAINER="yacht"  ; break;;
    3) CONTAINER="komodo"  ; break;;
    4) CONTAINER="skip"  ; break;;
    *) printf "${RED}Invalid option. Please choose 1-4.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# -- VPN --
echo ""
printf "${CYAN}[ Select your VPN ]${NC}\n"
echo "Access your homelab securely from anywhere."
echo ""
echo "  1) WireGuard"
echo "  2) Tailscale"
echo "  3) OpenVPN"
echo "  4) Headscale"
echo "  5) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-5]: ${NC}"
read VPN_CHOICE
case $VPN_CHOICE in
    1) VPN="wireguard"  ; break;;
    2) VPN="tailscale"  ; break;;
    3) VPN="openvpn"  ; break;;
    4) VPN="headscale"  ; break;;
    5) VPN="skip"  ; break;;
    *) printf "${RED}Invalid option. Please choose 1-5.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# -- DDNS --
echo ""
printf "${CYAN}[ Dynamic DNS (DDNS) ]${NC}\n"
echo "Keeps your domain pointing to your home IP even when it changes."
echo ""
echo "  1) Cloudflare DDNS"
echo "  2) DuckDNS"
echo "  3) No-IP"
echo "  4) Dynu"
echo "  5) Skip"
echo ""

while true; do
printf "${YELLOW}Choose an option [1-5]: ${NC}"
read DDNS_CHOICE
case $DDNS_CHOICE in
    1) DDNS="cloudflare-ddns"  ; break;;
    2) DDNS="duckdns"  ; break;;
    3) DDNS="noip"  ; break;;
    4) DDNS="dynu"  ; break;;
    5) DDNS="skip"  ; break;;
    *) printf "${RED}Invalid option. Please choose 1-5.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Got it!${NC} Saving your choice...\n"
sleep 2

# --- Generate docker-compose.yml ---
printf "\n${CYAN}Generating your homelab...${NC}\n"
sleep 2

# Write the header
cat > $COMPOSE_FILE << 'EOF'
services:
EOF

printf "${GREEN}✔ Created docker-compose.yml${NC}\n"
sleep 2

# Append a service to docker-compose.yml if not skipped
append_service() {
    local service=$1
    if [ "$service" != "skip" ]; then
        bash services/$service.sh >> $COMPOSE_FILE
        printf "${GREEN}✔ Added $service${NC}\n"
    fi
}

# Append chosen services
append_service "$DASHBOARD"
append_service "$DNS"
append_service "$MONITORING"
append_service "$MEDIA"
append_service "$CONTAINER"
append_service "$VPN"
append_service "$DDNS"

# --- Generate Dashy Config ---
if [ "$DASHBOARD" = "dashy" ]; then
    printf "\n${CYAN}Generating Dashy config...${NC}\n"

    DASHY_CONFIG="config/dashy/conf.yml"
    mkdir -p config/dashy

    cat > $DASHY_CONFIG << EOF
pageInfo:
  title: $DASHBOARD_TITLE
  description: Generated by LabStart
appConfig:
  theme: Minimal-Dark
  layout: horizontal
  iconSize: medium
  hideFooter: true
sections:
  - name: My Services
    items:
EOF

    [ "$DNS" = "pihole" ] && cat >> $DASHY_CONFIG << EOF
      - title: Pi-hole
        description: Network ad blocker
        icon: hl-pihole
        url: http://$LOCAL_IP:8080
        statusCheck: true
EOF

    [ "$DNS" = "adguard" ] && cat >> $DASHY_CONFIG << EOF
      - title: AdGuard Home
        description: Network ad blocker
        icon: hl-adguard-home
        url: http://$LOCAL_IP:3000
        statusCheck: true
EOF

    [ "$MONITORING" = "uptime-kuma" ] && cat >> $DASHY_CONFIG << EOF
      - title: Uptime Kuma
        description: Service monitoring
        icon: hl-uptime-kuma
        url: http://$LOCAL_IP:3001
        statusCheck: true
EOF

    [ "$MONITORING" = "netdata" ] && cat >> $DASHY_CONFIG << EOF
      - title: Netdata
        description: Real-time monitoring
        icon: hl-netdata
        url: http://$LOCAL_IP:19999
        statusCheck: true
EOF

    [ "$MEDIA" = "jellyfin" ] && cat >> $DASHY_CONFIG << EOF
      - title: Jellyfin
        description: Media server
        icon: hl-jellyfin
        url: http://$LOCAL_IP:8096
        statusCheck: true
EOF

    [ "$MEDIA" = "plex" ] && cat >> $DASHY_CONFIG << EOF
      - title: Plex
        description: Media server
        icon: hl-plex
        url: http://$LOCAL_IP:32400
        statusCheck: true
EOF

    [ "$MEDIA" = "emby" ] && cat >> $DASHY_CONFIG << EOF
      - title: Emby
        description: Media server
        icon: hl-emby
        url: http://$LOCAL_IP:8097
        statusCheck: true
EOF

    [ "$CONTAINER" = "portainer" ] && cat >> $DASHY_CONFIG << EOF
      - title: Portainer
        description: Container management
        icon: hl-portainer
        url: http://$LOCAL_IP:9000
        statusCheck: true
EOF

    [ "$CONTAINER" = "yacht" ] && cat >> $DASHY_CONFIG << EOF
      - title: Yacht
        description: Container management
        icon: hl-yacht
        url: http://$LOCAL_IP:8001
        statusCheck: true
EOF

    [ "$CONTAINER" = "komodo" ] && cat >> $DASHY_CONFIG << EOF
      - title: Komodo
        description: Container management
        icon: si-komodo
        url: http://$LOCAL_IP:9120
        statusCheck: true
EOF

    [ "$VPN" = "wireguard" ] && cat >> $DASHY_CONFIG << EOF
      - title: WireGuard
        description: VPN - Port 51820/udp
        icon: hl-wireguard
        url: http://$LOCAL_IP:51821
        statusCheck: false
EOF

    [ "$VPN" = "tailscale" ] && cat >> $DASHY_CONFIG << EOF
      - title: Tailscale
        description: Mesh VPN
        icon: hl-tailscale
        url: https://login.tailscale.com/admin
        statusCheck: false
EOF

    [ "$VPN" = "openvpn" ] && cat >> $DASHY_CONFIG << EOF
      - title: OpenVPN
        description: VPN - Port 1194/udp
        icon: hl-openvpn
        url: http://$LOCAL_IP:943
        statusCheck: false
EOF

    [ "$VPN" = "headscale" ] && cat >> $DASHY_CONFIG << EOF
      - title: Headscale
        description: Self-hosted VPN control server
        icon: hl-headscale
        url: http://$LOCAL_IP:8085
        statusCheck: true
EOF

    [ "$DDNS" = "cloudflare-ddns" ] && cat >> $DASHY_CONFIG << EOF
      - title: Cloudflare DDNS
        description: Dynamic DNS - Auto-updating
        icon: si-cloudflare
        url: https://dash.cloudflare.com
        statusCheck: false
EOF

    [ "$DDNS" = "duckdns" ] && cat >> $DASHY_CONFIG << EOF
      - title: DuckDNS
        description: Dynamic DNS - Auto-updating
        icon: si-duckduckgo
        url: https://www.duckdns.org
        statusCheck: false
EOF

    [ "$DDNS" = "noip" ] && cat >> $DASHY_CONFIG << EOF
      - title: No-IP
        description: Dynamic DNS - Auto-updating
        icon: fas fa-network-wired
        url: https://www.noip.com
        statusCheck: false
EOF

    [ "$DDNS" = "dynu" ] && cat >> $DASHY_CONFIG << EOF
      - title: Dynu
        description: Dynamic DNS - Auto-updating
        icon: fas fa-network-wired
        url: https://www.dynu.com
        statusCheck: false
EOF

    printf "${GREEN}✔ Dashy config generated at $DASHY_CONFIG${NC}\n"
fi

# --- Generate Homepage Config ---
if [ "$DASHBOARD" = "homepage" ]; then
    printf "\n${CYAN}Generating Homepage config...${NC}\n"

    HOMEPAGE_CONFIG="config/homepage/services.yaml"
    mkdir -p config/homepage

    cat > $HOMEPAGE_CONFIG << EOF
- My Services:
EOF

    [ "$DNS" = "pihole" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Pi-hole:
        icon: pi-hole.png
        href: http://$LOCAL_IP:8080
        description: Network ad blocker
EOF

    [ "$DNS" = "adguard" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - AdGuard Home:
        icon: adguard-home.png
        href: http://$LOCAL_IP:3000
        description: Network ad blocker
EOF

    [ "$MONITORING" = "uptime-kuma" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Uptime Kuma:
        icon: uptime-kuma.png
        href: http://$LOCAL_IP:3001
        description: Service monitoring
EOF

    [ "$MONITORING" = "netdata" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Netdata:
        icon: netdata.png
        href: http://$LOCAL_IP:19999
        description: Real-time monitoring
EOF

    [ "$MEDIA" = "jellyfin" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Jellyfin:
        icon: jellyfin.png
        href: http://$LOCAL_IP:8096
        description: Media server
EOF

    [ "$MEDIA" = "plex" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Plex:
        icon: plex.png
        href: http://$LOCAL_IP:32400
        description: Media server
EOF

    [ "$MEDIA" = "emby" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Emby:
        icon: emby.png
        href: http://$LOCAL_IP:8097
        description: Media server
EOF

    [ "$CONTAINER" = "portainer" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Portainer:
        icon: portainer.png
        href: http://$LOCAL_IP:9000
        description: Container management
EOF

    [ "$CONTAINER" = "yacht" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Yacht:
        icon: yacht.png
        href: http://$LOCAL_IP:8001
        description: Container management
EOF

    [ "$CONTAINER" = "komodo" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Komodo:
        icon: komodo.png
        href: http://$LOCAL_IP:9120
        description: Container management
EOF

    [ "$VPN" = "wireguard" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - WireGuard:
        icon: wireguard.png
        href: http://$LOCAL_IP:51821
        description: VPN
EOF

    [ "$VPN" = "tailscale" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Tailscale:
        icon: tailscale.png
        href: https://login.tailscale.com/admin
        description: Mesh VPN
EOF

    [ "$VPN" = "headscale" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Headscale:
        icon: headscale.png
        href: http://$LOCAL_IP:8085
        description: Self-hosted VPN
EOF

    [ "$DDNS" = "cloudflare-ddns" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Cloudflare DDNS:
        icon: cloudflare.png
        href: https://dash.cloudflare.com
        description: Dynamic DNS
EOF

    [ "$DDNS" = "duckdns" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - DuckDNS:
        icon: duckdns.png
        href: https://www.duckdns.org
        description: Dynamic DNS
EOF

    [ "$DDNS" = "noip" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - No-IP:
        icon: noip.png
        href: https://www.noip.com
        description: Dynamic DNS
EOF

    [ "$DDNS" = "dynu" ] && cat >> $HOMEPAGE_CONFIG << EOF
    - Dynu:
        icon: dynu.png
        href: https://www.dynu.com
        description: Dynamic DNS
EOF

    printf "${GREEN}✔ Homepage config generated at $HOMEPAGE_CONFIG${NC}\n"
fi

# --- Generate Homarr Config ---
if [ "$DASHBOARD" = "homarr" ]; then
    printf "\n${CYAN}Generating Homarr config...${NC}\n"

    HOMARR_CONFIG="config/homarr/default.json"
    mkdir -p config/homarr

    cat > $HOMARR_CONFIG << EOF
{
  "name": "My Homelab",
  "apps": [
EOF

    FIRST=true

    add_homarr_tile() {
        local name=$1
        local url=$2
        local icon=$3
        if [ "$FIRST" = true ]; then
            FIRST=false
        else
            echo "," >> $HOMARR_CONFIG
        fi
        cat >> $HOMARR_CONFIG << EOF
    {
      "name": "$name",
      "url": "$url",
      "icon": "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/$icon.png"
    }
EOF
    }

    [ "$DNS" = "pihole" ] && add_homarr_tile "Pi-hole" "http://$LOCAL_IP:8080" "pi-hole"
    [ "$DNS" = "adguard" ] && add_homarr_tile "AdGuard Home" "http://$LOCAL_IP:3000" "adguard-home"
    [ "$MONITORING" = "uptime-kuma" ] && add_homarr_tile "Uptime Kuma" "http://$LOCAL_IP:3001" "uptime-kuma"
    [ "$MONITORING" = "netdata" ] && add_homarr_tile "Netdata" "http://$LOCAL_IP:19999" "netdata"
    [ "$MEDIA" = "jellyfin" ] && add_homarr_tile "Jellyfin" "http://$LOCAL_IP:8096" "jellyfin"
    [ "$MEDIA" = "plex" ] && add_homarr_tile "Plex" "http://$LOCAL_IP:32400" "plex"
    [ "$MEDIA" = "emby" ] && add_homarr_tile "Emby" "http://$LOCAL_IP:8097" "emby"
    [ "$CONTAINER" = "portainer" ] && add_homarr_tile "Portainer" "http://$LOCAL_IP:9000" "portainer"
    [ "$CONTAINER" = "yacht" ] && add_homarr_tile "Yacht" "http://$LOCAL_IP:8001" "yacht"
    [ "$CONTAINER" = "komodo" ] && add_homarr_tile "Komodo" "http://$LOCAL_IP:9120" "komodo"
    [ "$VPN" = "wireguard" ] && add_homarr_tile "WireGuard" "http://$LOCAL_IP:51821" "wireguard"
    [ "$VPN" = "tailscale" ] && add_homarr_tile "Tailscale" "https://login.tailscale.com/admin" "tailscale"
    [ "$VPN" = "headscale" ] && add_homarr_tile "Headscale" "http://$LOCAL_IP:8085" "headscale"
    [ "$DDNS" = "cloudflare-ddns" ] && add_homarr_tile "Cloudflare DDNS" "https://dash.cloudflare.com" "cloudflare"
    [ "$DDNS" = "duckdns" ] && add_homarr_tile "DuckDNS" "https://www.duckdns.org" "duckdns"
    [ "$DDNS" = "noip" ] && add_homarr_tile "No-IP" "https://www.noip.com" "noip"
    [ "$DDNS" = "dynu" ] && add_homarr_tile "Dynu" "https://www.dynu.com" "dynu"

    cat >> $HOMARR_CONFIG << EOF
  ]
}
EOF

    printf "${GREEN}✔ Homarr config generated at $HOMARR_CONFIG${NC}\n"
fi

# --- Generate .env file ---
printf "\n${CYAN}Generating .env file...${NC}\n"
sleep 1

cat > $ENV_FILE << 'EOF'
# LabStart Environment Variables
# Fill in the values below before running docker compose up -d

# Pi-hole
PIHOLE_PASSWORD=changeme

# Plex
PLEX_CLAIM=yourclaim

# WireGuard
WG_SERVER_URL=yourdomain.com

# Tailscale
TAILSCALE_AUTHKEY=yourkey

# Cloudflare DDNS
CF_API_TOKEN=yourtoken
CF_DOMAIN=yourdomain.com

# DuckDNS
DUCKDNS_SUBDOMAIN=yoursubdomain
DUCKDNS_TOKEN=yourtoken

# No-IP
NOIP_USERNAME=yourusername
NOIP_PASSWORD=yourpassword
NOIP_DOMAIN=yourdomain.com

# Dynu
DYNU_USERNAME=yourusername
DYNU_PASSWORD=yourpassword
DYNU_DOMAIN=yourdomain.com
EOF

printf "${GREEN}✔ Created .env file${NC}\n"
sleep 2

# --- Summary ---
echo ""
printf "${CYAN}╔══════════════════════════════════════════╗${NC}\n"
printf "${CYAN}║                                          ║${NC}\n"
printf "${GREEN}║       YOUR HOMELAB SETUP IS READY!       ${CYAN}║${NC}\n"
printf "${CYAN}║                                          ║${NC}\n"
printf "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
echo ""
printf "${CYAN}Generated Files:${NC}\n"
printf "   + docker-compose.yml\n"
printf "   + .env\n"
[ "$DASHBOARD" = "dashy" ] && printf "   + config/dashy/conf.yml\n"
[ "$DASHBOARD" = "homepage" ] && printf "   + config/homepage/\n"
[ "$DASHBOARD" = "homarr" ] && printf "   + config/homarr/\n"
echo ""
printf "${CYAN}Next Steps:${NC}\n"
echo ""
printf "   ${YELLOW}Step 1${NC} - Fill in your credentials\n"
printf "           nano .env\n"
printf "           Replace all placeholder values with your real ones\n"
printf "           Save: Ctrl+X then Y then Enter\n"
echo ""
printf "   ${YELLOW}Step 2${NC} - Start your homelab\n"
printf "           docker compose up -d\n"
echo ""
printf "   ${YELLOW}Step 3${NC} - Open your browser\n"
printf "           http://YOUR-SERVER-IP:4000  ->  Dashy\n"
printf "           http://YOUR-SERVER-IP:3001  ->  Uptime Kuma\n"
printf "           http://YOUR-SERVER-IP:9000  ->  Portainer\n"
echo ""
printf "${CYAN}╔══════════════════════════════════════════╗${NC}\n"
printf "${CYAN}║Need help? github.com/endergate/labstart  ║${NC}\n"
printf "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
echo ""