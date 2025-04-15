# 🚀 Custom NGINX Docker Base Image with Supervisor Support

This project provides a lightweight and customizable Docker base image built on `nginx:mainline-alpine`. It integrates essential tools such as Supervisor, Git, and timezone configuration while setting up a secure non-root user for runtime operations.

---

## 🧱 Purpose

The goal of this project was to create a custom base Docker image suitable for deploying web services that:
- Use NGINX as a reverse proxy or static file server.
- Run multiple processes managed by Supervisor.
- Maintain a lean image size using Alpine Linux.
- Include sensible defaults and custom user setup for security and flexibility.

---

## 📂 Image Contents

- **Base Image**: `nginx:mainline-alpine`
- **Runtime User**: `web_runtime_user` (non-login shell, added to `www-data` group)
- **Installed Tools**:
  - `git`
  - `shadow` (for user and password management)
  - `supervisor`
  - `tzdata` (timezone set to UTC)
- **Logging**:
  - Logs stored at `/tmp/log/nginx` and `/var/log/nginx`
  - Permissions adjusted for the runtime user

---

## 🛠 Configuration Files

### 🔧 `nginx.conf`
Custom NGINX configuration to:
- Enable basic logging.
- Include additional configs from `conf.d/`.
- Use default MIME types and sendfile optimization.

### 🧑‍🏭 `supervisord.conf` & `supervisor.conf`
Supervisor is configured as the main entrypoint process manager for running and monitoring multiple services (e.g., NGINX, background workers).

---

## 🔒 User Setup

A user named `web_runtime_user` is created with:
- No login shell (`/sbin/nologin`)
- Pre-set encrypted password (SHA-256 hash)
- Membership in the `www-data` group

This setup helps in running processes securely without root privileges.

---

## 🧼 Cleanup

To keep the image size minimal:
- APK cache and temporary files are removed.
- Execute permissions are added to all `.sh` files for easier scripting support.

---

## 🚪 Ports

The container exposes:
- `80`: HTTP
- `443`: HTTPS

---

## 🧪 How to Use

```bash
docker build -t custom-nginx-base .
```

You can extend this base image in your own `Dockerfile`:

```Dockerfile
FROM custom-nginx-base

COPY ./your-app /var/www/html
```

---

## 📁 Directory Structure

```bash
.
├── Dockerfile
├── nginx
│   └── nginx.conf
├── conf.d
│   └── [your nginx virtual host configs]
├── supervisord.conf
└── supervisor.conf
```

---

## 📌 Notes

- Remember to adjust `supervisor.conf` to match your process needs.
- You can easily add PHP-FPM, Node.js, or other services via Supervisor configuration blocks.

