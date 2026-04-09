#!/usr/bin/env bash
# LabStart Service — Pi-hole
# Network-wide ad blocker

cat << 'COMPOSE'
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8080:80"
    environment:
      - WEBPASSWORD=${PIHOLE_PASSWORD}
    volumes:
      - ./config/pihole:/etc/pihole
    restart: unless-stopped
COMPOSE
