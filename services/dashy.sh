#!/usr/bin/env bash
# LabStart Service — Dashy
# Homelab dashboard

cat << 'EOF'
  dashy:
    image: lissy93/dashy:latest
    container_name: dashy
    ports:
      - "4000:8080"
    volumes:
      - ./config/dashy:/app/user-data
    restart: unless-stopped
EOF