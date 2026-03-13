#!/usr/bin/env bash
set -euo pipefail

SECRETS_PATH="${SECRETS_PATH:-secret/data/apps}"
for secret in $(vault kv list -format=json $SECRETS_PATH | jq -r '.[]'); do
  vault kv put "$SECRETS_PATH/$secret" value="$(openssl rand -hex 16)"
done
echo "Secrets rotated"