#!/usr/bin/env bash
set -e

TARGET_URL=$1

echo "Starting OWASP ZAP scan against: $TARGET_URL"

docker pull owasp/zap2docker-stable

docker run --rm -t owasp/zap2docker-stable zap-baseline.py -t "$TARGET_URL" -r zap_report.html || true

echo "ZAP scan complete. Check zap_report.html for details."