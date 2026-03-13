#!/usr/bin/env bash
set -euo pipefail

vault auth enable oidc || echo "OIDC auth already enabled"

vault write auth/oidc/config \
    oidc_discovery_url="https://token.actions.githubusercontent.com" \
    oidc_client_id="$GITHUB_CLIENT_ID" \
    default_role="ci-role"