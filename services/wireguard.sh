#!/usr/bin/env bash
# LabStart Service — WireGuard
# Fast and modern VPN

cat << 'COMPOSE'
  wireguard:
    image: linuxserver/wireguard:latest
    container_name: wireguard
    ports:
      - "51820:51820/udp"
    environment:
      - PUID=1000
      - PGID=1000
      - SERVERURL=${WG_SERVER_URL}
      - PEERS=1
    volumes:
      - ./config/wireguard:/config
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
COMPOSE