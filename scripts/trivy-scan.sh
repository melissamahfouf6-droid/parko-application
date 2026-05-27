#!/usr/bin/env bash
# Run the same Trivy checks as CI locally.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

IMAGE_TAG="${1:-parko-api:local}"

echo "==> Backend prod dependencies"
(cd backend && npm ci --omit=dev)

echo "==> Build Docker image: $IMAGE_TAG"
docker build -t "$IMAGE_TAG" -f backend/Dockerfile backend

echo "==> Trivy filesystem (backend)"
trivy fs --severity CRITICAL,HIGH --ignore-unfixed --scanners vuln backend

echo "==> Trivy image (OS + Node libraries): $IMAGE_TAG"
trivy image --severity CRITICAL,HIGH --ignore-unfixed --vuln-type os,library "$IMAGE_TAG"

echo "All Trivy scans passed."
