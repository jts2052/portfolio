#!/usr/bin/env bash
#
# One-shot bootstrap for the portfolio app on a fresh Debian 13 LXC.
# Run as root, inside the container.
#
# Edit REPO_URL and DOMAIN below, then:
#   chmod +x deploy/install.sh && sudo ./deploy/install.sh
#
# After this finishes, add the public hostname in Cloudflare Zero Trust:
#   portfolio.<your domain>  ->  http://localhost:80
#
set -euo pipefail

# === EDIT THESE =====================================================
REPO_URL="https://github.com/jts2052/portfolio.git"
DOMAIN="portfolio.jacob-smith.online"
# ====================================================================

INSTALL_DIR=/opt/portfolio
DATA_DIR=/var/lib/portfolio
APP_USER=portfolio
NODE_MAJOR=20

if [[ "$EUID" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

echo "==> Installing system packages"
apt update
apt install -y curl ca-certificates gnupg git python3 python3-venv nginx

echo "==> Installing Node.js ${NODE_MAJOR}.x"
if ! command -v node >/dev/null || [[ "$(node -v)" != v${NODE_MAJOR}* ]]; then
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -
  apt install -y nodejs
fi

echo "==> Creating app user '${APP_USER}'"
if ! id "$APP_USER" >/dev/null 2>&1; then
  useradd --system --create-home --home-dir "$INSTALL_DIR" --shell /bin/bash "$APP_USER"
fi

echo "==> Preparing persistent data dir at ${DATA_DIR}"
mkdir -p "$DATA_DIR"
[[ -f "$DATA_DIR/clicks.txt" ]] || echo -n "0" > "$DATA_DIR/clicks.txt"
chown -R "$APP_USER:$APP_USER" "$DATA_DIR"
chmod 750 "$DATA_DIR"

echo "==> Cloning repo into ${INSTALL_DIR}"
if [[ ! -d "$INSTALL_DIR/.git" ]]; then
  rm -rf "${INSTALL_DIR:?}"/* "${INSTALL_DIR:?}"/.[!.]* 2>/dev/null || true
  runuser -u "$APP_USER" -- git clone "$REPO_URL" "$INSTALL_DIR"
else
  runuser -u "$APP_USER" -- git -C "$INSTALL_DIR" pull --ff-only
fi

echo "==> Building frontend"
runuser -u "$APP_USER" -- bash -c "cd '$INSTALL_DIR' && npm ci && npm run build"

echo "==> Setting up Python venv"
if [[ ! -d "$INSTALL_DIR/server/.venv" ]]; then
  runuser -u "$APP_USER" -- python3 -m venv "$INSTALL_DIR/server/.venv"
fi
runuser -u "$APP_USER" -- "$INSTALL_DIR/server/.venv/bin/pip" install --upgrade pip
runuser -u "$APP_USER" -- "$INSTALL_DIR/server/.venv/bin/pip" install -r "$INSTALL_DIR/server/requirements.txt"

echo "==> Installing systemd unit"
install -m 644 "$INSTALL_DIR/deploy/portfolio.service" /etc/systemd/system/portfolio.service
systemctl daemon-reload
systemctl enable portfolio
systemctl restart portfolio

echo "==> Installing nginx vhost for ${DOMAIN}"
sed "s/__DOMAIN__/${DOMAIN}/g" "$INSTALL_DIR/deploy/nginx-portfolio.conf" \
  > /etc/nginx/sites-available/portfolio
ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/portfolio
nginx -t
systemctl reload nginx

echo
echo "Done."
echo "  - App:    http://localhost (Host: ${DOMAIN})"
echo "  - API:    systemctl status portfolio"
echo "  - Logs:   journalctl -u portfolio -f"
echo "  - Update: sudo ${INSTALL_DIR}/deploy/update.sh"
echo
echo "Remember to add the public hostname '${DOMAIN}' -> http://localhost:80"
echo "in Cloudflare Zero Trust > Networks > Tunnels."
