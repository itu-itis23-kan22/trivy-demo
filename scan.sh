#!/usr/bin/env bash
# scan.sh — Trivy demo: scan multiple images and save JSON reports

set -euo pipefail

IMAGES=(
  "nginx:1.14"
  "python:3.6-slim"
)

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"

echo "================================================"
echo " Trivy Vulnerability Scanner — Demo"
echo "================================================"

for IMAGE in "${IMAGES[@]}"; do
  SAFE_NAME=$(echo "$IMAGE" | tr ':/' '--')
  REPORT_FILE="$REPORT_DIR/${SAFE_NAME}.json"

  echo ""
  echo "Scanning: $IMAGE"
  echo "Output  : $REPORT_FILE"
  echo "------------------------------------------------"

  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v trivy-cache:/root/.cache/trivy \
    -v "$(pwd)/$REPORT_DIR:/reports" \
    aquasec/trivy:latest image \
      --format json \
      --output "/reports/${SAFE_NAME}.json" \
      "$IMAGE"

  echo "Done: $IMAGE"
done

echo ""
echo "================================================"
echo " All scans complete. Reports saved to ./$REPORT_DIR/"
echo "================================================"
