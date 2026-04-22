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

sleep 5



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

while true; do
    printf "${YELLOW}Is this correct? [y/n]: ${NC}"
    read IP_CONFIRM
    case $IP_CONFIRM in
        y|Y) break ;;
        n|N)
            while true; do
                printf "${YELLOW}Enter your server IP: ${NC}"
                read LOCAL_IP
                if [[ $LOCAL_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                    break
                else
                    printf "${RED}Invalid IP. Please use format: 0.0.0.0${NC}\n"
                fi
            done
            break ;;
        *) printf "${RED}Please enter y or n.${NC}\n" ;;
    esac
done

# Timezone

# Timezone
echo ""
printf "${CYAN}[ Timezone Setup ]${NC}\n"
echo ""
echo "  1) America/New_York     (Eastern)"
echo "  2) America/Chicago      (Central)"
echo "  3) America/Denver       (Mountain)"
echo "  4) America/Los_Angeles  (Pacific)"
echo "  5) Europe/London        (GMT)"
echo "  6) Europe/Paris         (CET)"
echo "  7) Asia/Tokyo           (JST)"
echo "  8) Australia/Sydney     (AEST)"
echo "  9) Enter manually"
echo ""

while true; do
    printf "${YELLOW}Choose an option [1-9]: ${NC}"
    read TZ_CHOICE
    case $TZ_CHOICE in
        1) TIMEZONE="America/New_York" ; break ;;
        2) TIMEZONE="America/Chicago" ; break ;;
        3) TIMEZONE="America/Denver" ; break ;;
        4) TIMEZONE="America/Los_Angeles" ; break ;;
        5) TIMEZONE="Europe/London" ; break ;;
        6) TIMEZONE="Europe/Paris" ; break ;;
        7) TIMEZONE="Asia/Tokyo" ; break ;;
        8) TIMEZONE="Australia/Sydney" ; break ;;
        9)
            printf "${YELLOW}Enter your timezone (e.g. America/New_York): ${NC}"
            read TIMEZONE
            break ;;
        *) printf "${RED}Invalid option. Please choose 1-9.${NC}\n" ;;
    esac
done

printf "${GREEN}✔ Timezone set to $TIMEZONE${NC}\n"

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

# Pi-hole password setup
if [ "$DNS" = "pihole" ]; then
    echo ""
    printf "${CYAN}[ Pi-hole Setup ]${NC}\n"
    echo ""
    
    # Check if systemd-resolved is running
    if systemctl is-active --quiet systemd-resolved; then
        printf "${YELLOW}⚠ Pi-hole requires port 53, but systemd-resolved is using it.${NC}\n"
        printf "${YELLOW}Would you like LabStart to disable systemd-resolved? [y/n]: ${NC}"
        read DISABLE_RESOLVED
        
        if [ "$DISABLE_RESOLVED" = "y" ] || [ "$DISABLE_RESOLVED" = "Y" ]; then
            sudo systemctl disable systemd-resolved
            sudo systemctl stop systemd-resolved
            sudo rm /etc/resolv.conf
            echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
            printf "${GREEN}✔ systemd-resolved disabled, DNS set to 1.1.1.1${NC}\n"
        else
            printf "${RED}⚠ Pi-hole may fail to start. You'll need to fix port 53 manually.${NC}\n"
        fi
    fi
    
    while true; do
        printf "${YELLOW}Set a password for Pi-hole: ${NC}"
        read -s PIHOLE_PASSWORD
        echo ""
        printf "${YELLOW}Confirm password: ${NC}"
        read -s PIHOLE_PASSWORD_CONFIRM
        echo ""
        if [ "$PIHOLE_PASSWORD" = "$PIHOLE_PASSWORD_CONFIRM" ]; then
            break
        else
            printf "${RED}Passwords do not match. Try again.${NC}\n"
        fi
    done
    printf "${GREEN}✔ Pi-hole password set!${NC}\n"
fi

# AdGuard reminder
if [ "$DNS" = "adguard" ]; then
    echo ""
    printf "${CYAN}[ AdGuard Home Setup ]${NC}\n"
    echo ""
    printf "  AdGuard will ask you to create a password on first login.\n"
    printf "  Visit: http://$LOCAL_IP:3000\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

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

# Plex claim token
if [ "$MEDIA" = "plex" ]; then
    echo ""
    printf "${CYAN}[ Plex Setup ]${NC}\n"
    echo ""
    printf "  Get your claim token from: ${YELLOW}https://plex.tv/claim${NC}\n"
    printf "  It expires in 4 minutes so get it right before entering.\n"
    echo ""
    printf "${YELLOW}Enter your Plex claim token: ${NC}"
    read PLEX_CLAIM
    printf "${GREEN}✔ Plex token saved!${NC}\n"
fi

# Jellyfin reminder
if [ "$MEDIA" = "jellyfin" ]; then
    echo ""
    printf "${CYAN}[ Jellyfin Setup ]${NC}\n"
    echo ""
    printf "  Jellyfin will ask you to create an admin account on first login.\n"
    printf "  Visit: http://$LOCAL_IP:8096\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

