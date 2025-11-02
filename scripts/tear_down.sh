#!/usr/bin/env bash
# Tear down demo resources created manually (use with caution)
set -euo pipefail

SERVICE=${1:-"demo"}
REGION=${REGION:-"us-central1"}

if [ -z "$SERVICE" ]; then
  echo "Usage: ./tear_down.sh <service-name>"
  exit 2
fi

# Delete Cloud Run service
gcloud run services delete "$SERVICE" --region "$REGION" --platform=managed --quiet || true

echo "Requested deletion of service $SERVICE in $REGION"
