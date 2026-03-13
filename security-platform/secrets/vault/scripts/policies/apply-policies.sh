#!/usr/bin/env bash
set -euo pipefail

POLICY_DIR="${POLICY_DIR:-/vault/security/vault/policies}"

for file in $POLICY_DIR/*.hcl; do
  policy_name=$(basename "$file" .hcl)
  vault policy write "$policy_name" "$file"
done

echo "Policies applied"