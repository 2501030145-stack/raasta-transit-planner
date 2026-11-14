# Raasta Backend: Production Deployment & HTTPS Setup

**Target Environment:** Linux (Ubuntu 22.04 LTS / 24.04 LTS, Debian 12)  
**Binary:** `raasta-server` (C++17, statically or dynamically linked with `libmysqlclient`)  
**Architecture:** Reverse Proxy (Nginx / Caddy) -> HTTPS Termination -> Localhost Port 8088  
**Client Origin:** `https://raasta-mpxyck7w.manus.space`

---

## 1. System Prerequisites

Install required build essentials and runtime dependencies on the target host:

```bash
# Update package indices
sudo apt-get update && sudo apt-get upgrade -y

# Build tools & compilers
sudo apt-get install -y build-essential cmake git pkg-config \
  libssl-dev libmysqlclient-dev libcurl4-openssl-dev

# Reverse proxy & SSL automation
sudo apt-get install -y nginx certbot python3-certbot-nginx
```

---

## 2. Directory Structure & Compilation

Place the backend in `/opt/raasta-backend`:

```bash
sudo mkdir -p /opt/raasta-backend
sudo chown -R $USER:$USER /opt/raasta-backend
cd /opt/raasta-backend

# Clone or copy repository files
# Ensure ./data directory and CMakeLists.txt are present

# Configure and compile in Release mode
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)

# Verify all unit and integration tests pass
cd build && ctest --output-on-failure
cd ..
```

---

## 3. Production Environment File (`.env`)

Create `/opt/raasta-backend/.env`:

```ini
# Server Network Configuration
SERVER_PORT=8088
CORS_ORIGIN=https://raasta-mpxyck7w.manus.space

# MySQL Database Connection (Optional; CSV fallback available if DB offline)
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=raasta_prod
DB_PASSWORD=YOUR_STRONG_DATABASE_PASSWORD_HERE
DB_NAME=raasta_db

# Security & Admin Authentication
# Generate with: openssl rand -hex 32
ADMIN_JWT_SECRET=f4a8b79e2c6d1e0f983b5478a2e1d09bc38475a1e2f3d4c5b6a7890123456789
ADMIN_DEFAULT_USER=raasta_admin
ADMIN_DEFAULT_PASSWORD=YOUR_STRONG_ADMIN_PASSWORD_HERE

# Data Files & Logging
DATA_DIR=./data
LOG_LEVEL=info
```

Restrict file permissions:
```bash
chmod 600 /opt/raasta-backend/.env
```

---

## 4. Systemd Service Configuration

Create a dedicated system user and service file to keep the backend running continuously and automatically restart on failure:

```bash
sudo useradd -r -s /bin/false -d /opt/raasta-backend raasta
sudo chown -R raasta:raasta /opt/raasta-backend
```

Create `/etc/systemd/system/raasta.service`:

```ini
[Unit]
Description=Raasta Public Transport Route Engine
After=network.target mysql.service
Wants=network-online.target

[Service]
Type=simple
User=raasta
Group=raasta
WorkingDirectory=/opt/raasta-backend
ExecStart=/opt/raasta-backend/build/raasta-server
Restart=always
RestartSec=5s

# Security Hardening
ProtectSystem=full
ProtectHome=true
NoNewPrivileges=true
PrivateTmp=true

# Environment
EnvironmentFile=/opt/raasta-backend/.env

# Resource Limits
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

Enable and start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable raasta
sudo systemctl start raasta
sudo systemctl status raasta
```

---

## 5. HTTPS Reverse Proxy Configuration (Nginx)

The C++ HTTP engine listens on `127.0.0.1:8088`. Nginx terminates TLS/SSL and proxies traffic to the local port.

Create `/etc/nginx/sites-available/raasta-api.conf`:

```nginx
server {
    server_name api.raasta.yourdomain.com;

    # Rate limiting zone (optional, protects against DDoS)
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=30r/s;

    location / {
        limit_req zone=api_limit burst=50 nodelay;

        proxy_pass http://127.0.0.1:8088;
        proxy_http_version 1.1;

        # Header forwarding
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Origin $http_origin;

        # Keepalive & timeouts
        proxy_connect_timeout 10s;
        proxy_read_timeout 30s;
        proxy_send_timeout 30s;
    }
}
```

Enable the site and obtain a free Let's Encrypt SSL certificate:

```bash
sudo ln -s /etc/nginx/sites-available/raasta-api.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Issue SSL certificate
sudo certbot --nginx -d api.raasta.yourdomain.com --non-interactive --agree-tos -m admin@yourdomain.com
```

---

## 6. Alternative HTTPS Configuration (Caddy)

If using Caddy instead of Nginx, TLS certificate provisioning is fully automatic:

`/etc/caddy/Caddyfile`:
```caddy
api.raasta.yourdomain.com {
    reverse_proxy 127.0.0.1:8088 {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-Proto {scheme}
    }
}
```

Restart Caddy:
```bash
sudo systemctl restart caddy
```

---

## 7. Firewall (UFW) Security

Ensure only ports 80, 443, and 22 are accessible publicly. Keep port 8088 internal:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## 8. Post-Deployment Verification

Verify HTTPS endpoint responses from an external machine:

```bash
# 1. Health check
curl -i https://api.raasta.yourdomain.com/health

# 2. CORS preflight check for Manus origin
curl -i -X OPTIONS https://api.raasta.yourdomain.com/api/v1/routes/plan \
  -H "Origin: https://raasta-mpxyck7w.manus.space" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type"

# 3. Route plan test
curl -s -X POST https://api.raasta.yourdomain.com/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{"source_station_id": 4, "destination_station_id": 14, "criteria": "fastest"}'
```

