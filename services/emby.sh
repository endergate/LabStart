#!/usr/bin/env bash
# LabStart Service — Emby
# Personal media server

cat << 'COMPOSE'
  emby:
    image: emby/embyserver:latest
    container_name: emby
    ports:
      - "8097:8096"
    volumes:
      - ./config/emby:/config
      - ./media:/media
    restart: unless-stopped
COMPOSE