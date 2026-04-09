#!/usr/bin/env bash
# LabStart Service — Portainer
# Docker container management UI

cat << 'COMPOSE'
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config/portainer:/data
    restart: unless-stopped
COMPOSE