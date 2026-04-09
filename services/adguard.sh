#!/usr/bin/env bash
# LabStart Service — AdGuard Home
# Network-wide ad blocker

cat << 'COMPOSE'
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3000:3000"
    volumes:
      - ./config/adguard/work:/opt/adguardhome/work
      - ./config/adguard/conf:/opt/adguardhome/conf
    restart: unless-stopped
COMPOSE