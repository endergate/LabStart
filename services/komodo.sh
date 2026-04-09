#!/usr/bin/env bash
# LabStart Service — Komodo
# Advanced container management and deployment

cat << 'COMPOSE'
  komodo:
    image: ghcr.io/moghtech/komodo:latest
    container_name: komodo
    ports:
      - "9120:9120"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config/komodo:/etc/komodo
    restart: unless-stopped
COMPOSE