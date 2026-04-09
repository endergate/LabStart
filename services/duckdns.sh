#!/usr/bin/env bash
# LabStart Service — DuckDNS
# Free dynamic DNS service

cat << 'COMPOSE'
  duckdns:
    image: linuxserver/duckdns:latest
    container_name: duckdns
    environment:
      - SUBDOMAINS=${DUCKDNS_SUBDOMAIN}
      - TOKEN=${DUCKDNS_TOKEN}
    restart: unless-stopped
COMPOSE