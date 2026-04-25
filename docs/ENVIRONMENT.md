# Environment Variables Guide

LabStart stores all your passwords, API keys, and configuration in a `.env` file. This guide explains how to view and update them.

---

## 📍 Location

**To view your `.env` file:**
```bash
cd ~/LabStart
cat .env
```

**To edit your `.env` file:**
```bash
cd ~/LabStart
nano .env
```

After editing with nano:
- Press `Ctrl+X` to exit
- Press `Y` to save changes
- Press `Enter` to confirm

---

## 🔑 What's Inside

The `.env` file contains all credentials you entered during setup:

```bash
# Pi-hole
PIHOLE_PASSWORD=your_password_here

# Plex
PLEX_CLAIM=your_claim_token_here

# WireGuard
WG_SERVER_URL=vpn.yourdomain.com

# Cloudflare DDNS
CF_API_TOKEN=your_token_here
CF_DOMAIN=yourdomain.com
```

---

## ✏️ How to Update Credentials

1. **Edit the .env file:**
```bash
   nano .env
```

2. **Change the value** you want to update

3. **Restart the container:**
```bash
   docker restart <container-name>
```
   
   Example: `docker restart pihole`

---

## 🆘 Common Issues

**I forgot my Pi-hole password**
```bash
cat .env | grep PIHOLE_PASSWORD
```

**I changed the password but it's not working**
```bash
docker restart pihole
```
Wait 10 seconds, then try logging in again.

---

**Need help?** [Open an issue on GitHub](https://github.com/endergate/LabStart/issues)