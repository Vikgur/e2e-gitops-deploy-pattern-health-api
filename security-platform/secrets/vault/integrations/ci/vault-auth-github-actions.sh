#!/usr/bin/env bash

set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-https://vault.example.com}"
VAULT_ROLE="ci-role"

OIDC_TOKEN="$(curl -sH "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" \
"$ACTIONS_ID_TOKEN_REQUEST_URL&audience=vault" | jq -r '.value')"

LOGIN_RESPONSE=$(curl -s --request POST \
  --data "{\"role\":\"${VAULT_ROLE}\",\"jwt\":\"${OIDC_TOKEN}\"}" \
  ${VAULT_ADDR}/v1/auth/jwt/login)

VAULT_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.auth.client_token')

export VAULT_TOKEN

echo "Vault authentication successful"