# Emby reminder
if [ "$MEDIA" = "emby" ]; then
    echo ""
    printf "${CYAN}[ Emby Setup ]${NC}\n"
    echo ""
    printf "  Emby will ask you to create an admin account on first login.\n"
    printf "  Visit: http://$LOCAL_IP:8097\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

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

# Portainer reminder
if [ "$CONTAINER" = "portainer" ]; then
    echo ""
    printf "${CYAN}[ Portainer Setup ]${NC}\n"
    echo ""
    printf "  Portainer will ask you to create an admin account on first login.\n"
    printf "  Visit: http://$LOCAL_IP:9000\n"
    printf "  ${RED}Note: You have 5 minutes to set up before it locks you out.${NC}\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

# Yacht reminder
if [ "$CONTAINER" = "yacht" ]; then
    echo ""
    printf "${CYAN}[ Yacht Setup ]${NC}\n"
    echo ""
    printf "  Default credentials: admin@yacht.local / pass\n"
    printf "  Visit: http://$LOCAL_IP:8001\n"
    printf "  ${RED}Note: Change your password after first login!${NC}\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

# Komodo reminder
if [ "$CONTAINER" = "komodo" ]; then
    echo ""
    printf "${CYAN}[ Komodo Setup ]${NC}\n"
    echo ""
    printf "  Komodo will ask you to create an account on first login.\n"
    printf "  Visit: http://$LOCAL_IP:9120\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

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

# WireGuard setup
if [ "$VPN" = "wireguard" ]; then
    echo ""
    printf "${CYAN}[ WireGuard Setup ]${NC}\n"
    echo ""
    printf "${YELLOW}Enter your server domain or IP (e.g. vpn.yourdomain.com): ${NC}"
    read WG_SERVER_URL
    printf "${GREEN}✔ WireGuard server URL saved!${NC}\n"
fi

# Tailscale setup
if [ "$VPN" = "tailscale" ]; then
    echo ""
    printf "${CYAN}[ Tailscale Setup ]${NC}\n"
    echo ""
    printf "  Get your auth key from: ${YELLOW}https://login.tailscale.com/admin/settings/keys${NC}\n"
    echo ""
    printf "${YELLOW}Enter your Tailscale auth key: ${NC}"
    read TAILSCALE_AUTHKEY
    printf "${GREEN}✔ Tailscale auth key saved!${NC}\n"
fi

# OpenVPN reminder
if [ "$VPN" = "openvpn" ]; then
    echo ""
    printf "${CYAN}[ OpenVPN Setup ]${NC}\n"
    echo ""
    printf "  OpenVPN requires additional configuration after setup.\n"
    printf "  Visit: http://$LOCAL_IP:943\n"
    printf "  Check the README for full OpenVPN setup instructions.\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

# Headscale reminder
if [ "$VPN" = "headscale" ]; then
    echo ""
    printf "${CYAN}[ Headscale Setup ]${NC}\n"
    echo ""
    printf "  Headscale requires CLI setup after install.\n"
    printf "  Visit: http://$LOCAL_IP:8085\n"
    printf "  Check the README for full Headscale setup instructions.\n"
    echo ""
    printf "${YELLOW}Press Enter to continue...${NC}"
    read
fi

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

# Cloudflare DDNS setup
if [ "$DDNS" = "cloudflare-ddns" ]; then
    echo ""
    printf "${CYAN}[ Cloudflare DDNS Setup ]${NC}\n"
    echo ""
    printf "  Get your API token from: ${YELLOW}https://dash.cloudflare.com/profile/api-tokens${NC}\n"
    echo ""
    printf "${YELLOW}Enter your Cloudflare API token: ${NC}"
    read CF_API_TOKEN
    printf "${YELLOW}Enter your domain (e.g. vpn.yourdomain.com): ${NC}"
    read CF_DOMAIN
    printf "${GREEN}✔ Cloudflare DDNS configured!${NC}\n"
fi

# DuckDNS setup
if [ "$DDNS" = "duckdns" ]; then
    echo ""
    printf "${CYAN}[ DuckDNS Setup ]${NC}\n"
    echo ""
    printf "  Get your token from: ${YELLOW}https://www.duckdns.org${NC}\n"
    echo ""
    printf "${YELLOW}Enter your DuckDNS subdomain (e.g. myhomelab): ${NC}"
    read DUCKDNS_SUBDOMAIN
    printf "${YELLOW}Enter your DuckDNS token: ${NC}"
    read DUCKDNS_TOKEN
    printf "${GREEN}✔ DuckDNS configured!${NC}\n"
fi

