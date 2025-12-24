#!/bin/bash

# ===================== CONFIG =====================
CF_API_TOKEN="PASTE_YOUR_REAL_API_TOKEN"
ZONE_ID="PASTE_ZONE_ID"

DOMAIN="proxyweb.dpdns.org"
DEST_EMAIL="anuragkumar671988@gmail.com"
TOTAL=50
OUTPUT_FILE="created_emails.txt"
# ==================================================

API="https://api.cloudflare.com/client/v4"

# Clear output file
> "$OUTPUT_FILE"

# Generate random username (6 chars)
rand_user() {
  tr -dc 'a-z0-9' </dev/urandom | head -c 6
}

declare -A USED
COUNT=0

echo "🚀 Creating $TOTAL randomized email routing rules..."
echo

while [ $COUNT -lt $TOTAL ]; do
  USER=$(rand_user)

  # avoid duplicates in same run
  if [[ -n "${USED[$USER]}" ]]; then
    continue
  fi
  USED[$USER]=1

  EMAIL="$USER@$DOMAIN"

  echo "➕ Creating: $EMAIL → $DEST_EMAIL"

  RESPONSE=$(curl -s -X POST \
    "$API/zones/$ZONE_ID/email/routing/rules" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "enabled": true,
      "name": "rand-'$USER'",
      "matchers": [
        {
          "type": "literal",
          "field": "to",
          "value": "'"$EMAIL"'"
        }
      ],
      "actions": [
        {
          "type": "forward",
          "value": ["'"$DEST_EMAIL"'"]
        }
      ]
    }')

  if echo "$RESPONSE" | grep -q '"success":true'; then
    echo "$EMAIL" >> "$OUTPUT_FILE"
    ((COUNT++))
  else
    echo "⚠️ Failed to create $EMAIL"
    echo "$RESPONSE"
  fi

  sleep 0.3
done

echo
echo "✅ DONE"
echo "📄 Exported emails saved to: $OUTPUT_FILE"
