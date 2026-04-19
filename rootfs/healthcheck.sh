#!/usr/bin/env bash
set -e

APACHE_PORT="${APACHE_PORT:-80}"

pgrep -x xlxd >/dev/null 2>&1
test -f /var/log/xlxd.xml
pgrep -x apache2 >/dev/null 2>&1
curl -fsS "http://127.0.0.1:${APACHE_PORT}/" >/dev/null
