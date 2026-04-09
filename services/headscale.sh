#!/usr/bin/env bash
# LabStart Service — Headscale
# Self-hosted Tailscale control server

cat << 'COMPOSE'
  headscale:
    image: headscale/headscale:latest
    container_name: headscale
    ports:
      - "8085:8080"
    volumes:
      - ./config/headscale:/etc/headscale
    restart: unless-stopped
COMPOSE