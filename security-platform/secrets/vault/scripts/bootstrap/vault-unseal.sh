#!/usr/bin/env bash
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
KEY_FILE="${KEY_FILE:-/vault/init-keys.json}"

for key in $(jq -r '.unseal_keys_b64[]' $KEY_FILE); do
  vault operator unseal "$key"
done
echo "Vault unsealed"