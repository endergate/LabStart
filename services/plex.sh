#!/usr/bin/env bash
# LabStart Service — Plex
# Media server (requires free Plex account)

cat << 'COMPOSE'
  plex:
    image: linuxserver/plex:latest
    container_name: plex
    ports:
      - "32400:32400"
    environment:
      - PLEX_CLAIM=${PLEX_CLAIM}
    volumes:
      - ./config/plex:/config
      - ./media:/media
    restart: unless-stopped
COMPOSE