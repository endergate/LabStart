#!/usr/bin/env bash
# LabStart Service — Homarr
# Modern dashboard with drag-and-drop interface

cat << 'COMPOSE'
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr
    ports:
      - "7575:7575"
    volumes:
      - ./config/homarr:/app/data/configs
    restart: unless-stopped

COMPOSE