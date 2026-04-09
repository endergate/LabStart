#!/usr/bin/env bash
# LabStart Service — OpenVPN
# Battle-tested open source VPN

cat << 'COMPOSE'
  openvpn:
    image: kylemanna/openvpn:latest
    container_name: openvpn
    ports:
      - "1194:1194/udp"
    volumes:
      - ./config/openvpn:/etc/openvpn
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
COMPOSE