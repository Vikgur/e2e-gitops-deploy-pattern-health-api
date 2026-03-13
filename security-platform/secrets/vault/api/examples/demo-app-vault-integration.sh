#!/usr/bin/env bash
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://vault.vault.svc.cluster.local:8200}"
ROLE="${ROLE:-backend-role}"

echo "=== Demo: Vault Integration for health-api ==="

# Получение JWT токена OIDC/K8s для логина
JWT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
echo "[Step 1] Retrieved Kubernetes service account token"

# Логин в Vault через Kubernetes auth
VAULT_RESP=$(curl -s --request POST \
  --data "{\"role\":\"${ROLE}\",\"jwt\":\"${JWT_TOKEN}\"}" \
  ${VAULT_ADDR}/v1/auth/kubernetes/login)

VAULT_TOKEN=$(echo "$VAULT_RESP" | jq -r '.auth.client_token')
export VAULT_TOKEN
echo "[Step 2] Logged in to Vault as role '${ROLE}'"

# Чтение секрета из KV-v2
DB_USER=$(vault kv get -field=db_user secret/data/apps/database)
DB_PASSWORD=$(vault kv get -field=db_password secret/data/apps/database)
echo "[Step 3] Retrieved secrets from Vault KV-v2"

# Пример использования секрета в приложении
echo "[Step 4] Connecting to database with the following credentials:"
echo "DB_USER=$DB_USER"
echo "DB_PASSWORD=$DB_PASSWORD"
# Здесь можно вставить вызов реального приложения, например:
# python app.py --db-user "$DB_USER" --db-password "$DB_PASSWORD"

echo "=== Demo Completed ==="