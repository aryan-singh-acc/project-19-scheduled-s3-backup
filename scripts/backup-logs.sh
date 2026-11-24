#!/bin/bash

set -euo pipefail

BUCKET="aryan-w-singh-project-19-backup-2026"
REGION="us-east-2"
PROJECT_DIR="/home/clouduser/project-19-scheduled-s3-backup"
BACKUP_DIR="$PROJECT_DIR/logs"
RUN_LOG="$PROJECT_DIR/backup.log"
TIMESTAMP=$(date -u +"%Y%m%d-%H%M%S")
HOSTNAME=$(hostname)

ARCHIVE="$BACKUP_DIR/${HOSTNAME}-logs-${TIMESTAMP}.tar.gz"
S3_PATH="s3://${BUCKET}/linux-logs/${HOSTNAME}/$(basename "$ARCHIVE")"

mkdir -p "$BACKUP_DIR"

echo "[$(date -u)] Starting log backup" >> "$RUN_LOG"

tar -czf "$ARCHIVE" \
    -C /var/log \
    syslog auth.log

aws s3 cp "$ARCHIVE" "$S3_PATH" \
    --region "$REGION" \
    >> "$RUN_LOG" 2>&1

echo "[$(date -u)] Backup uploaded: $S3_PATH" >> "$RUN_LOG"

echo "Backup completed successfully: $ARCHIVE"
