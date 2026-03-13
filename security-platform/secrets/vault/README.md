# Оглавление

- [Назначение](#назначение)
- [Архитектура системы](#архитектура-системы)
  - [Компоненты Vault](#компоненты-vault)
  - [PKI в Vault](#pki-в-vault)
  - [Потоки данных (Data Flow)](#потоки-данных-data-flow)
  - [Интеграции](#интеграции)
  - [Инфраструктурный стек](#инфраструктурный-стек)
- [Расположение конфигураций](#расположение-конфигураций)
- [Пошаговое внедрение](#пошаговое-внедрение)
  - [Подготовка](#подготовка)
  - [Этап 1 — Bootstrap Vault](#этап-1--bootstrap-vault)
  - [Этап 2 — Настройка Auth](#этап-2--настройка-auth)
  - [Этап 3 — Применение политик](#этап-3--применение-политик)
  - [Этап 4 — Операции](#этап-4--операции)
  - [Этап 5 — Интеграция с приложениями](#этап-5--интеграция-с-приложениями)
  - [Этап 6 — Helm и Kubernetes](#этап-6--helm-и-kubernetes)
  - [Этап 7 — Observability](#этап-7--observability)
- [Проверка работоспособности](#проверка-работоспособности)
- [Ссылки](#ссылки)

---

# Назначение

Vault в проекте health‑api: руководство по внедрению.

**Vault** — система безопасного хранения и управления секретами, ключами шифрования и конфиденциальными данными.

**Как повышает безопасность health‑api:**
- Централизованное хранение секретов (API-ключи, токены, TLS-сертификаты, пароли)
- Управление ротацией секретов и ключей шифрования
- Интеграция с Kubernetes через Vault Agent или External Secrets
- Контроль доступа на основе ролей и политик
- Поддержка шифрования данных в движках KV, Transit и Database
- Мониторинг и аудит операций

# Архитектура системы

## Компоненты Vault

- **Vault Server** — основная нода для хранения секретов
- **Storage Backend** — место хранения данных (например, Consul или файловая система)
- **Auth Methods** — способы аутентификации (Kubernetes, GitHub OIDC)
- **Policies** — контроль доступа пользователей и приложений
- **Engines** — KV, Transit, Database
- **Audit & Telemetry** — логирование действий и метрики

## PKI в Vault

Vault поддерживает движок PKI для управления сертификатами: выпуск, ротацию, отзыв, настройку TTL и политик сертификатов.

**В health‑api PKI не используется**, потому что:

- Istio обеспечивает встроенный PKI (mTLS) для всех сервисов кластера.  
- Отдельный PKI через Vault создаёт дублирование и усложняет архитектуру.  
- Все сервисные сертификаты автоматически выдаются и ротаются Istio, что полностью покрывает требования безопасности.

## Потоки данных (Data Flow)

1. Приложения или CI/CD аутентифицируются в Vault через auth-метод
2. Запрашивают секреты по ролям
3. Используют секреты (подключение к БД, TLS, API)
4. Аудит и логирование фиксируют доступ

## Интеграции

- **CI/CD (GitHub Actions)** — авторизация и получение секретов в пайплайнах
- **Kubernetes** — секреты внедряются через Vault Agent Injector или External Secrets
- **Приложения** — backend и frontend используют маппинг из Vault (backend-secret-mapping.yaml, frontend-secret-mapping.yaml)
- **Observability** — Prometheus, Grafana, Alertmanager

## Инфраструктурный стек

- Vault Server с HA (можно через StatefulSet)
- Storage backend (файловый или Consul)
- TLS шифрование для связи
- Istio для mTLS между сервисами
- Kyverno/Falco/Trivy для runtime-безопасности

# Расположение конфигураций

- **Helm-чарт:** `helm/vault/` — манифесты Istio, PVC и CronJob для бэкапов
- **Kubernetes ресурсы:** `k8s/` — namespace, serviceaccount, networkpolicy, resourcequota, secret-bootstrap.yaml
- **Конфиги Vault:** `configs/` — vault.hcl, storage.hcl, audit.hcl, telemetry.hcl
- **Политики и роли:** `security/vault/` — auth, policies, roles, secrets
- **Скрипты:** `scripts/` — bootstrap, auth, policies, ops
- **Observability:** `observability/` — prometheus, grafana, alerts

# Пошаговое внедрение

## Подготовка

- Kubernetes кластер доступен
- TLS и Istio настроены
- Prometheus/Grafana подключены
- Vault сервер готов к инициализации

## Этап 1 — Bootstrap Vault

- Скрипты: 
  - `scripts/bootstrap/vault-init.sh`
  - `scripts/bootstrap/vault-unseal.sh`
  - `scripts/bootstrap/enable-kv-engine.sh`
  - `scripts/bootstrap/configure-database-engine.sh`
  - `scripts/bootstrap/setup-transit-engine.sh`

## Этап 2 — Настройка Auth

- Скрипты:
  - `scripts/auth/enable-kubernetes-auth.sh`
  - `scripts/auth/enable-github-oidc.sh`

## Этап 3 — Применение политик

- Скрипт: `scripts/policies/apply-policies.sh`

## Этап 4 — Операции

- Скрипты:
  - `scripts/ops/rotate-secrets.sh`
  - `scripts/ops/rotate-root-token.sh`
  - `scripts/ops/rotate-unseal-keys.sh`
  - `scripts/ops/backup.sh`
  - `scripts/ops/restore.sh`

## Этап 5 — Интеграция с приложениями

- Backend: `integrations/apps/backend-secret-mapping.yaml`
- Frontend: `integrations/apps/frontend-secret-mapping.yaml`
- CI/CD: `integrations/ci/vault-auth-github-actions.sh`
- Kubernetes: `integrations/kubernetes/external-secrets.yaml`, `vault-agent-injector.yaml`

## Этап 6 — Helm и Kubernetes

- Helm: `helm/vault/values.yaml`, `values-dev.yaml`, `templates/` (virtualservice, destinationrule, peerauthentication, backup-cronjob, backup-pvc)
- K8s: `k8s/secret-bootstrap.yaml`, `namespace.yaml`, `serviceaccount.yaml`, `networkpolicy.yaml`, `limitrange.yaml`, `resourcequota.yaml`, `podsecurity.yaml` (если используется)

## Этап 7 — Observability

- Prometheus: `observability/prometheus/servicemonitor.yaml`
- Grafana: `observability/grafana/dashboard.json`
- Alerts: `observability/alerts/vault-alerts.yaml`

## Проверка работоспособности

1. Проверить статус Vault:
```bash
kubectl get pods -n vault
```
2. Проверить инициализацию:
```bash
vault status
```
3. Проверить доступ к секретам через приложения:
```bash
vault read secret/backend/db
```
4. Проверить логи Vault и Prometheus на ошибки  
5. Проверить работу бэкапов и restore скриптов

## Ссылки

* Официальная документация Vault: [https://www.vaultproject.io/docs](https://www.vaultproject.io/docs)
* Helm-чарт Vault: [https://github.com/hashicorp/vault-helm](https://github.com/hashicorp/vault-helm)
* Kubernetes Secrets Best Practices: [https://kubernetes.io/docs/concepts/configuration/secret/](https://kubernetes.io/docs/concepts/configuration/secret/)
