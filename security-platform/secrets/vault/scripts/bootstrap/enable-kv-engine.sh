#!/usr/bin/env bash
set -euo pipefail

vault secrets enable -path=secret kv-v2 || echo "KV engine already enabled at path 'secret'"