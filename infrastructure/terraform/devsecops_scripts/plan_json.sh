#!/usr/bin/env bash
set -euo pipefail

# Инициализация Terragrunt (обновление провайдеров и модулей)
terragrunt init -upgrade >/dev/null

# Формирование плана
terragrunt plan -out=tfplan

# Конвертация плана в JSON
terraform show -json tfplan > plan.json

# Проверка политики безопасности через OPA/Conftest
conftest test --input json plan.json -p ../../policy/terraform
