#!/usr/bin/env bash
# LabStart Service — Jellyfin
# Free and open source media server

cat << 'COMPOSE'
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096"
    volumes:
      - ./config/jellyfin:/config
      - ./media:/media
    restart: unless-stopped
COMPOSE