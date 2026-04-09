#!/usr/bin/env bash
# LabStart Service — Uptime Kuma
# Service monitoring and status pages

cat << 'COMPOSE'
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - "3001:3001"
    volumes:
      - ./config/uptime-kuma:/app/data
    restart: unless-stopped
COMPOSE