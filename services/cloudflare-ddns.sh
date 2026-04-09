#!/usr/bin/env bash
# LabStart Service — Cloudflare DDNS
# Keeps your domain pointing to your home IP

cat << 'COMPOSE'
  cloudflare-ddns:
    image: favonia/cloudflare-ddns:latest
    container_name: cloudflare-ddns
    environment:
      - CF_API_TOKEN=${CF_API_TOKEN}
      - DOMAINS=${CF_DOMAIN}
      - PROXIED=false
    restart: unless-stopped
COMPOSE