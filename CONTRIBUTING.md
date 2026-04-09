# Contributing to LabStart

Thank you for your interest in contributing to LabStart!
This guide will show you how to add a new service.

## How to Add a New Service

### Step 1 - Create a service file

Copy an existing service as a template:

```bash
cp services/pihole.sh services/yourservice.sh
chmod +x services/yourservice.sh
```

### Step 2 - Edit the service file

Open `services/yourservice.sh` and fill in:
- The correct Docker image
- The correct ports
- Any required environment variables
- Any required volumes

### Step 3 - Add it to the wizard

Open `labstart.sh` and find the relevant category.
Add your service as a new option following the same pattern.

### Step 4 - Test it

Run the wizard and select your new service:
```bash
./labstart.sh
```

Check the generated `docker-compose.yml` looks correct.

### Step 5 - Submit a Pull Request

Push your changes and open a PR on GitHub.
Describe what service you added and why it's useful for homelab beginners.

## Guidelines

- Keep service files simple and beginner friendly
- Use `latest` image tags
- Always include `restart: unless-stopped`
- Test your service before submitting