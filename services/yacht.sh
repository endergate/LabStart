#!/usr/bin/env bash
# LabStart Service — Yacht
# Simple Docker container management UI

cat << 'COMPOSE'
  yacht:
    image: selfhostedpro/yacht:latest
    container_name: yacht
    ports:
      - "8001:8000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config/yacht:/config
    restart: unless-stopped
COMPOSE