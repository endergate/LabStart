#!/usr/bin/env bash
# LabStart Service — Dynu
# Free dynamic DNS service

cat << 'COMPOSE'
  dynu:
    image: oznu/ddclient:latest
    container_name: dynu
    environment:
      - DDCLIENT_PROTOCOL=dyndns2
      - DDCLIENT_SERVER=api.dynu.com
      - DDCLIENT_USERNAME=${DYNU_USERNAME}
      - DDCLIENT_PASSWORD=${DYNU_PASSWORD}
      - DDCLIENT_DOMAIN=${DYNU_DOMAIN}
    volumes:
      - ./config/dynu:/config
    restart: unless-stopped
COMPOSE