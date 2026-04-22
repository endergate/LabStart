#!/usr/bin/env bash
# LabStart Service — Homepage
# Dashboard for your homelab

cat << 'COMPOSE'
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./config/homepage:/app/config
    environment:
      - HOMEPAGE_ALLOWED_HOSTS=*
    restart: unless-stopped

COMPOSE