#!/usr/bin/env bash
# LabStart Service — Homepage
# Feature-rich homelab dashboard

cat << 'COMPOSE'
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./config/homepage:/app/config
    restart: unless-stopped
COMPOSE