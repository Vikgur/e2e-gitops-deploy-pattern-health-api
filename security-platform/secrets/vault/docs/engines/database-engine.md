# Оглавление

* [Описание движка Database](#описание-движка-database)
* [Основные возможности](#основные-возможности)
* [Пример конфигурации](#пример-конфигурации)
* [Использование в пайплайнах](#использование-в-пайплайнах)
* [Рекомендации по безопасности](#рекомендации-по-безопасности)

---

## Описание движка Database

**Database Engine** в Vault предназначен для динамического управления учётными данными баз данных. Он позволяет создавать временные пользователи с ограниченными правами, автоматически выдавать и отзывать креденшелы.

* Поддержка популярных СУБД: PostgreSQL, MySQL, MongoDB и др.
* Динамическое создание пользователей и паролей для приложений
* Управление ротацией и сроком действия секретов

---

## Основные возможности

* **Динамическая генерация учётных данных**: каждая интеграция получает уникальный пользователь.
* **Автоматическая ротация**: Vault может автоматически менять пароли через заданный TTL.
* **Политики доступа**: разграничение прав на создание/чтение/отзыв секретов.
* **Audit Logging**: запись всех операций для контроля и аудита.

---

## Пример конфигурации

```bash id="c4km59"
# configure-database-engine.sh
vault secrets enable database

vault write database/config/postgres \
    plugin_name=postgresql-database-plugin \
    allowed_roles="backend,frontend" \
    connection_url="postgresql://{{username}}:{{password}}@db.example.com:5432/health_api?sslmode=disable" \
    username="vaultadmin" \
    password="VaultStrongPass!"

# Пример роли для backend
vault write database/roles/backend \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
```

---

## Использование в пайплайнах

* Получение динамического пользователя:

```bash id="1l5fnx"
vault read database/creds/backend
```

* Выдача временного пароля для приложения:

```json id="q2v0kl"
{
  "username": "vlt-user-abc123",
  "password": "XyZ!234$",
  "lease_id": "database/creds/backend/123456",
  "lease_duration": 3600,
  "renewable": true
}
```

* Ротация секрета:

```bash id="8u3vzt"
vault lease renew database/creds/backend/123456
```

---

## Рекомендации по безопасности

* Использовать минимально необходимые привилегии в SQL.
* Настроить TTL для всех динамических секретов.
* Включить audit logging для отслеживания всех операций.
* Использовать безопасное подключение (TLS) к базе.
