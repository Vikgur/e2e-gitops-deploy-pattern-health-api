#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/vault/backup}"

vault operator raft snapshot save "$BACKUP_DIR/vault-snapshot.snap"
echo "Vault backup saved to $BACKUP_DIR/vault-snapshot.snap"