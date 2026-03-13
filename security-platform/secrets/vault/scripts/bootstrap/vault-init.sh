#!/usr/bin/env bash
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"

vault operator init -key-shares=5 -key-threshold=3 -format=json > /vault/init-keys.json
echo "Vault initialized. Keys and root token saved to /vault/init-keys.json"