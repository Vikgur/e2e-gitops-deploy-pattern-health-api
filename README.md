# Оглавление

- [Цель и масштаб проекта](#цель-и-масштаб-проекта)
- [Архитектура платформы и стек](#архитектура-платформы-и-стек)
- [DevSecOps в SDLC](#devsecops-в-sdlc)
  - [CI/CD архитектура](#cicd-архитектура)
  - [Контроль качества кода](#контроль-качества-кода)
  - [Security-проверки в CI](#security-проверки-в-ci)
    - [Секреты / Утечки (Gitleaks)](#секреты--утечки-gitleaks)
    - [SAST (SonarQube, Semgrep)](#sast-sonarqube-semgrep)
    - [SCA зависимостей кода (OWASP Dependency-Check)](#sca-зависимостей-кода-owasp-dependency-check)
    - [Файловая безопасность (Trivy FS)](#файловая-безопасность-trivy-fs)
    - [Container security (Hadolint)](#container-security-hadolint)
    - [IaC security (Checkov)](#iac-security-checkov)
    - [Kubernetes манифесты (Polaris, Kubeconform)](#kubernetes-манифесты-polaris-kubeconform)
    - [Policy-as-Code (Open Policy Agent / Conftest)](#policy-as-code-open-policy-agent--conftest)
    - [DAST (OWASP ZAP)](#dast-owasp-zap)
    - [Fuzzing (ffuf)](#fuzzing-ffuf)
- [Software и Supply Chain Security](#software-и-supply-chain-security)
  - [Мониторинг зависимостей (Dependabot)](#мониторинг-зависимостей-dependabot)
  - [SBOM генерация и анализ (Syft, Grype)](#sbom-генерация-и-анализ-syft-grype)
  - [Проверка лицензий (ScanCode Toolkit)](#проверка-лицензий-scancode-toolkit)
  - [SCA образов (Trivy Image)](#sca-образов-trivy-image)
  - [Подпись и контроль артефактов (Cosign)](#подпись-и-контроль-артефактов-cosign)
  - [Закрытые артефактории (GHCR, Harbor, Nexus)](#закрытые-артефактории-ghcr-harbor-nexus)
- [Platform Security](#platform-security)
  - [Identity и Secrets](#identity-и-secrets)
    - [Secrets, PKI (HashiCorp Vault)](#secrets-pki-hashicorp-vault)
    - [IaM, OIDC/OAuth2 (Keycloak)](#iam-oidcoauth2-keycloak)
  - [Kubernetes Security](#kubernetes-security)
    - [Cluster security (RBAC, NetworkPolicies, SecurityContext)](#cluster-security-rbac-networkpolicies-securitycontext)
    - [Admission controller (Kyverno)](#admission-controller-kyverno)
    - [Runtime security (Falco, Trivy)](#runtime-security-falco-trivy)
    - [East-West mTLS (Istio)](#east-west-mtls-istio)
    - [CIS Benchmark (kube-bench)](#cis-benchmark-kube-bench)
- [Управление уязвимостями и ASOC](#управление-уязвимостями-и-asoc)
  - [ASOC (DefectDojo)](#asoc-defectdojo)
  - [AppSec процессы](#appsec-процессы)
    - [Триаж](#триаж)
    - [Обработка False positive](#обработка-false-positive)
    - [Принятие рисков](#принятие-рисков)
- [Моделирование угроз](#моделирование-угроз)
  - [Методология (STRIDE)](#методология-stride)
  - [Домены риска](#домены-риска)
  - [OWASP Top-10:2025 маппинг](#owasp-top-102025-маппинг)
  - [CWE Top-25 маппинг](#cwe-top-25-маппинг)
- [Регуляторные требования и стандарты](#регуляторные-требования-и-стандарты)
  - [Российские регуляторы](#российские-регуляторы)
    - [ФСТЭК](#фстэк)
    - [ФЗ-187](#фз187)
    - [ФЗ-152](#фз152)
    - [ФСБ](#фсб)
  - [Российские стандарты](#российские-стандарты)
    - [ГОСТ Р 56939-2024](#гост-р-56939-2024)
    - [ГОСТ Р 56938-2016](#гост-р-56938-2016)
    - [ГОСТ Р 58833-2020](#гост-р-58833-2020)
    - [ГОСТ Р 594531-2021](#гост-р-594531-2021)
    - [ГОСТ Р 594532-2021](#гост-р-594532-2021)
    - [ГОСТ Р 59547-2021](#гост-р-59547-2021)
  - [Международные стандарты](#международные-стандарты)
    - [ISO/IEC 27001:2022](#isoiec-270012022)
    - [ISO/IEC 27002:2022](#isoiec-270022022)
    - [ISO/IEC 27005:2022](#isoiec-270052022)
  - [Международные фреймворки](#международные-фреймворки)
    - [OWASP SAMM / BSIMM](#owasp-samm--bsimm)
    - [NIST SSDF / CSF](#nist-ssdf--csf)

---

# Цель и масштаб проекта

## Назначение 

Демонстрация production-grade DevSecOps платформы с полной интеграцией AppSec-практик в жизненный цикл разработки.

Проект моделирует реальную корпоративную среду, в которой безопасность встроена во все этапы доставки программного обеспечения — от разработки до эксплуатации.

Архитектура ориентирована на аудит безопасности и демонстрацию зрелости DevSecOps-процессов.

## Класс решаемых задач

- построение **Secure SDLC**
- автоматизация **security-контролей в CI/CD**
- контроль **software supply chain**
- защита **cloud-native инфраструктуры**
- централизованное управление **уязвимостями**

## Демонстрируемые DevSecOps-подходы

- security-by-design архитектура  
- shift-left безопасность  
- shift-right безопасность  
- security-gates в CI/CD  
- policy-as-code  
- software supply chain security  
- continuous vulnerability management  

## Покрытие

Проект демонстрирует полный цикл DevSecOps-практик:

- **Secure SDLC** — контроль безопасности на всех этапах разработки  
- **DevSecOps platform** — централизованная платформа security-контролей  
- **Cloud-native security** — защита Kubernetes-среды  
- **Production-grade архитектура** — инфраструктура и процессы уровня enterprise

---

# Архитектура платформы и стек

Проект построен как production-подобная платформа, включающая прикладной слой, инфраструктуру доставки, систему наблюдаемости и инструменты безопасности.

## Application слой

Демонстрационное приложение используется как объект для тестирования DevSecOps-процессов.

- **Python Flask backend**  
- **React frontend**  
- **Pytest test suite**

Приложение содержит API-эндпоинты, интеграции с БД и брокером сообщений, что позволяет проверять различные классы security-сканирования.

## Platform слой

Контейнерная и оркестрационная платформа доставки.

- **Docker** — контейнеризация приложений  
- **Kubernetes (k3s)** — оркестрация кластера  
- **Helm / Helmfile** — управление релизами  
- **GitOps delivery** — Argo CD (App-of-Apps модель)

Все изменения инфраструктуры и приложений проходят через GitOps-процессы.

## Infrastructure as Code

Инфраструктура полностью управляется через код.

- **Terraform** — provisioning инфраструктуры  
- **Terragrunt** — управление Terraform-модулями  
- **Ansible** — конфигурация серверов и bootstrap кластера

Это позволяет воспроизводимо разворачивать окружения и проводить security-аудит инфраструктуры.

## Observability

Стек наблюдаемости используется как для эксплуатации, так и для security-анализа.

- **Prometheus** — сбор метрик  
- **Grafana** — визуализация  
- **Jaeger** — distributed tracing  
- **OpenTelemetry** — инструментирование сервисов

Наблюдаемость используется для анализа поведения приложений и диагностики инцидентов.

## Локальная prod-like среда

Для разработки, тестирования запуска security-сканирований используется локальная среда, максимально приближенная к production.

Docker Compose разворачивает полноценную сервисную платформу.

**Состав среды (18 контейнеров):**

- backend
- frontend
- брокеры Kafka/Zookeeper
- PostgreSQL + PgBouncer
- observability (Prometheus, VictoriaMetrics, Grafana, Jaeger, Alertmanager)
- экспортёры.

---

# DevSecOps в SDLC

Безопасность встроена в жизненный цикл разработки и реализована через автоматизированные security-контроли в CI/CD.

Подход основан на принципах **Shift-Left / Shift-Right Security**, **Security Gates** и **Secure SDLC**.

Все изменения кода, инфраструктуры и конфигураций проходят через многоуровневую систему автоматических проверок.


## CI/CD архитектура

Доставка построена на GitHub Actions с разделением пайплайнов по зонам ответственности.

### CI pipelines

Используются для проверки изменений перед merge.

- **Application CI** — линтинг, сборка, unit-тесты, api тесты и security-сканирование backend/frontend  
- **Infrastructure CI** — линтинг, security-сканирование Terraform, Ansible и Helm  
- **Tests CI** — линтинг, security-сканирование, интеграционные и E2E-UI тесты 

Каждый pipeline реализует набор контролируемых **security gates**, при необходимости блокирующих небезопасные изменения.

### Deploy pipelines

Пайплайны доставки управляют развертыванием инфраструктуры и приложений.

- **Application deploy** — доставка приложений через GitOps  
- **Terraform deploy** — управление облачной инфраструктурой  
- **Ansible deploy** — конфигурация серверов и bootstrap окружений  
- **Helm deploy** — управление релизами Kubernetes

Развертывание производится вручную только после прохождения всех security-проверок.

### Итоговая цепочка джоб

#### ci-app-backend.yml

Job 1: Backend Code Quality (Flake8, Black, Isort, Mypy)  
Job 2: API Tests Code Quality (Flake8, Black, Isort, Mypy)  
Job 3: Unit Tests (Pytest)  
Job 4: Secrets (Gitleaks)  
Job 5: SAST (SonarQube, Semgrep)  
Job 6: SCA (OWASP Dependency‑Check)  
Job 7: SBOM кода: генерация и проверка (Syft, Grype)  
Job 8: Repo Security (Trivy FS)  
Job 9: Dockerfile Security (Hadolint)  
Job 10: API Tests Security (Gitleaks, Semgrep, OWASP Dependency‑Check, Syft)  
Job 11: Build Image  
Job 12: API Tests & Runtime Security   
- Развёртывание тестового окружения (docker‑compose/k8s namespace)  
- Запуск api тестов (Pytest, `tests/api/`)  
- OWASP ZAP baseline scan  

Job 13: URL fuzzing (FFuf)  
Job 14: SCA (Trivy Image)  
Job 15: SBOM образа: генерация и проверка (Syft, Grype)  
Job 16: Лицензии (Scancode‑Toolkit)  
Job 17: Тегирование образа (sha-tag)  
Job 18: Подпись образа OIDC/Keyless (Cosign)  
Job 19: Push Image (в GHCR)

#### ci-app-frontend.yml

Job 1: Code Quality (ESLint, Prettier)  
Job 2: Unit Tests (npm test)  
Job 3: Secrets (Gitleaks)  
Job 4: SAST (Semgrep)  
Job 5: SCA (OWASP Dependency‑Check)  
Job 6: SBOM кода: генерация и проверка (Syft, Grype)  
Job 7: Repo Security (Trivy FS)  
Job 8: Dockerfile Security (Hadolint)  
Job 9: Build Image (npm build + Docker build)  
Job 10: Image Security (Trivy image)  
Job 11: SBOM образа: генерация и проверка (Syft, Grype)  
Job 12: Лицензии (Scancode‑toolkit)  
Job 13: Тегирование образа (sha-tag)  
Job 14: Подпись образа OIDC/Keyless (Cosign)  
Job 15: Push Image (в GHCR)

#### ci-infra-ansible.yml

Job 1: Code Quality (Yamllint, Ansible‑Lint, Shellcheck)  
Job 2: Secrets (Gitleaks)  
Job 3: Repo Security (Trivy FS)  
Job 4: SAST / Misconfiguration (Semgrep)  
Job 5: IaC Security (Checkov)  
Job 6: Policy‑as‑Code (OPA / Conftest / Rego)  
Job 7: SBOM кода (Syft)  
Job 8: SBOM анализ (Grype)  
Job 9: Лицензии (ScanCode Toolkit)

#### ci-infra-helm.yml

Job 1: Code Quality (Yamllint, Helm Lint, Helmfile Lint)  
Job 2: Secrets (Gitleaks)  
Job 3: Repo Security (Trivy FS)  
Job 4: Kubernetes Schema Validation (Kubeconform)  
Job 5: Kubernetes Best Practices (Polaris)  
Job 6: IaC Security (Checkov)  
Job 7: Policy‑as‑Code (OPA / Conftest / Rego)  
Job 8: SBOM кода (Syft)  
Job 9: SBOM анализ (Grype)  
Job 10: Лицензии (ScanCode Toolkit)

#### ci-infra-terraform.yml

Job 1: Code Quality (Fmt, Validate, TFLint)  
Job 2: Secrets (Gitleaks)  
Job 3: Repo Security (Trivy FS)  
Job 4: IaC Security (Checkov)  
Job 5: Policy‑as‑Code (OPA / Conftest / Rego)  
Job 6: SBOM кода (Syft)  
Job 7: SBOM анализ (Grype)  
Job 8: Лицензии (ScanCode Toolkit)

#### ci-tests-integration.yml

Job 1: Code Quality (Flake8, Black, Isort, Mypy)  
Job 2: Secrets (Gitleaks)  
Job 3: SAST Tests Code (Semgrep)  
Job 4: Repo Security (Trivy FS)  
Job 5: Pull Backend and Frontend Images  
Job 6: Deploy and Test Stack (Integration Tests + Runtime Security)  
- Развёртывание тестового окружения (docker‑compose/k8s namespace)  
- Запуск интеграционных тестов (Pytest, `tests/integration/`)  
- OWASP ZAP baseline scan  
Job 7: URL Fuzzing (FFuf)

#### ci-tests-e2e-ui.yml

Job 1: Code Quality (Flake8, Black, Isort, Mypy)  
Job 2: Secrets (Gitleaks)  
Job 3: SAST Tests Code (Semgrep)  
Job 4: Repo Security (Trivy FS)  
Job 5: Pull Backend and Frontend Images  
Job 6: Deploy and Test Stack (E2E UI + DAST)  
- Развёртывание тестового окружения (staging)  
- Запуск E2E UI‑тестов (Selenium, `tests/e2e-ui/`)  
- OWASP ZAP full scan  

Job 7: URL Fuzzing (FFuf)

#### deploy‑app.yml

Job 1: Release Approval (Manual Trigger)  
- Ручное подтверждение запуска деплоя  
- Требует одобрения от ответственного лица  

Job 2: Verify Images (Cosign)  
- Проверка подписей образов: `cosign verify backend-image` и `frontend-image`  
- Валидация OIDC‑подписей  
- Отказ при отсутствии валидной подписи  

Job 3: Update GitOps Repo  
- Обновление тегов образов в `values.yaml` (Helm)  
- Создание PR в репозиторий `gitops-apps` с изменениями  
- Добавление метаданных релиза (версия, коммит)  

Job 4: Merge Release PR  
- Автоматическое слияние PR после одобрения  
- Триггер для ArgoCD  
- Логирование изменений  

Job 5: ArgoCD Sync Verification  
- Ожидание завершения синхронизации в ArgoCD  
- Проверка статуса всех ресурсов (Pods, Services, Ingress)  
- Таймаут: 10 мин  
- Отправка уведомления при успехе/ошибке

#### deploy‑infra‑terraform.yml

Job 1: Release Approval (Manual Trigger)  
- Ручной запуск пайплайна  
- Обязательное одобрение (например, через GitHub Actions approval)  

Job 2: Terraform Plan  
- `terraform init`  
- `terraform plan -out=tfplan`  
- Вывод изменений (что будет создано/изменено/удалено)  
- Сохранение плана как артефакт  

Job 3: Terraform Apply (Manual Approval)  
- Запрос ручного подтверждения перед применением  
- `terraform apply tfplan`  
- Логирование выполненных действий  
- Обработка ошибок (откат при сбое)  

Job 4: ArgoCD / Infra Verification  
- Проверка статуса ресурсов через `kubectl get all -A`  
- Валидация работоспособности ключевых сервисов  
- Опционально: запуск health‑check‑скриптов  
- Уведомление о завершении  

#### deploy‑infra‑ansible.yml

Job 1: Release Approval (Manual Trigger)  
- Ручная активация пайплайна  
- Контроль доступа (только уполномоченные пользователи)  

Job 2: Dry Run (Ansible Check)  
- `ansible-playbook --check playbook.yml`  
- Имитация выполнения без изменений  
- Выявление потенциальных ошибок  
- Сохранение вывода для анализа  

Job 3: Apply Configuration  
- `ansible-playbook playbook.yml`  
- Последовательное применение конфигураций  
- Роллинг‑апдейты (если требуется)  
- Логирование всех действий  

Job 4: Infra Verification  
- Проверка состояния серверов (`uptime`, `load`)  
- Тестирование доступности сервисов (HTTP‑чеки, порты)  
- Сбор метрик (CPU, RAM, диск)  
- Отчёт о статусе деплоя  

#### deploy‑infra‑helm.yml

Job 1: Release Approval (Manual Trigger)  
- Ручной старт пайплайна  
- Требует подтверждения (например, через workflow_dispatch)  

Job 2: Update GitOps Repo  
- Изменение `values.yaml` или манифестов Helm  
- Обновление версии чарта (если нужно)  
- Создание PR с описанием изменений  
- Прикрепление ссылок на документацию  

Job 3: Merge PR  
- Автоматическое слияние после одобрения  
- Запуск CI/CD‑пайплайна в GitOps‑репозитории  
- Запись версии релиза в changelog  

Job 4: ArgoCD Sync Verification  
- Мониторинг синхронизации в ArgoCD  
- Проверка статусов Helm‑релизов  
- Валидация Pods/Deployments  
- Оповещение о результате (Slack/Email)

## Контроль качества кода

Перед запуском security-сканирований код проходит обязательные проверки качества.

Контроль качества реализован через линтеры и статический анализ.

### Application code

**Python**

- Flake8 — анализ стиля и потенциальных ошибок  
- Black — стандартизированное форматирование  
- Isort — управление импортами  
- MyPy — статическая типизация

**Frontend**

- ESLint — анализ JavaScript/TypeScript  
- Prettier — единый стиль форматирования

### Scripts и конфигурации

- Shellcheck — проверка shell-скриптов  
- Dotenv-linter — контроль .env конфигураций  
- Yamllint — валидация YAML

### Infrastructure as Code

Контроль качества инфраструктурного кода.

- Terraform fmt  
- Terraform validate  
- TFLint  
- Ansible-lint  
- Helm lint  
- Helmfile lint

Такая проверка предотвращает ошибки конфигурации до запуска security-сканирований.


## Security-проверки в CI

В CI реализована система автоматизированных **security-гейтов**, при необходимости блокирующих небезопасный код, зависимости и инфраструктурные конфигурации.

Каждый инструмент закрывает отдельный класс угроз.


### Секреты / Утечки (Gitleaks)

Проверка репозитория на наличие секретов и чувствительных данных.

Gitleaks используется для обнаружения:

- API-ключей  
- токенов доступа  
- приватных ключей  
- паролей и credentials

Сканирование выполняется на каждом Pull Request и блокирует утечку секретов в репозиторий.


### SAST (SonarQube, Semgrep)

Статический анализ безопасности исходного кода.

Используются два уровня анализа:

**Semgrep**

- быстрый security-анализ  
- правила OWASP Top-10  
- кастомные политики безопасности

**SonarQube**

- глубокий анализ качества и безопасности кода  
- контроль technical debt  
- централизованные quality gates

Комбинация инструментов обеспечивает баланс между скоростью и глубиной анализа.


### SCA зависимостей кода (OWASP Dependency-Check)

Анализ уязвимостей в сторонних зависимостях.

OWASP Dependency-Check сопоставляет используемые библиотеки с базами уязвимостей:

- NVD  
- CVE  
- OSS Index

Security-гейт блокирует использование зависимостей с критическими уязвимостями.


### Файловая безопасность (Trivy FS)

Сканирование репозитория на наличие уязвимостей и misconfiguration.

Trivy FS анализирует:

- зависимости проекта  
- конфигурационные файлы  
- Dockerfile  
- инфраструктурные манифесты

Инструмент используется как дополнительный уровень проверки репозитория.


### Container security (Hadolint)

Статический анализ Dockerfile.

Hadolint выявляет:

- небезопасные инструкции Dockerfile  
- неправильные базовые образы  
- нарушения best-practice контейнеризации

Это снижает риск уязвимых или небезопасных контейнерных образов.


### IaC security (Checkov)

Анализ безопасности инфраструктурного кода.

Checkov проверяет Terraform и Kubernetes-конфигурации на соответствие security-policy:

- неправильные сетевые правила  
- небезопасные IAM-настройки  
- misconfiguration облачных ресурсов


### Kubernetes манифесты (Polaris, Kubeconform)

Контроль корректности и безопасности Kubernetes-ресурсов.

**Kubeconform**

- строгая валидация Kubernetes-манифестов  
- соответствие официальным схемам API

**Polaris**

- анализ security-настроек Pod и Deployment  
- выявление misconfiguration контейнеров


### Policy-as-Code (Open Policy Agent / Conftest)

Политики безопасности реализованы как код.

OPA используется для проверки:

- Kubernetes-манифестов  
- Terraform конфигураций  
- Helm-шаблонов

Это позволяет централизованно контролировать security-правила платформы.


### DAST (OWASP ZAP)

Динамическое тестирование безопасности приложения.

OWASP ZAP выполняет:

- автоматическое сканирование веб-приложения  
- обнаружение OWASP Top-10 уязвимостей  
- анализ API-эндпоинтов

Сканирование запускается на развёрнутом тестовом окружении. 
Используются baseline и full scan режимы.


### Fuzzing (ffuf)

Фаззинг используется для обнаружения скрытых и неочевидных точек атаки.

ffuf применяется для:

- поиска скрытых API-эндпоинтов  
- обнаружения незащищённых путей  
- тестирования обработки нестандартных запросов

Это дополняет DAST-сканирование и помогает выявлять нестандартные уязвимости.

--- 

# Software и Supply Chain Security

Контроль безопасности цепочки поставки программного обеспечения.

Фокус — защита зависимостей, артефактов и контейнерных образов на всех этапах доставки.

Подход основан на принципах **Software Supply Chain Security**, **artifact integrity** и **provenance verification**.


### Мониторинг зависимостей (Dependabot)

Автоматический мониторинг безопасности зависимостей.

Dependabot отслеживает появление уязвимостей в используемых библиотеках и инициирует Pull Request с обновлениями.

Позволяет:

- оперативно устранять уязвимые версии зависимостей  
- поддерживать актуальные версии библиотек  
- снижать риск эксплуатации известных CVE

Конфигурация: [`.github/dependabot.yml`](.github/dependabot.yml)

Документация: [`.github/DEPENDABOT.md`](.github/DEPENDABOT.md)

### SBOM генерация и анализ (Syft, Grype)

Контроль состава программных артефактов.

**Syft**

- генерация **SBOM (Software Bill of Materials)**  
- инвентаризация зависимостей приложений и контейнерных образов

**Grype**

- анализ SBOM на наличие уязвимостей  
- сопоставление компонентов с базами CVE

Использование SBOM позволяет обеспечить прозрачность цепочки поставки и контроль состава программных компонентов.


### Проверка лицензий (ScanCode Toolkit)

Контроль лицензионных рисков сторонних зависимостей.

ScanCode Toolkit анализирует используемые библиотеки и определяет:

- тип лицензии  
- возможные лицензионные конфликты  
- использование запрещённых лицензий

Это позволяет обеспечить соответствие юридическим требованиям при использовании open-source компонентов.


### SCA образов (Trivy Image)

Анализ безопасности контейнерных образов.

Trivy Image выполняет сканирование:

- системных пакетов базовых образов  
- установленных библиотек  
- конфигураций контейнеров

Security-гейт блокирует использование образов с критическими уязвимостями.


### Подпись и контроль артефактов (Cosign)

Обеспечение целостности и подлинности артефактов.

Cosign используется для:

- криптографической подписи контейнерных образов  
- проверки подлинности образов перед деплоем  
- защиты от подмены артефактов

Подписанные образы могут быть развернуты только после успешной проверки подписи.


### Закрытые артефактории (GHCR, Harbor, Nexus)

Все артефакты хранятся в контролируемых приватных репозиториях.

Это позволяет управлять доступом, контролировать безопасность и отслеживать происхождение артефактов.

**GHCR**

- хранение контейнерных образов, собираемых CI  
- интеграция с GitHub Actions

**Harbor**

- основной container registry платформы  
- встроенное сканирование уязвимостей  
- управление политиками безопасности образов

**Nexus**

- хранение бинарных артефактов  
- централизованное управление зависимостями

---

# Platform Security

Единый уровень платформенной безопасности.

Безопасность реализована на уровне инфраструктуры, идентификации, сетевых взаимодействий и рантайма Kubernetes-кластера.

Подход основан на принципах **Zero Trust**, **Least Privilege** и **Defense in Depth**.


## Identity и Secrets

Контроль идентификации, доступа и управления секретами реализован через централизованные системы управления.


### Secrets, PKI (HashiCorp Vault)

Централизованное управление секретами и криптографической инфраструктурой.

HashiCorp Vault используется для:

- хранения чувствительных данных  
- выдачи **dynamic secrets**  
- управления жизненным циклом credentials  
- генерации **PKI сертификатов**

Интеграция с Kubernetes позволяет автоматически выдавать и обновлять секреты для сервисов.

Это устраняет необходимость хранения секретов в конфигурациях и репозиториях.

Конфигурация: [`security-platform/secrets/vault`](security-platform/secrets/vault)

Документация: [`README.md`](security-platform/secrets/vault/README.md)


### IaM, OIDC/OAuth2 (Keycloak)

Единая система управления идентификацией и доступом.

Keycloak реализует:

- **OIDC / OAuth2 аутентификацию**  
- **RBAC управление доступами**  
- централизованную identity-платформу

Система интегрирована с:

- Kubernetes  
- Argo CD  
- DevOps-инструментами платформы

Это обеспечивает единый контроль доступа ко всем компонентам инфраструктуры.

Конфигурация: [`security-platform/iam/keycloak`](security-platform/iam/keycloak)

Документация: [`README.md`](security-platform/iam/keycloak/README.md)

## Kubernetes Security

Безопасность Kubernetes реализована на нескольких уровнях: контроль доступа, политики безопасности, рантайм-мониторинг и сетевые механизмы защиты.

### Cluster security (RBAC, NetworkPolicies, SecurityContext)

Базовые механизмы защиты Kubernetes-кластера.

**RBAC**

- управление правами доступа пользователей и сервисных аккаунтов  
- минимизация привилегий

**NetworkPolicies**

- сегментация сетевого трафика между сервисами  
- ограничение east-west взаимодействий

**SecurityContext**

- контроль прав контейнеров  
- запрет привилегированных контейнеров  
- ограничения capabilities


### Admission controller (Kyverno)

Политики безопасности реализованы через admission-контроллер.

Kyverno применяется для:

- проверки Kubernetes-ресурсов перед их созданием  
- автоматического применения security-политик  
- запрета небезопасных конфигураций

Примеры политик:

- запрет privileged контейнеров  
- обязательное использование resource limits  
- запрет использования latest тегов образов

Конфигурация: [`security-platform/admission-controller/kyverno`](security-platform/admission-controller/kyverno)

Документация: [`README.md`](security-platform/admission-controller/kyverno/README.md)

### Runtime security (Falco, Trivy)

Контроль безопасности выполняется на этапе выполнения контейнеров.

**Falco**

- runtime detection на базе **eBPF**  
- обнаружение подозрительных действий в контейнерах  
- выявление атак внутри кластера

Конфигурация: [`security-platform/runtime-security/falco`](security-platform/runtime-security/falco)

Документация: [`README.md`](security-platform/runtime-security/falco/README.md)

**Trivy**

- сканирование контейнерных образов  
- обнаружение CVE  
- генерация отчётов уязвимостей

Отчёты используются для контроля соответствия требованиям безопасности.

Конфигурация: [`security-platform/runtime-security/trivy`](security-platform/runtime-security/trivy)

Документация: [`README.md`](security-platform/runtime-security/trivy/README.md)


### East-West mTLS (Istio)

Защита сетевого взаимодействия между сервисами.

Service mesh обеспечивает:

- **mTLS шифрование трафика между сервисами**  
- аутентификацию сервисов  
- контроль сетевых политик

Это предотвращает перехват и подмену сервисного трафика внутри кластера.

Конфигурация: [`security-platform/service-mesh/istio`](security-platform/service-mesh/istio)

Документация: [`README.md`](security-platform/service-mesh/istio/README.md)

### CIS Benchmark (kube-bench)

Аудит безопасности Kubernetes-кластера.

kube-bench выполняет проверку соответствия **CIS Kubernetes Benchmark**.

Проверяются:

- настройки API-сервера  
- параметры kubelet  
- конфигурация control-plane

Результаты используются для выявления misconfiguration инфраструктуры.

Конфигурация: [`security-platform/cluster-security/kube-bench`](security-platform/cluster-security/kube-bench)

Документация: [`README.md`](security-platform/cluster-security/kube-bench/README.md)

---

# Управление уязвимостями и ASOC

Централизованная система управления уязвимостями.

Платформа агрегирует результаты всех security-сканирований, обеспечивает их обработку и управляет жизненным циклом уязвимостей.

Подход основан на принципах **Application Security Orchestration and Correlation (ASOC)** и **Continuous Vulnerability Management**.


## ASOC (DefectDojo)

Центральная платформа управления результатами security-сканирований.

DefectDojo используется для:

- централизованного сбора отчётов из security-инструментов  
- корреляции результатов разных сканеров  
- дедупликации уязвимостей  
- отслеживания жизненного цикла vulnerabilities

В платформу импортируются отчёты из:

- SAST  
- SCA  
- DAST  
- container scanning  
- IaC scanning

Это формирует единую точку управления безопасностью приложений.

Конфигурация: [`security-platform/vulnerability-management/defectdojo`](security-platform/vulnerability-management/defectdojo)

Документация: [`README.md`](security-platform/vulnerability-management/defectdojo/README.md)


## AppSec процессы

В системе реализован полный цикл обработки уязвимостей.

Каждая обнаруженная уязвимость проходит стандартный AppSec workflow.


### Триаж

Первичная обработка результатов сканирования.

На этапе триажа выполняется:

- анализ критичности уязвимости  
- проверка воспроизводимости  
- определение зоны ответственности (разработка / инфраструктура)

После анализа уязвимости назначаются ответственным командам.


### Обработка False Positive

Обработка ложных срабатываний security-инструментов.

Если уязвимость подтверждается как ложная:

- она маркируется как **False Positive**  
- фиксируется причина  
- исключается из дальнейших отчётов

Это снижает шум в системе управления уязвимостями.


### Принятие рисков

Формализованный процесс принятия рисков.

Если уязвимость не может быть устранена немедленно:

- выполняется оценка риска  
- фиксируется обоснование  
- устанавливается срок пересмотра

Такая процедура позволяет документировать управляемые риски и поддерживать прозрачность AppSec-процессов.

---

# Моделирование угроз

Методология анализа угроз и системный маппинг рисков.

Threat Modeling используется как архитектурный инструмент для выявления угроз на ранних этапах разработки и проектирования системы.

Анализ выполняется на уровне приложения, инфраструктуры и DevOps-процессов.


## Методология (STRIDE)

Моделирование угроз проводится по методологии **STRIDE**.

Методология используется для систематического анализа архитектуры и выявления классов угроз:

- **Spoofing** — подмена идентификации  
- **Tampering** — изменение данных или конфигураций  
- **Repudiation** — отказ от совершённых действий  
- **Information Disclosure** — утечка конфиденциальной информации  
- **Denial of Service** — отказ в обслуживании  
- **Elevation of Privilege** — повышение привилегий

Для каждого класса угроз определяются механизмы защиты на уровне приложения, инфраструктуры и платформы.


## Домены риска

Моделирование угроз проводится для ключевых компонентов архитектуры.

### Application

Риски уровня бизнес-логики и серверной обработки данных.

Контроль реализован через:

- SAST  
- SCA  
- secure coding practices  
- dependency management  
- security testing

### API

Риски, связанные с взаимодействием клиентов и сервисов.

Контроль реализован через:

- DAST тестирование  
- fuzzing  
- API security scanning  
- аутентификацию и авторизацию через OIDC

### Kubernetes

Риски инфраструктуры контейнерной платформы.

Контроль реализован через:

- RBAC  
- NetworkPolicies  
- admission policies  
- runtime security  
- CIS benchmark auditing

### CI/CD

Риски цепочки поставки программного обеспечения.

Контроль реализован через:

- security gates в CI  
- artifact signing  
- supply chain security  
- контроль зависимостей  
- централизованное управление артефактами

## OWASP Top-10:2025 маппинг

В проекте реализовано покрытие категорий **OWASP Top-10:2025** через комбинацию DevSecOps-процессов, security-инструментов и архитектурных механизмов защиты.

### A01 — Broken Access Control

Контроль доступа реализован на уровне платформы и приложений.

Механизмы защиты:

- RBAC в Kubernetes  
- OIDC/OAuth2 аутентификация (Keycloak)  
- сервисная аутентификация  
- NetworkPolicies  
- policy enforcement через Kyverno  
- API security тестирование (DAST, fuzzing)

Это предотвращает несанкционированный доступ к сервисам и данным.


### A02 — Security Misconfiguration

Контроль конфигураций инфраструктуры и платформы.

Механизмы защиты:

- Checkov (IaC security scanning)  
- Polaris (Kubernetes security checks)  
- kube-bench (CIS benchmark auditing)  
- Terraform validate / TFLint  
- Ansible-lint  
- Helm lint / Helmfile lint

Такая проверка предотвращает ошибки конфигурации инфраструктуры и Kubernetes.


### A03 — Software Supply Chain Failures

Контроль цепочки поставки программного обеспечения.

Механизмы защиты:

- Dependabot (monitoring зависимостей)  
- OWASP Dependency-Check  
- SBOM генерация (Syft)  
- SBOM анализ (Grype)  
- container scanning (Trivy)  
- artifact signing (Cosign)  
- приватные registry (GHCR, Harbor, Nexus)

Это обеспечивает контроль происхождения и безопасности программных компонентов.


### A04 — Cryptographic Failures

Защита криптографических механизмов и секретов.

Механизмы защиты:

- централизованное управление секретами (Vault)  
- PKI инфраструктура  
- mTLS между сервисами (Istio)  
- безопасное хранение credentials

Это предотвращает утечку чувствительных данных и компрометацию ключей.


### A05 — Injection

Обнаружение и предотвращение инъекционных атак.

Механизмы защиты:

- SAST (Semgrep, SonarQube)  
- DAST (OWASP ZAP)  
- fuzzing тестирование (ffuf)  
- secure coding practices  
- dependency scanning

Эти проверки выявляют уязвимости до попадания кода в production.


### A06 — Insecure Design

Контроль архитектурных рисков и ошибок проектирования.

Механизмы защиты:

- threat modeling (STRIDE)  
- secure architecture review  
- security-by-design  
- policy-as-code

Это снижает вероятность появления системных архитектурных уязвимостей.


### A07 — Authentication Failures

Контроль механизмов аутентификации и управления идентификацией.

Механизмы защиты:

- OIDC / OAuth2 (Keycloak)  
- централизованная identity-платформа  
- RBAC управление доступом  
- сервисная аутентификация

Это предотвращает компрометацию учетных записей и обход аутентификации.


### A08 — Software or Data Integrity Failures

Контроль целостности программных артефактов и данных.

Механизмы защиты:

- SBOM  
- Cosign подпись контейнерных образов  
- artifact provenance  
- контроль registry  
- GitOps delivery

Такая модель предотвращает подмену программных компонентов.


### A09 — Logging & Alerting Failures

Контроль журналирования и обнаружения инцидентов.

Механизмы защиты:

- observability stack (Prometheus, Grafana)  
- distributed tracing (Jaeger)  
- runtime detection (Falco)  
- централизованный анализ security-событий

Это обеспечивает обнаружение атак и аномалий в инфраструктуре.


### A10 — Mishandling of Exceptional Conditions

Контроль обработки ошибок и нестандартных ситуаций.

Механизмы защиты:

- secure error handling в приложении  
- SAST анализ ошибок обработки исключений  
- fuzzing тестирование  
- DAST проверка некорректных запросов

Это предотвращает утечки данных и уязвимости, возникающие при ошибках выполнения.


## CWE Top-25 маппинг

Результаты статического анализа и сканирования зависимостей сопоставляются с **CWE Top-25 Most Dangerous Software Weaknesses**.

Маппинг позволяет:

- классифицировать уязвимости по типам слабостей ПО  
- анализировать системные ошибки разработки  
- контролировать устранение наиболее критичных классов уязвимостей

Основные источники данных:

- **SAST** (Semgrep, SonarQube)  
- **SCA** (OWASP Dependency-Check, Trivy, Grype)

Результаты агрегируются в **DefectDojo**, где выполняется корреляция и управление жизненным циклом уязвимостей.


### CWE-79 — Cross-Site Scripting (XSS)

Обнаружение:

- SAST (Semgrep, SonarQube)  
- DAST (OWASP ZAP)

Контроль:

- secure input validation  
- output encoding  
- frontend linting


### CWE-89 — SQL Injection

Обнаружение:

- SAST анализ backend-кода  
- DAST сканирование API

Контроль:

- ORM и параметризованные запросы  
- secure coding practices


### CWE-20 — Improper Input Validation

Обнаружение:

- SAST  
- fuzzing (ffuf)

Контроль:

- строгая валидация входных данных  
- API testing


### CWE-78 — OS Command Injection

Обнаружение:

- SAST правила Semgrep  
- SonarQube security rules

Контроль:

- запрет небезопасных системных вызовов  
- secure coding guidelines


### CWE-22 — Path Traversal

Обнаружение:

- SAST  
- DAST

Контроль:

- строгая обработка путей  
- ограничение доступа к файловой системе


### CWE-352 — Cross-Site Request Forgery (CSRF)

Обнаружение:

- DAST (OWASP ZAP)

Контроль:

- CSRF-tokens  
- secure session management


### CWE-434 — Unrestricted File Upload

Обнаружение:

- SAST  
- DAST

Контроль:

- проверка типов файлов  
- sandboxing загрузок


### CWE-287 — Improper Authentication

Обнаружение:

- SAST  
- security-review архитектуры

Контроль:

- OIDC/OAuth2 аутентификация (Keycloak)  
- централизованный IAM


### CWE-862 — Missing Authorization

Обнаружение:

- SAST анализ бизнес-логики

Контроль:

- RBAC  
- policy-based access control


### CWE-269 — Improper Privilege Management

Контроль:

- Kubernetes RBAC  
- Kyverno policies  
- SecurityContext


### CWE-502 — Deserialization of Untrusted Data

Обнаружение:

- SAST правила Semgrep

Контроль:

- безопасная сериализация  
- проверка источников данных


### CWE-476 — NULL Pointer Dereference

Обнаружение:

- статический анализ (SonarQube)

Контроль:

- secure coding practices  
- строгая типизация (MyPy)


### CWE-416 — Use After Free

Обнаружение:

- SAST

Контроль:

- безопасные библиотеки  
- анализ зависимостей


### CWE-190 — Integer Overflow

Обнаружение:

- SAST правила анализа арифметики

Контроль:

- проверка границ значений  
- безопасные операции


### CWE-400 — Uncontrolled Resource Consumption

Контроль:

- Kubernetes resource limits  
- rate limiting  
- нагрузочное тестирование


### CWE-918 — Server-Side Request Forgery (SSRF)

Обнаружение:

- DAST  
- fuzzing

Контроль:

- NetworkPolicies  
- service mesh  
- контроль исходящих соединений


### CWE-522 — Insufficiently Protected Credentials

Контроль:

- HashiCorp Vault  
- dynamic secrets  
- исключение хранения секретов в коде


### CWE-798 — Hardcoded Credentials

Обнаружение:

- Gitleaks  
- SAST

Контроль:

- централизованное управление секретами


### CWE-306 — Missing Authentication for Critical Function

Контроль:

- OIDC/OAuth2  
- API security testing


### CWE-284 — Improper Access Control

Контроль:

- Kubernetes RBAC  
- Kyverno policies  
- IAM управление доступом


### CWE-94 — Code Injection

Обнаружение:

- SAST  
- DAST

Контроль:

- secure coding practices  
- input validation


### CWE-200 — Information Exposure

Обнаружение:

- SAST  
- DAST

Контроль:

- secure error handling  
- контроль логирования


### CWE-770 — Allocation of Resources Without Limits

Контроль:

- Kubernetes resource quotas  
- pod limits


### CWE-285 — Improper Authorization

Контроль:

- RBAC  
- policy-based access control


### CWE-918 — Server-Side Request Forgery (повторная категория)

Контроль:

- network segmentation  
- API validation  
- outbound traffic policies

---

# Регуляторные требования и стандарты

Связь технических контролей платформы с требованиями российских нормативных актов, международных стандартов и фреймворков.

Архитектура платформы построена так, чтобы реализованные DevSecOps‑контроли могли быть напрямую сопоставлены с требованиями регуляторов. Такой подход позволяет использовать платформу как демонстрационную модель реализации требований информационной безопасности.


## Российские регуляторы

Проект демонстрирует технические механизмы реализации требований основных российских регуляторов ИБ.


### ФСТЭК

Реализация технических мер защиты информации в соответствии с требованиями ФСТЭК.


**Нормативная база**  
- приказ № 117 от 11.04.2025 (вступает в силу с 01.03.2026);
- приказ № 235 от 21.12.2017;
- приказ № 239 от 25.12.2017;
- приказ № 77 (требования к аттестации информационных систем);
- приказ № 76 (уровни доверия к средствам защиты информации).

**Соответствующие технические контроли**  

Контроль доступа
- Keycloak (OIDC / OAuth2, RBAC);
- Kubernetes RBAC;
- NetworkPolicies.

Управление уязвимостями  
- DefectDojo (ASOC);
- SAST / SCA / DAST;
- Trivy, Dependency‑Check, Semgrep.

Контроль целостности ПО  
- Cosign подпись артефактов;
- SBOM (Syft, Grype).

Контроль конфигураций  
- Checkov (IaC security);
- Polaris;
- kube‑bench (аудит соответствия CIS benchmark).

Контроль событий безопасности  
- Falco runtime detection;
- observability stack.

Такая архитектура реализует технические меры защиты информации, требуемые регулятором, включая управление изменениями и аудит конфигураций.

### ФЗ‑187

Закон о безопасности критической информационной инфраструктуры.

**Нормативная база**  
- ФЗ‑187;
- ПП РФ № 127 от 08.02.2018 (категорирование объектов КИИ);
- ПП РФ № 1912 от 14.11.2023;
- ст. 5 ФЗ‑187 (взаимодействие с ГосСОПКА);
- ст. 10 ФЗ‑187 (требования к защите КИИ).

**Реализованные меры**  

Контроль доступа  
- централизованный IAM (Keycloak);
- RBAC;
- сервисная аутентификация.

Контроль сетевых взаимодействий  
- NetworkPolicies;
- service mesh (Istio);
- mTLS между сервисами.

Контроль безопасности инфраструктуры  
- Kubernetes security policies;
- admission control (Kyverno);
- CIS benchmark auditing (kube‑bench).

Мониторинг безопасности  
- Falco runtime security;
- observability stack;
- централизованный анализ событий;
- взаимодействие с ГосСОПКА отсутствует (реализация требований ст. 5 ФЗ‑187).

### ФЗ‑152

Защита персональных данных.

**Нормативная база**  
- ФЗ‑152;
- ПП РФ № 1119 от 01.11.2012;
- приказ ФСТЭК № 21 (меры по обеспечению безопасности ПДн).

**Реализованные меры защиты**  

Контроль доступа к данным  
- OIDC / OAuth2 аутентификация;
- RBAC;
- сегментация сетевых взаимодействий.

Защита данных  
- управление секретами через Vault;
- PKI инфраструктура;
- шифрование сервисных коммуникаций (mTLS).

Контроль уязвимостей  
- SAST / SCA / DAST;
- управление уязвимостями (DefectDojo).

Журналирование и мониторинг   
- observability stack;
- runtime security detection.

Документация и учёт  
- регистрация в реестре операторов Роскомнадзора отсутствует (требование ФЗ‑152);
- ведение журналов доступа и изменений в соответствии с приказом ФСТЭК № 21.

### ФСБ

Требования к криптографической защите информации.

**Нормативная база**  
- приказ № 378 от 10.07.2014;
- приказы № 539, 546, 547, 553, 554 (2025);
- требования к эксплуатации СКЗИ (ведение журналов, контроль актуальности сертификатов).

**Реализованные механизмы**  

Криптографическая защита  
- PKI инфраструктура (Vault);
- mTLS шифрование сервисного трафика;
- управление сертификатами (включая их жизненный цикл и актуальность).

Контроль целостности программного обеспечения  
- Cosign подпись контейнерных образов;
- контроль provenance артефактов.

Защита секретов  
- централизованное управление секретами;
- dynamic secrets;
- ведение журналов эксплуатации СКЗИ (требование приказа № 378).

Соответствие требованиям к СКЗИ  
- использование сертифицированных СКЗИ ФСБ отсутствует;
- соблюдение правил эксплуатации СКЗИ, включая контроль за актуальностью сертификатов.

Такая архитектура демонстрирует практическую реализацию криптографической защиты в cloud‑native инфраструктуре, включая общие требования к ведению документации и аудиту, но с отсутствием сертифицированных СКЗИ ФСБ.

## Российские стандарты

Соответствие Secure SDLC практикам российских стандартов разработки безопасного программного обеспечения.

Технические механизмы DevSecOps-платформы напрямую маппируются на требования стандартов жизненного цикла разработки, контроля безопасности кода и управления уязвимостями.


### ГОСТ Р 56939-2024

Актуальный стандарт безопасной разработки программного обеспечения.

Стандарт определяет требования к **Secure SDLC**, управлению уязвимостями и контролю безопасности на всех этапах разработки.

**Реализованные практики**

Secure SDLC

- CI/CD security gates  
- автоматизированные security-проверки

Статический и динамический анализ

- SAST (Semgrep, SonarQube)  
- DAST (OWASP ZAP)

Контроль зависимостей

- OWASP Dependency-Check  
- SBOM (Syft, Grype)

Управление уязвимостями

- централизованная платформа ASOC (DefectDojo)  
- triage / false positive / risk acceptance workflow

Threat modeling

- STRIDE  
- OWASP Top-10 и CWE Top-25 маппинг


### ГОСТ Р 56938-2016

Стандарт организации безопасного жизненного цикла разработки программного обеспечения.

**Реализованные практики**

Безопасная разработка

- secure coding guidelines  
- code quality gates

Контроль безопасности кода

- SAST  
- dependency scanning

Контроль конфигураций

- IaC security scanning (Checkov)  
- Kubernetes policy enforcement (Kyverno)

Контроль релизов

- GitOps delivery  
- подписанные артефакты (Cosign)


### ГОСТ Р 58833-2020

Стандарт процессов анализа уязвимостей программного обеспечения.

**Реализованные механизмы**

Поиск уязвимостей

- SAST  
- DAST  
- container scanning

Агрегация результатов

- централизованный сбор отчётов (DefectDojo)

Управление уязвимостями

- triage  
- false positive handling  
- risk acceptance

Отслеживание устранения

- lifecycle management vulnerabilities


### ГОСТ Р 594531-2021

Стандарт управления безопасностью программного обеспечения.

**Реализованные механизмы**

Контроль безопасности разработки

- DevSecOps процессы  
- CI/CD security gates

Контроль инфраструктуры

- IaC security scanning  
- Kubernetes security policies

Контроль поставки ПО

- software supply chain security  
- SBOM  
- artifact signing


### ГОСТ Р 594532-2021

Стандарт обеспечения безопасности программного обеспечения при эксплуатации.

**Реализованные механизмы**

Мониторинг безопасности

- observability stack  
- runtime detection (Falco)

Контроль инфраструктуры

- Kubernetes runtime security  
- CIS benchmark auditing

Контроль уязвимостей

- container scanning  
- dependency monitoring


### ГОСТ Р 59547-2021

Стандарт процессов анализа и обработки уязвимостей.

**Реализованные механизмы**

Управление уязвимостями

- централизованная ASOC платформа (DefectDojo)

Корреляция результатов сканирований

- SAST  
- SCA  
- DAST  
- container scanning

Процессы обработки уязвимостей

- triage workflow  
- false positive handling  
- risk acceptance

Это обеспечивает управляемый жизненный цикл vulnerabilities в DevSecOps-среде.

## Международные стандарты

Архитектура платформы и DevSecOps-процессы сопоставлены с требованиями международных стандартов управления информационной безопасностью.

Технические контроли реализуют практические механизмы, используемые в рамках **ISMS (Information Security Management System)** и процессов управления рисками.


### ISO/IEC 27001:2022

Стандарт управления системой информационной безопасности (ISMS).

Платформа демонстрирует техническую реализацию ключевых доменов контроля безопасности.

**Реализованные механизмы**

Контроль доступа

- централизованный IAM (Keycloak)  
- RBAC в Kubernetes  
- NetworkPolicies

Управление уязвимостями

- SAST / SCA / DAST  
- container scanning  
- централизованная платформа ASOC (DefectDojo)

Контроль разработки и изменений

- CI/CD security gates  
- GitOps delivery  
- policy-as-code

Контроль целостности программного обеспечения

- SBOM генерация  
- Cosign подпись контейнерных образов  
- контроль provenance артефактов

Мониторинг безопасности

- observability stack  
- runtime detection (Falco)


### ISO/IEC 27002:2022

Практические рекомендации по реализации мер защиты информации.

DevSecOps-архитектура платформы реализует ключевые технические контроли стандарта.

**Реализованные механизмы**

Secure development

- secure SDLC  
- статический анализ кода  
- dependency scanning

Identity и доступ

- OIDC / OAuth2 аутентификация  
- RBAC  
- сервисная аутентификация

Управление секретами

- HashiCorp Vault  
- dynamic secrets  
- PKI инфраструктура

Безопасность инфраструктуры

- Kubernetes security policies  
- admission control (Kyverno)  
- CIS benchmark auditing

Безопасность сети

- NetworkPolicies  
- service mesh (Istio)  
- mTLS между сервисами


### ISO/IEC 27005:2022

Стандарт управления рисками информационной безопасности.

В проекте реализована модель управления рисками на основе threat modeling и централизованного управления уязвимостями.

**Реализованные механизмы**

Анализ угроз

- threat modeling (STRIDE)  
- маппинг OWASP Top-10  
- маппинг CWE Top-25

Оценка уязвимостей

- SAST  
- SCA  
- DAST  
- container scanning

Управление рисками

- triage workflow  
- false positive handling  
- risk acceptance process

Мониторинг рисков

- observability stack  
- runtime security detection  
- централизованный анализ результатов сканирования


## Международные фреймворки

Помимо нормативных требований используются международные отраслевые фреймворки безопасности разработки.

Эти модели **не являются нормативными требованиями**.  
Они носят **рекомендательный характер** и используются для:

- оценки зрелости процессов безопасности
- построения roadmap улучшений DevSecOps
- сопоставления практик с отраслевыми стандартами

Фреймворки помогают структурировать процессы Secure SDLC и сопоставить архитектуру проекта с практиками ведущих технологических компаний.


### OWASP SAMM / BSIMM

Фреймворки применяются для оценки зрелости DevSecOps-процессов и анализа практик безопасности разработки.

#### OWASP SAMM

OWASP SAMM используется как модель зрелости Secure SDLC.

Фреймворк разделяет практики безопасности на 5 доменов:

- Governance  
- Design  
- Implementation  
- Verification  
- Operations

**Оценка зрелости проекта**

| SAMM Domain | Реализованные практики | Уровень |
|---|---|---|
| Governance | security policies, DevSecOps процессы, vulnerability management | Level 2 |
| Design | threat modeling (STRIDE), secure architecture | Level 2 |
| Implementation | SAST, SCA, dependency management | Level 3 |
| Verification | DAST, fuzzing, security testing | Level 3 |
| Operations | runtime security, observability, incident monitoring | Level 2 |

**Итоговая зрелость**

Платформа соответствует примерно **SAMM Level 2–3** (Managed / Defined).

Это означает:

- системные DevSecOps процессы
- автоматизированные security-контроли
- управляемый жизненный цикл уязвимостей


#### BSIMM

BSIMM используется для сопоставления реализованных практик с индустриальными моделями безопасности разработки.

Фреймворк анализирует реальные практики безопасности крупных технологических компаний.

**Соответствие практикам BSIMM**

Проект демонстрирует практики из следующих доменов BSIMM:

- Strategy & Metrics  
- Attack Models  
- Architectural Analysis  
- Code Review  
- Security Testing  
- Penetration Testing  
- Software Environment  
- Configuration Management & Vulnerability Management

**Тип компаний**

Подобный уровень практик характерен для компаний с развитой DevSecOps-культурой:

- cloud-native компании  
- fintech и high-tech организации  
- SaaS-платформы

Примеры компаний из BSIMM, где применяются аналогичные практики:

- Microsoft  
- Salesforce  
- Adobe  
- PayPal  
- VMware


### NIST SSDF / CSF

Фреймворки NIST используются как практическое руководство для внедрения безопасной разработки.

#### NIST SSDF (Secure Software Development Framework)

SSDF определяет практики Secure SDLC.

Фреймворк разделён на четыре ключевых области:

- Prepare the Organization (PO)  
- Protect the Software (PS)  
- Produce Well-Secured Software (PW)  
- Respond to Vulnerabilities (RV)

**Реализованные практики**

Prepare the Organization

- DevSecOps процессы  
- централизованная security-платформа

Protect the Software

- artifact signing (Cosign)  
- SBOM generation  
- supply chain security

Produce Well-Secured Software

- SAST / SCA  
- dependency scanning  
- CI security gates

Respond to Vulnerabilities

- DefectDojo ASOC  
- vulnerability triage workflow  
- risk acceptance process


#### NIST CSF (Cybersecurity Framework)

CSF используется как высокоуровневая модель управления кибербезопасностью.

Фреймворк включает пять основных функций:

- Identify  
- Protect  
- Detect  
- Respond  
- Recover

**Соответствие проекта**

Identify

- threat modeling  
- SBOM inventory  
- dependency tracking

Protect

- IAM (Keycloak)  
- Vault secrets management  
- Kubernetes security policies

Detect

- runtime detection (Falco)  
- observability stack  
- vulnerability scanning

Respond

- vulnerability management workflow  
- DefectDojo triage

Recover

- GitOps deployment  
- reproducible infrastructure (IaC)

Таким образом DevSecOps-платформа демонстрирует практическое применение рекомендаций NIST для безопасной разработки и эксплуатации программных систем.
