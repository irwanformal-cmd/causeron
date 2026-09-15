#!/usr/bin/env bash
# Causeron — one-command launcher.
set -e
cd "$(dirname "$0")"

if [ ! -f .env ]; then
  cp .env.example .env 2>/dev/null || true
fi

PORT="${CAUSERON_PORT:-8000}"
echo "Starting Causeron on http://127.0.0.1:${PORT} ..."
exec python3 server.py
