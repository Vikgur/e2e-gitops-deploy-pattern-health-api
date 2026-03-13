# Оглавление

- [Общий обзор](#общий-обзор)  
- [Компоненты системы](#компоненты-системы)  
  - [Vault Core](#vault-core)  
  - [Engines](#engines)  
  - [Auth Methods](#auth-methods)  
  - [Policies & Roles](#policies--roles)  
  - [Integrations](#integrations)  
- [Data Flow](#data-flow)  
- [High-Level Diagram](#high-level-diagram)  
- [Принципы безопасности](#принципы-безопасности)  
- [Документация по компонентам](#документация-по-компонентам)

---

# Архитектура Vault в проекте health-api

## Общий обзор

Vault отвечает за централизованное безопасное хранение и управление секретами в проекте **health-api**.  
Архитектура построена по принципу «секреты как сервис» с интеграцией в CI/CD и Kubernetes.

**Основные функции:**
- Управление секретами (KV, Database, TLS, API Keys)
- Динамическое создание учётных данных для БД и сервисов
- Шифрование/расшифровка данных через Transit Engine
- Интеграция с Identity Provider (Keycloak) для RBAC
- Мониторинг и аудит доступа к секретам

## Компоненты системы

### Vault Core
- **Server** — хранит секреты, управляет токенами, ротацией ключей
- **Storage Backend** — PostgreSQL/Consul/raft для сохранения состояния
- **Audit Backend** — логирует доступы и операции
- **Telemetry** — собирает метрики для Prometheus

### Engines
- **KV v2** — хранение конфигураций и статических секретов
- **Database Engine** — динамическая генерация учётных данных для БД
- **Transit Engine** — шифрование и подпись данных, ключи не покидают Vault

### Auth Methods
- **Kubernetes** — выдача токенов сервисам внутри кластера
- **GitHub OIDC** — выдача токенов для CI/CD пайплайнов
- **Root / Recovery** — для аварийного доступа и восстановления

### Policies & Roles
- **Policies** — HCL правила доступа (`vault-admin.hcl`, `vault-app.hcl`, `vault-ci.hcl`)
- **Roles** — связка Auth Method + Policy (`backend-role.hcl`, `frontend-role.hcl`, `ci-role.hcl`)

### Integrations
- **CI/CD** — GitHub Actions, автоподнятие токенов, ротация секретов
- **Kubernetes** — External Secrets, Vault Agent Injector
- **Applications** — backend, frontend получают секреты через environment variables или mounted volumes

## Data Flow

```text
[CI/CD / Developer] ---> [Auth Method: GitHub / K8s] ---> [Vault] ---> [Secret Engines] ---> [Application / DB]
````

**Пример:**

1. CI/CD запрашивает токен через GitHub OIDC
2. Vault проверяет роль и выдаёт токен с TTL
3. Приложение использует токен для чтения секретов из KV или Database Engine
4. Secrets монтируются через Env или CSI Driver
5. Все операции логируются в Audit Backend

## High-Level Diagram

```text
            +-----------------+
            |  CI/CD / Dev    |
            +-----------------+
                     |
                     v
           +------------------+
           |  Auth Methods    |
           | K8s / GitHub OIDC|
           +------------------+
                     |
                     v
           +------------------+
           |      Vault       |
           |-----------------|
           | KV | Database   |
           | Transit Engine |
           | Policies/Roles |
           +-----------------+
              |          |
              v          v
      +------------+  +-----------+
      |  Backend   |  |  Frontend |
      +------------+  +-----------+
              |
              v
         +---------+
         |  DB     |
         +---------+
```

## Принципы безопасности

* Секреты не хранятся в Git
* Ротация ключей и токенов через скрипты ops/
* Минимальные права доступа через Policies & Roles
* Все действия логируются в Audit Backend
* TLS для всех соединений
* Контейнеры работают без root (PSA/Kyverno)

## Документация по компонентам

* `docs/engines/kv-v2.md` — KV Engine
* `docs/engines/database-engine.md` — Database Engine
* `docs/engines/transit-engine.md` — Transit Engine
* `security/vault/policies/` — Policies HCL
* `security/vault/roles/` — Roles HCL
* `scripts/bootstrap/` — скрипты инициализации Vault
