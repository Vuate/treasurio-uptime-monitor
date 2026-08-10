#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="state.json"
BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

URLS=(
  "https://app.treasurio.xyz"
  "https://treasurio.xyz"
)

if [ ! -f "$STATE_FILE" ]; then
  echo "{}" > "$STATE_FILE"
fi

send_telegram() {
  local text="$1"
  curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${text}" \
    -d parse_mode="HTML" > /dev/null
}

for url in "${URLS[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" || echo "000")

  if [[ "$code" =~ ^(2|3) ]]; then
    status="up"
  else
    status="down"
  fi

  prev=$(jq -r --arg u "$url" '.[$u].status // "unknown"' "$STATE_FILE")

  if [ "$prev" != "unknown" ] && [ "$prev" != "$status" ]; then
    if [ "$status" = "down" ]; then
      send_telegram "🔴 <b>DOWN</b>: ${url} (HTTP ${code})"
    else
      send_telegram "🟢 <b>RECOVERED</b>: ${url}"
    fi
  fi

  tmp=$(mktemp)
  jq --arg u "$url" --arg s "$status" --arg t "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    '.[$u] = {status: $s, last_checked: $t}' "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
done
