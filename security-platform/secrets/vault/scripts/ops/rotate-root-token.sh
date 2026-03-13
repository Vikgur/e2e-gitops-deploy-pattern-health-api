#!/usr/bin/env bash
set -euo pipefail

vault operator generate-root -format=json > /vault/root-generation.json
otp=$(jq -r '.otp' /vault/root-generation.json)

for key in $(jq -r '.nonce' /vault/root-generation.json); do
  vault operator generate-root -otp="$otp" -n="$key"
done

vault operator generate-root -finalize
echo "Root token rotated"