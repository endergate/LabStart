#!/usr/bin/env bash
# LabStart Service — Netdata
# Real-time system monitoring

cat << 'COMPOSE'
  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    ports:
      - "19999:19999"
    restart: unless-stopped
COMPOSE