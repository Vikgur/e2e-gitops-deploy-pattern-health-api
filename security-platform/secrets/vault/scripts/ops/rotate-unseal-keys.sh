#!/usr/bin/env bash
set -euo pipefail

vault operator rekey -init -key-shares=5 -key-threshold=3 -format=json > /vault/rekey.json
echo "Unseal keys rotated. New keys saved to /vault/rekey.json"