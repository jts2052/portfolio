#!/usr/bin/env bash
#
# Re-deploy the portfolio after a push.
#   sudo /opt/portfolio/deploy/update.sh
#
set -euo pipefail

INSTALL_DIR=/opt/portfolio
APP_USER=portfolio

if [[ "$EUID" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

echo "==> Pulling latest"
runuser -u "$APP_USER" -- git -C "$INSTALL_DIR" pull --ff-only

echo "==> Rebuilding frontend"
runuser -u "$APP_USER" -- bash -c "cd '$INSTALL_DIR' && npm ci && npm run build"

echo "==> Refreshing Python deps"
runuser -u "$APP_USER" -- "$INSTALL_DIR/server/.venv/bin/pip" install -r "$INSTALL_DIR/server/requirements.txt"

echo "==> Re-syncing systemd unit and nginx vhost (in case they changed)"
install -m 644 "$INSTALL_DIR/deploy/portfolio.service" /etc/systemd/system/portfolio.service
systemctl daemon-reload

# preserve the domain that was originally rendered into sites-available
if [[ -f /etc/nginx/sites-available/portfolio ]]; then
  CURRENT_DOMAIN="$(awk '/server_name/ {print $2; exit}' /etc/nginx/sites-available/portfolio | tr -d ';')"
  if [[ -n "$CURRENT_DOMAIN" ]]; then
    sed "s/__DOMAIN__/${CURRENT_DOMAIN}/g" "$INSTALL_DIR/deploy/nginx-portfolio.conf" \
      > /etc/nginx/sites-available/portfolio
  fi
fi

echo "==> Restarting services"
systemctl restart portfolio
nginx -t && systemctl reload nginx

echo "Updated."
