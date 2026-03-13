#!/usr/bin/env bash
set -euo pipefail

vault secrets enable database || echo "Database engine already enabled"

vault write database/config/my-postgres-database \
    plugin_name=postgresql-database-plugin \
    allowed_roles="backend-role,frontend-role" \
    connection_url="postgresql://{{username}}:{{password}}@postgres.default.svc.cluster.local:5432/postgres?sslmode=disable" \
    username="postgres" \
    password="$POSTGRES_PASSWORD"