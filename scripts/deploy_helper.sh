#!/usr/bin/env bash
# Simple helper to build and deploy to Cloud Run (local convenience script)
set -euo pipefail

PROJECT=${PROJECT:-"your-project-id"}
REGION=${REGION:-"us-central1"}
REPO=${REPO:-"demo-repo"}
SERVICE=${SERVICE:-"demo"}
IMAGE_TAG=${IMAGE_TAG:-"local"}

IMAGE="$REGION-docker.pkg.dev/$PROJECT/$REPO/$SERVICE:$IMAGE_TAG"

# Build and push using gcloud builds
gcloud builds submit --tag "$IMAGE"

# Deploy to Cloud Run
gcloud run deploy "$SERVICE" \
  --image="$IMAGE" \
  --region="$REGION" \
  --platform=managed \
  --allow-unauthenticated --quiet

echo "Deployed $SERVICE -> $IMAGE"
