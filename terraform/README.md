# Оглавление

- [О проекте](#о-проекте)  
  - [Преимущества Terragrunt](#преимущества-terragrunt)  
- [Конфигурация terraform/](#конфигурация-terraform)  
  - [Структура](#структура)  
- [Инструкция по запуску](#инструкция-по-запуску)  
  - [Требования](#требования)  
  - [Последовательность действий](#последовательность-действий)  
  - [Запуск через Makefile](#запуск-через-makefile)  
    - [Возможности Makefile](#возможности-makefile)  
    - [Примеры использования](#примеры-использования)  
  - [Когда инфраструктура поднята](#когда-инфраструктура-поднята)  
  - [Возможные проблемы](#возможные-проблемы)  
- [State и Backend (состояние)](#state-и-backend-состояние)  
- [Внедренные DevSecOps практики](#внедренные-devsecops-практики)
  - [Архитектура безопасности](#архитектура-безопасности)
  - [Покрытие](#покрытие)
    - [Базовые проверки](#базовые-проверки)
    - [Линтеры и SAST](#линтеры-и-sast)
    - [Policy-as-Code](#policy-as-code)
    - [Конфигурации и безопасность state](#конфигурации-и-безопасность-state)
    - [CI/CD и инфраструктура](#cicd-и-инфраструктура)
    - [Дрейф инфраструктуры](#дрейф-инфраструктуры)
  - [Результат](#результат)
  - [Запуск проверок](#запуск-проверок)
  - [Соответствие OWASP Top-10](#соответствие-owasp-top-10)

---

# О проекте

Данный проект — реальное IaC-развёртывание инфраструктуры в **Yandex Cloud** для веб-приложения [`health-api`](https://github.com/vikgur/health-api-for-microservice-stack): сеть, виртуальные машины под k3s-кластер и сопутствующие ресурсы. Репозиторий реализован на **Terraform + Terragrunt** с поддержкой [Makefile](#запуск-через-makefile) и [DevSecOps-практиками](#внедренные-devsecops-практики).

![TF](screenshots/yc_mvp_k3s_prod.png)  

**В проекте применён IaC-паттерн «Prod/Stage» через Terragrunt:**

- Общие настройки (backend, провайдер) вынесены в корневой `terragrunt.hcl`.  
- Конфигурации разделены на независимые окружения (**stage** и **prod**), что обеспечивает тестируемость и воспроизводимость.  
- Переменные задаются декларативно в `terragrunt.hcl`, без дублирования кода.  
- Модули (**network**, **vm**) переиспользуются для разных окружений.  
- Все порты воркеров изначально закрыты наружу, обеспечивая безопасность.  

Такой подход отражает боевые практики: тестирование и обкатка изменений на stage перед промоутом в prod.

## Преимущества Terragrunt

Использование Terraform через Terragrunt даёт преимущества продового уровня:

- Централизованное управление модулями и конфигурациями.  
- Исключение дублирования кода.  
- Упрощённая работа с несколькими окружениями (**stage** / **prod**).  
- Автоматическая настройка backend для хранения состояния.  
- Единые команды для запуска и поддержки инфраструктуры.  

---

# Конфигурация terraform/

Директория terraform/ содержит инфраструктурный код для развёртывания окружений **stage** и **prod** в Yandex Cloud с использованием **Terraform** и **Terragrunt**.  
Структура организована по принципу модульности и разделения окружений.

## Структура

- **modules/** — каталог с переиспользуемыми Terraform-модулями.  
  - **network/** — модуль для создания VPC, подсетей и сетевых ресурсов.  
    - `main.tf` — описание ресурсов сети.  
    - `outputs.tf` — экспортируемые значения (ID сети, подсети и пр.).  
    - `variables.tf` — входные переменные модуля.  
  - **vm/** — модуль для создания виртуальных машин.  
    - `main.tf` — описание ресурсов ВМ (инстансы, диски, сети).  
    - `outputs.tf` — экспортируемые значения (IP-адреса, ID ВМ).  
    - `variables.tf` — входные переменные модуля.  

- **terragrunt.hcl** — корневой конфиг Terragrunt: настройки backend для хранения состояния и общий провайдер Yandex Cloud.  

- **live/** — окружения (stage и prod), управляемые через Terragrunt.  
  - **stage/** — окружение для тестов и отработки релизов.  
    - `terragrunt.hcl` — параметры окружения (cloud_id, folder_id, zone и пр.).  
    - **network/terragrunt.hcl** — вызов модуля `network` для stage.  
    - **vm/terragrunt.hcl** — вызов модуля `vm` для stage.  
  - **prod/** — окружение для production.  
    - `terragrunt.hcl` — параметры окружения (cloud_id, folder_id, zone и пр.).  
    - **network/terragrunt.hcl** — вызов модуля `network` для prod.  
    - **vm/terragrunt.hcl** — вызов модуля `vm` для prod. 

---

# Инструкция по запуску

Инструкция дана для **linux\_amd64 (Ubuntu)**.

## Требования

* Установлен **Terragrunt** и **Terraform**.
* `yc` CLI настроен (`yc init`), получены `yc_token`, `cloud_id`, `folder_id`.
* Создан бакет в Yandex Object Storage с включённым **Versioning** и **SSE-KMS**.
* В `.env` заданы ключи доступа к Object Storage (не коммитятся в git).

Пример `.env`:

```bash
AWS_ACCESS_KEY_ID=yc_access_key
AWS_SECRET_ACCESS_KEY=yc_secret_key
AWS_DEFAULT_REGION=ru-central1
```

## Последовательность действий

1. Перейти в нужное окружение и сервис:

   ```bash
   cd live/<stage|prod>/<network|vm>
   ```

2. Инициализация backend и провайдера:

   ```bash
   terragrunt init
   ```

3. Просмотр плана:

   ```bash
   terragrunt plan
   ```

4. Применение конфигурации:

   ```bash
   terragrunt apply -auto-approve
   ```

5. Проверка outputs:

   ```bash
   terragrunt output
   ```

6. Форматирование и валидация без применения:

   ```bash
   terragrunt run-all plan
   ```

7. Если инфраструктура ранее создавалась без remote backend и требуется перенос:

   ```bash
   terragrunt init -migrate-state
   ```

   Для новых проектов этот шаг не нужен — state сразу хранится в Object Storage.

## Запуск через Makefile

Для удобства можно использовать `make`.

Для упрощения работы с Terragrunt добавлен `Makefile`.
Он позволяет управлять окружениями (**stage**, **prod**) и сервисами (**network**, **vm**) через единые команды.

### Возможности Makefile

* `init` — инициализация Terraform backend для выбранного окружения и сервиса.
* `plan` — просмотр плана изменений.
* `apply` — применение конфигурации.
* `destroy` — удаление ресурсов.
* `output` — вывод экспортируемых значений.

Дополнительно есть алиасы для запуска сразу всех сервисов окружения:

* `apply-stage`, `apply-prod` — применить конфигурацию для network + vm.
* `destroy-stage`, `destroy-prod` — удалить ресурсы в правильном порядке (сначала vm, потом network).

### Примеры использования

Инициализация `stage/network`:

```bash
make init ENV=stage SERVICE=network
```

План для `prod/vm`:

```bash
make plan ENV=prod SERVICE=vm
```

Применить все ресурсы в stage:

```bash
make apply-stage
```

Удалить все ресурсы в prod:

```bash
make destroy-prod
```
---

## Когда инфраструктура поднята

**Можно:**

* Вносить изменения только через Terragrunt (`plan` → `apply`).  
* Редактировать модули и `terragrunt.hcl`, применяя миграции через Terragrunt.  
* Использовать `terragrunt plan` для проверки изменений и обнаружения drift.  
* Смотреть `terragrunt output` и использовать outputs в Ansible/CI/CD.  

**Нельзя:**

* Вручную изменять ресурсы в облаке через консоль или `yc` CLI.  
* Коммитить состояние (`.terraform/`, `.terragrunt-cache/`, `terraform.tfstate`) и `.env` в репозиторий.  
* Запускать несколько `terragrunt apply` параллельно без блокировок remote state.  

## Возможные проблемы

* **Нестабильный init** — при проблемах с доступом к `registry.terraform.io` использовать VPN или вручную скачать провайдер YC и положить в `~/.terraform.d/plugins/...`.
* **IPv6** — может ломать DNS/API. Временный фикс:

  ```bash
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  terraform init
  ```

  После завершения — вернуть обратно (`disable_ipv6=0`).
* **DNS** — если `registry.terraform.io` не пингуется, сменить DNS, например:

  ```bash
  echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
  ```

---

# State и Backend (состояние)

**State** — это файл, где Terraform хранит текущее описание созданных ресурсов (ID ВМ, IP, сети и т.п.). Без state невозможно понять, что уже развернуто и какие изменения требуются.  

**Backend** — механизм хранения state. Локальный backend (в `.terraform/`) небезопасен и неудобен для командной работы.  
Best practice — хранить state в централизованном и защищённом хранилище.

В данном проекте backend настроен через **Terragrunt** на Yandex Object Storage (S3-совместимый) с включённым **Versioning** и **SSE-KMS**, что обеспечивает:  

- сохранность state (всегда есть версии);  
- защиту (шифрование);  
- совместную работу команды без конфликтов.  

Ключи доступа к Object Storage берутся из файла `.env`, который не попадает в репозиторий.  

---

# Внедренные DevSecOps практики

## Архитектура безопасности

- **policy/terraform/security.rego** — правила OPA/Conftest (запрет `0.0.0.0/0`, публичных бакетов, без-KMS, требование тегов).
- **devsecops_scripts/plan_json.sh** — генерация `terragrunt plan` в JSON и прогон через политики.
- **.checkov.yaml** — конфиг Checkov (сканер IaC).
- **.env** — ключи для Object Storage backend (в `.gitignore`, не попадают в Git).
- **.gitignore** — исключает state, tfvars, секреты, `.env`.
- **.gitleaks.toml** — правила поиска секретов в коде.
- **.pre-commit-config.yaml** — хуки линтеров и сканеров (fmt, validate, tflint, checkov, gitleaks, yamllint).
- **.tflint.hcl** — настройки TFLint (Terraform линтер).
- **.yamllint.yaml** — правила стиля и синтаксиса YAML (CI/Helm/Ansible).
- **Makefile** — цель `lint-security` для запуска всех DevSecOps-проверок одной командой.

## Покрытие

### Базовые проверки
- **terragrunt hclfmt / terraform validate** — единый стиль и синтаксическая валидация.  
→ принцип *Secure SDLC*: раннее выявление ошибок.

### Линтеры и SAST
- **TFLint** — ошибки провайдера, best practices.  
- **Checkov** — анализ IaC на misconfig (открытые порты, отсутствие шифрования, публичные бакеты).  
- **Gitleaks** — поиск секретов.  
→ соответствие *OWASP IaC Security* и *CIS Benchmarks*: запрет небезопасных конфигов, отсутствие hardcoded secrets.

### Policy-as-Code
- **OPA/Conftest** на `terragrunt plan`:  
  - запрет `0.0.0.0/0` в SG,  
  - требование KMS-шифрования,  
  - обязательные теги (Owner/Env/CostCenter).  
→ *OWASP Top-10*:  
  - A5 Security Misconfiguration,  
  - A4 Insecure Design (правила на архитектуру).  

### Конфигурации и безопасность state
- **Backend в Yandex Object Storage** (S3-совместимый) с **Versioning** и **SSE-KMS**.  
- **.env + .gitignore** — секреты только в окружении, state и tfvars вне Git.  
→ *OWASP A2 Cryptographic Failures*: защита state.  
→ *OWASP A3 Injection*: исключение секретов из кода.  

### CI/CD и инфраструктура
- **Yamllint** — проверка YAML.  
- **Разделение stage/prod** через Terragrunt — тестирование на идентичных окружениях, без вмешательства в прод.  
- **Сетевые принципы** — воркеры без публичных IP, доступ к мастеру через SSH.  
→ *OWASP A1 Broken Access Control*: минимум внешних точек входа.  
→ *OWASP A5 Security Misconfiguration*: deny by default.  

### Дрейф инфраструктуры
- Проверки `terragrunt plan -detailed-exitcode` для выявления расхождений между кодом и реальными ресурсами.  
→ принцип *Continuous Compliance*.  

---

## Результат

- Внедрены ключевые DevSecOps-практики для Terraform/Terragrunt: SAST, Policy-as-Code, секрет-сканирование, контроль state и дрейфа.  
- Обеспечена защита от основных категорий OWASP Top-10 (*Security Misconfiguration, Insecure Design, Cryptographic Failures, Broken Access Control, Secrets Management*).  
- Инфраструктура управляется декларативно, тестируемо и безопасно, без ручных изменений в проде.

---

## Запуск проверок

Все проверки объединены в команду:

```bash
make lint-security
```

Команда выполняет полный набор DevSecOps-проверок:

* форматирование и валидация Terraform,
* линтинг через **TFLint**,
* анализ IaC на misconfig через **Checkov**,
* поиск секретов через **Gitleaks**,
* проверку YAML через **Yamllint**,
* генерацию `plan.json` и валидацию политик через **Conftest**.

---

## Соответствие OWASP Top-10

Краткий маппинг практик проекта на OWASP Top-10:

- **A1 Broken Access Control** → сетевой паттерн: воркеры без публичных IP, доступ к мастеру только через SSH.  
- **A2 Cryptographic Failures** → backend в Yandex Object Storage с SSE-KMS и versioning, секреты в `.env` (вне Git).  
- **A3 Injection** → исключение секретов из кода, tfvars и state не хранятся в Git, поиск утечек через Gitleaks.  
- **A4 Insecure Design** → OPA/Conftest-политики на `terragrunt plan` (обязательные теги, KMS, запрет 0.0.0.0/0).  
- **A5 Security Misconfiguration** → Checkov и TFLint: запрет небезопасных ресурсов (открытые порты, публичные бакеты).  
- **A6 Vulnerable and Outdated Components** → TFLint и Checkov выявляют устаревшие/неподдерживаемые ресурсы и провайдеры.  
- **A7 Identification and Authentication Failures** → управление доступом через Object Storage backend с версионированием, секреты только в Vault/.env.  
- **A8 Software and Data Integrity Failures** → CI прогоняет terraform validate/plan, drift detection, Conftest правила.  
- **A9 Security Logging and Monitoring Failures** → планирование и фиксация `terragrunt plan` в CI, контроль дрейфа через detailed-exitcode.  
- **A10 SSRF** → использование только доверенных провайдеров Terraform, ограничение внешних источников данных.  
