#!/usr/bin/env bash
set -euo pipefail

URL="$1"

if [ -z "$URL" ]; then
  echo "Usage: ./smoke_test.sh <service_url>"
  exit 2
fi

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL/health")
if [ "$HTTP_STATUS" = "200" ]; then
  echo "Smoke test passed"
  exit 0
else
  echo "Smoke test failed: HTTP $HTTP_STATUS"
  exit 1
fi
