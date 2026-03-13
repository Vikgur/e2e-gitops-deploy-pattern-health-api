#!/usr/bin/env bash
set -euo pipefail

vault secrets enable transit || echo "Transit engine already enabled"

vault write -f transit/keys/vault-key