# No-IP setup
if [ "$DDNS" = "noip" ]; then
    echo ""
    printf "${CYAN}[ No-IP Setup ]${NC}\n"
    echo ""
    printf "${YELLOW}Enter your No-IP username: ${NC}"
    read NOIP_USERNAME
    printf "${YELLOW}Enter your No-IP password: ${NC}"
    read -s NOIP_PASSWORD
    echo ""
    printf "${YELLOW}Enter your No-IP domain (e.g. myhomelab.ddns.net): ${NC}"
    read NOIP_DOMAIN
    printf "${GREEN}✔ No-IP configured!${NC}\n"
fi

# Dynu setup
if [ "$DDNS" = "dynu" ]; then
    echo ""
    printf "${CYAN}[ Dynu Setup ]${NC}\n"
    echo ""
    printf "${YELLOW}Enter your Dynu username: ${NC}"
    read DYNU_USERNAME
    printf "${YELLOW}Enter your Dynu password: ${NC}"
    read -s DYNU_PASSWORD
    echo ""
    printf "${YELLOW}Enter your Dynu domain (e.g. myhomelab.dynu.net): ${NC}"
    read DYNU_DOMAIN
    printf "${GREEN}✔ Dynu configured!${NC}\n"
fi

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

cat > $ENV_FILE << EOF
# LabStart Environment Variables
# Generated by LabStart - do not share this file

# Pi-hole
PIHOLE_PASSWORD=$PIHOLE_PASSWORD

# Plex
PLEX_CLAIM=$PLEX_CLAIM

# WireGuard
WG_SERVER_URL=$WG_SERVER_URL

# Tailscale
TAILSCALE_AUTHKEY=$TAILSCALE_AUTHKEY

# Cloudflare DDNS
CF_API_TOKEN=$CF_API_TOKEN
CF_DOMAIN=$CF_DOMAIN

# DuckDNS
DUCKDNS_SUBDOMAIN=$DUCKDNS_SUBDOMAIN
DUCKDNS_TOKEN=$DUCKDNS_TOKEN

# No-IP
NOIP_USERNAME=$NOIP_USERNAME
NOIP_PASSWORD=$NOIP_PASSWORD
NOIP_DOMAIN=$NOIP_DOMAIN

# Dynu
DYNU_USERNAME=$DYNU_USERNAME
DYNU_PASSWORD=$DYNU_PASSWORD
DYNU_DOMAIN=$DYNU_DOMAIN
EOF

printf "${GREEN}✔ Created .env file${NC}\n"
sleep 2

# --- Auto-Install Docker and Start Services ---
echo ""
printf "${CYAN}[ Docker Setup ]${NC}\n"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    printf "${YELLOW}Docker is not installed.${NC}\n"
    printf "${YELLOW}Would you like LabStart to install Docker now? [y/n]: ${NC}"
    read INSTALL_DOCKER
    
    if [ "$INSTALL_DOCKER" = "y" ] || [ "$INSTALL_DOCKER" = "Y" ]; then
        printf "${CYAN}Installing Docker...${NC}\n"
        sudo apt update
        sudo apt install -y docker.io docker-compose
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker $USER
        printf "${GREEN}✔ Docker installed successfully!${NC}\n"
        DOCKER_INSTALLED=true
    else
        printf "${RED}⚠ Skipping Docker installation. You'll need to install it manually.${NC}\n"
        DOCKER_INSTALLED=false
    fi
else
    printf "${GREEN}✔ Docker is already installed${NC}\n"
    DOCKER_INSTALLED=true
fi

# Start containers if Docker is installed
if [ "$DOCKER_INSTALLED" = true ]; then
    echo ""
    printf "${YELLOW}Would you like to start your homelab now? [y/n]: ${NC}"
    read START_NOW
    
    if [ "$START_NOW" = "y" ] || [ "$START_NOW" = "Y" ]; then
        printf "${CYAN}Starting containers...${NC}\n"
        sudo docker-compose up -d
        echo ""
        sleep 3
        printf "${CYAN}Checking container status...${NC}\n"
        sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        printf "${GREEN}✔ Your homelab is now running!${NC}\n"
        echo ""
        printf "${CYAN}Access your services:${NC}\n"
        [ "$DASHBOARD" = "dashy" ] && printf "   Dashboard:  http://$LOCAL_IP:4000\n"
        [ "$DASHBOARD" = "homepage" ] && printf "   Dashboard:  http://$LOCAL_IP:3000\n"
        [ "$DASHBOARD" = "homarr" ] && printf "   Dashboard:  http://$LOCAL_IP:7575\n"
    fi
fi

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
printf "   ${YELLOW}Step 1${NC} - Start your homelab\n"
printf "           docker compose up -d\n"
echo ""
printf "   ${YELLOW}Step 2${NC} - Open your browser\n"
printf "           http://$LOCAL_IP:4000  ->  Dashy\n"
printf "           http://$LOCAL_IP:3001  ->  Uptime Kuma\n"
printf "           http://$LOCAL_IP:9000  ->  Portainer\n"
echo ""
printf "${CYAN}╔══════════════════════════════════════════╗${NC}\n"
printf "${CYAN}║ Need help? github.com/endergate/labstart ║${NC}\n"
printf "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
echo ""