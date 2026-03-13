#!/usr/bin/env bash
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://vault.vault.svc.cluster.local:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-}"

vault kv put secret/data/apps/database \
  db_user="app_user" \
  db_password="CHANGE_ME"