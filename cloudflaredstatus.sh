#!/bin/bash
# https://github.com/PtrckM/scripts
# Check cloudflare Status v1

# Local timestamp
echo "🕒 Local Check Time: $(date)"
echo

# Fetch overall status JSON
status_json=$(curl -s https://www.cloudflarestatus.com/api/v2/status.json)

# Extract and display overall status and updated time
overall_status=$(echo "$status_json" | jq -r '.status.description')
updated_at=$(echo "$status_json" | jq -r '.page.updated_at')

echo "🌐 Cloudflare Overall Status: $overall_status"
echo "📅 Last Updated (Cloudflare): $updated_at"
echo

# Fetch components
echo "📦 Components with issues:"
curl -s https://www.cloudflarestatus.com/api/v2/components.json | jq -r '
  .components[] | select(.status != "operational") |
  "- \(.name): \(.status)"
'

echo
