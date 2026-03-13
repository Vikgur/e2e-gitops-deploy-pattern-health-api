#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="${BACKUP_FILE:-/vault/backup/vault-snapshot.snap}"

vault operator raft snapshot restore "$BACKUP_FILE"
echo "Vault restored from $BACKUP_FILE"