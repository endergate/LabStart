#!/usr/bin/env bash
# LabStart Service — No-IP
# Dynamic DNS service

cat << 'COMPOSE'
  noip:
    image: coppit/no-ip:latest
    container_name: noip
    environment:
      - USERNAME=${NOIP_USERNAME}
      - PASSWORD=${NOIP_PASSWORD}
      - DOMAINS=${NOIP_DOMAIN}
    volumes:
      - ./config/noip:/config
    restart: unless-stopped
COMPOSE