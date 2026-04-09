#!/usr/bin/env bash
# LabStart Service — Tailscale
# Zero-config mesh VPN

cat << 'COMPOSE'
  tailscale:
    image: tailscale/tailscale:latest
    container_name: tailscale
    environment:
      - TS_AUTHKEY=${TAILSCALE_AUTHKEY}
      - TS_STATE_DIR=/var/lib/tailscale
    volumes:
      - ./config/tailscale:/var/lib/tailscale
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
COMPOSE