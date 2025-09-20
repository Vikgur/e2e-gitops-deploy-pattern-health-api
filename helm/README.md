# Оглавление

- [О проекте](#о-проекте)  
- [Архитектура Helm/Helmfile](#архитектура-helmhelmfile)  
- [Адаптация manual deploy в GitOps deploy](#адаптация-manual-deploy-в-gitops-deploy)  
  - [infra/](#infra)
  - [Внедрение ARGO Rollout](#внедрение-argo-rollout)
  - [Изменения Helmfile для prod и dev](#изменения-helmfile-для-prod-и-dev)  
    - [Prod (helmfile.prod.gotmpl)](#prod-helmfileprodgotmpl)  
    - [Dev (helmfile.dev.gotmpl)](#dev-helmfiledevgotmpl)
- [Структура](#структура)  
  - [Bitnami_charts/](#bitnami_charts)  
  - [helm/](#helm)  
    - [Возможность отката на manual/fallback](#возможность-отката-на-manualfallback)
  - [helm/helmfile.prod.gotmpl](#helmhelmfileprodgotmpl)  
  - [helm/helmfile.dev.gotmpl](#helmhelmfiledevgotmpl)  
  - [helm/values](#helmvalues)  
    - [Использование общих values для stage и prod](#использование-общих-values-для-stage-и-prod)
- [Требования перед запуском](#требования-перед-запуском)  
- [Инструкция по запуску (Makefile)](#инструкция-по-запуску-makefile)  
  - [Подготовка](#подготовка)  
  - [Основные команды](#основные-команды)  
  - [Blue/Green (prod)](#bluegreen-prod)  
  - [Canary (prod)](#canary-prod)  
  - [Проверки и политика](#проверки-и-политика)
- [Реализация Blue/Green и Canary](#реализация-bluegreen-и-canary)  
  - [Стратегии деплоя](#стратегии-деплоя)  
  - [Инструкция по деплою](#инструкция-по-деплою)  
    - [1. Blue/Green деплой](#1-bluegreen-деплой)  
    - [2. Проверка нового релиза](#2-проверка-нового-релиза)  
    - [3. Переключение-трафика](#3-переключение-трафика)  
    - [4. Canary rollout](#4-canary-rollout)  
    - [5. Rollback сценарии](#5-rollback-сценарии)  
- [Kubernetes Best Practices в Helm-чартах](#kubernetes-best-practices-в-helm-чартах)  
- [Внедренные DevSecOps практики](#внедренные-devsecops-практики)  
  - [Архитектура безопасности](#архитектура-безопасности)  
  - [Покрытие](#покрытие)  
    - [Базовые проверки](#базовые-проверки)  
    - [Линтеры и SAST](#линтеры-и-sast)  
    - [Policy-as-Code](#policy-as-code)  
    - [Конфигурации и безопасность секретов](#конфигурации-и-безопасность-секретов)  
    - [CI/CD и инфраструктура](#cicd-и-инфраструктура)  
  - [Результат](#результат)  
  - [Запуск проверок](#запуск-проверок)  
    - [Соответствие OWASP Top-10](#соответствие-owasp-top-10)  

---

# О проекте

Данный проект — рабочая инфраструктура деплоя веб-приложения [`health-api`](https://github.com/vikgur/health-api-for-microservice-stack) с использованием **Helm**, **Helmfile** и **Argo Rollouts**. Репозиторий содержит полный набор чартов для сервисов приложения (backend, frontend, nginx, postgres, jaeger, swagger) и управляет их раскаткой в окружениях **dev** и **prod**.

Основные задачи:

* единая структура деплоя всех сервисов в директории `helm/`;  
* использование Helmfile (`helmfile.dev.gotmpl`, `helmfile.prod.gotmpl`) для централизованного управления релизами;  
* удобное разделение окружений через values-файлы (`values/values-dev/`, `values/blue/`, `values/green/`, `values/canary/`);  
* единые базовые values для всех окружений с Blue/Green/Canary оверрайдами;  
* воспроизводимый запуск через Makefile и CI/CD;  
* продвинутая стратегия выката: **Blue/Green и Canary через Argo Rollouts**;  
* интеграция DevSecOps-практик (Trivy, Checkov, Conftest) для проверки IaC и чартов.  

Особенности:

* **Единая конфигурация для всех окружений** — базовые values общие, различия вынесены в отдельные директории (`values-dev/`, `blue/`, `green/`, `canary/`). Порядок их подключения задаёт конкретное окружение.  
* **VERSION управляет тегом образа и переменной окружения**, обеспечивая строгую связку кода и артефактов.  
* Применён паттерн **Helm Monorepo**: все чарты и values хранятся в одном репозитории, что исключает дрейф версий и упрощает воспроизводимость.  
* Используются стратегии **Blue/Green и Canary** через Argo Rollouts:  
  - Blue/Green — отдельные слоты `blue` и `green` с `activeService` и `previewService`.  
  - Canary — пошаговый перевод трафика (10% → 30% → 60% → 100%).  

---

# Архитектура Helm/Helmfile

Проект упакован в директорию `helm/`, где каждый сервис имеет свой чарт (`backend`, `frontend`, `postgres`, `nginx`, `jaeger`, `swagger` и др.), а управление релизами централизовано через **Helmfile** (`helmfile.dev.gotmpl`, `helmfile.prod.gotmpl`).  

Values вынесены в каталог `helm/values/`, который разделён по окружениям и стратегиям:  
- `values-dev/` — конфигурация для разработки, без Rollouts,  
- `blue/` и `green/` — конфигурация для Blue/Green деплоя,  
- `canary/` — конфигурация для Canary-стратегии,  
- общие базовые values переиспользуются между окружениями.  

В результате:  
- **структура прозрачна** — у каждого сервиса есть отдельный чарт,  
- **деплой воспроизводим** — логика окружений полностью описана в helmfile,  
- **гибкость обеспечена** — поддержка `dev` и `prod` с продвинутыми стратегиями выката (**Blue/Green и Canary через Argo Rollouts**).  

---

# Адаптация manual deploy в GitOps deploy

## infra/

Директория `infra/` оставлена как артефакт manual-паттерна. В GitOps не используется, но позволяет быстро откатить проект в manual при необходимости

## Внедрение ARGO Rollout

**Шаг 1. Конвертация Deployment → Rollout**

- Переименовать `deployment.yaml` в `rollout.yaml` в сервисах **backend**, **frontend**, **nginx** (best practice).  
- В манифесте заменить `kind: Deployment` на `kind: Rollout`.  
- Сохранить все настройки контейнеров (`env`, `probes`, `resources`, `volumes`).  
- В конец манифеста добавить универсальный блок стратегии:

```yaml
strategy:
{{- if eq .Values.rollout.strategy "blueGreen" }}
  blueGreen:
    activeService: {{ .Values.rollout.activeService }}
    previewService: {{ .Values.rollout.previewService }}
    autoPromotionEnabled: {{ .Values.rollout.autoPromotionEnabled | default false }}
{{- else if eq .Values.rollout.strategy "canary" }}
  canary:
    steps:
      {{- toYaml .Values.rollout.steps | nindent 6 }}
{{- end }}
```

**Шаг 2. Настройка values для стратегий**

- В `values/blue/*` и `values/green/*` добавить блок `rollout` со стратегией **blueGreen**; различие только в `image.tag`.  
- В `values/canary/*` добавить блок `rollout` со стратегией **canary** и `steps`.  
- Сервисы без стратегий (postgres, jaeger и др.) оставить на `Deployment`.  

## Изменения Helmfile для prod и dev

### Prod (`helmfile.prod.gotmpl`)

- Оставлен **один release на сервис** (backend, frontend, nginx), вместо дубликатов (-blue/-green).  
- Подключение values через `values/{{ requiredEnv "ENV" }}` → позволяет переключать blue/green/canary через переменную `ENV`.  
- **alias-service** удалён (traffic switch теперь выполняет Argo Rollouts).  
- Выставлен порядок зависимостей: `postgres → backend → frontend → nginx`.  
- Добавлены `helmDefaults` (`wait: true`, `timeout: 600`, `verify: true`).  
- `init-db` оставлен, но выключен (`installed: false`) как fallback/manual.  

### Dev (`helmfile.dev.gotmpl`)

- Подключение values строго из `values/dev/*`.  
- Оставлен **один release на сервис**, Rollouts не используются (обычные Deployments).  
- **alias-service** выключен (`installed: false`) как неактуальный для dev.  
- `init-db` выключен (`installed: false`), оставлено для ручного исполнения, миграции будут настроены через backend-job.  
- Прописан порядок зависимостей: `postgres → backend → frontend → nginx`.  
- Добавлен блок `helmDefaults` (`wait: true`, `timeout: 600`, `verify: true`).  
- Добавлена секция `environments.dev` с `requiredEnv "VERSION"` для управления версиями образов.  

---

# Структура

## Bitnami_charts/

В проекте используется чарт PostgreSQL от Bitnami.  
Из-за ограничений доступа без VPN чарт хранится локально в репозитории.  
Это гарантирует воспроизводимость установки без внешних зависимостей.

## helm/

- **backend/** — Helm-чарт для основного backend-сервиса.  
- **common/** — общие шаблоны и настройки (labels, probes, ресурсы), переиспользуемые в других чартах.  
- **frontend/** — Helm-чарт для frontend-приложения.  
- **init-db/** — чарт для инициализации базы данных (создание схем, начальных данных); по умолчанию выключен.  
- **jaeger/** — чарт для системы трассировки запросов Jaeger.  
- **nginx/** — чарт для nginx-прокси внутри проекта.  
- **postgres/** — чарт для PostgreSQL (БД проекта).  
- **swagger/** — чарт для swagger-ui (UI документации API).  
- **values/** — values-файлы для всех сервисов (отдельно `dev/`, `blue/`, `green/`, `canary/`).  
- **helmfile.dev.gotmpl** — конфиг для раскатки полного стека в dev-окружении.  
- **helmfile.prod.gotmpl** — конфиг для production-окружения (c Blue/Green и Canary стратегиями).  
- **rsync-exclude.txt** — список исключений dev-файлов для синхронизации прод-файлов на мастер-ноду.  

### Возможность отката на manual/fallback

- **alias-service/** — вспомогательный сервис для ручного переключения слотов (использовался в manual-подходе, отключён в GitOps).  
- **infra/** — инфраструктурные чарты для manual-деплоя (ingress-nginx и др.); сохранены как fallback.  

## helm/helmfile.prod.gotmpl

Файл является единой точкой управления и описывает все релизы production-окружения. Он гарантирует согласованное и воспроизводимое развертывание и позволяет в один шаг раскатить все чарт-сервисы проекта: **backend, frontend, nginx, postgres, swagger, jaeger, init-db**.  

В нём:  
- задаются пути к чартам и values-файлам (`values/blue/`, `values/green/`, `values/canary/`),  
- подключаются переменные окружения (`VERSION` для образов, `ENV` для выбора слота/стратегии),  
- указываются зависимости между сервисами (через `needs`),  
- стратегии выкладки реализованы через **Argo Rollouts**:  
  - Blue/Green — один Rollout на сервис с `activeService` и `previewService`,  
  - Canary — поэтапное переключение трафика через `strategy.canary.steps`.  

Дополнительные сервисы:  
- **jaeger** — сервис трассировки запросов (observability), всегда устанавливается.  
- **init-db** — вспомогательный чарт для инициализации базы данных; по умолчанию отключён (`installed: false`), используется вручную при первичной настройке.  

## helm/helmfile.dev.gotmpl

Файл описывает все релизы dev-окружения и является упрощённым аналогом production-конфига. Предназначен для разработки и отладки: позволяет в один шаг поднять полный стек приложения в namespace `health-api`.   

В нём:  
- используются values из каталога `values/dev/`,  
- задеплоены сервисы: **backend, frontend, nginx, postgres, swagger, jaeger, init-db**,  
- задаются зависимости между сервисами (например, nginx зависит от backend и frontend),  
- переменная `VERSION` берётся из окружения и подставляется в образы backend, frontend и nginx.  

Особенности:  
- **Blue/Green и Canary не применяются** — сервисы деплоятся как обычные Deployment для упрощённой разработки.  
- **init-db** может включаться для быстрой инициализации БД в dev-сценариях.  
- Все сервисы работают в одном namespace и доступны сразу после `helmfile apply`.  

## helm/values

- **blue/** — values для релизов слота Blue (backend, frontend, nginx), обслуживающего продакшн-домен.  
- **green/** — values для релизов слота Green, куда выкатывается новая версия для тестирования перед переключением.  
- **canary/** — values для canary-выкатов; содержат настройки стратегии `canary.steps` для Argo Rollouts.  
- **values-dev/** — упрощённые values для локальной разработки и тестового окружения.  

- **backend.yaml** — общие значения для backend-сервиса.  
- **frontend.yaml** — общие значения для frontend.  
- **nginx.yaml** — базовый конфиг nginx-прокси.  
- **postgres.yaml** — параметры PostgreSQL.  
- **jaeger.yaml** — конфиг системы трассировки.  
- **swagger.yaml** — конфиг swagger-ui.  

### Использование общих values для stage и prod

В проекте применяется единый values-файл для обоих окружений.  
Это упрощает конфигурацию и соответствует выбранному паттерну: stage и prod всегда работают на одном теге.  

Следствие: отсутствует привычное разделение «stage → проверка → prod», обновления накатываются одновременно.  
В масштабируемых GitOps-проектах рекомендовано использовать раздельные values для независимого управления окружениями.

---

# Требования перед запуском

1. **Helm (v3)** — менеджер пакетов для Kubernetes.  
   Устанавливает чарты в кластер.  

2. **Helmfile** — управление группой релизов Helm.  
   Работает с `helmfile.dev.gotmpl` и `helmfile.prod.gotmpl`.  

3. **Helm Diff Plugin** — показывает разницу между текущим состоянием и новым (`helm plugin install https://github.com/databus23/helm-diff`).  
   Нужен для команды `make diff`.  

4. **kubectl** — CLI для работы с Kubernetes.  
   Helm и Helmfile используют kubeconfig для подключения к кластеру.  

5. **Make** — для запуска команд через `Makefile`.  

6. **Argo Rollouts CRD** — должен быть установлен в кластере (ставится через [gitops-argocd-platform-health-api](https://github.com/vikgur/gitops-argocd-platform-health-api)).  

7. **DevSecOps утилиты** — для целей `make scan` и `make opa` нужны `trivy`, `checkov`, `conftest`.  

8. **Доступ к кластеру Kubernetes** — рабочий kubeconfig, чтобы Helmfile мог деплоить релизы.  

---

# Инструкция по запуску (Makefile)

## Подготовка

Перед запуском задать версию образа:

```bash
export VERSION=1.0.0
```

По умолчанию используется `ENV=dev`. Для продакшена указывать `ENV=blue`, `ENV=green` или `ENV=canary`.

## Основные команды

* `make apply ENV=dev` — раскатать все релизы в dev.
* `make apply ENV=blue VERSION=...` — раскатать релизы в prod (blue).
* `make apply ENV=green VERSION=...` — раскатать релизы в prod (green).
* `make apply ENV=canary VERSION=...` — раскатать релизы в prod (canary).
* `make diff ENV=dev` — показать разницу перед применением.
* `make template ENV=dev` — срендерить манифесты без применения.

## Blue/Green (prod)

* `make deploy-blue VERSION=...` — развернуть backend, frontend и nginx в слоте blue.
* `make deploy-green VERSION=...` — развернуть backend, frontend и nginx в слоте green.

## Canary (prod)

* `make deploy-canary VERSION=...` — раскатать новый релиз backend/frontend/nginx с постепенным переводом трафика.

## Проверки и политика

* `make lint-all` — прогнать helm lint по всем чартам.
* `make lint-svc` — прогнать helm lint по backend/frontend/nginx.
* `make scan` — запуск Trivy и Checkov для статического анализа.
* `make opa` — проверка политик Conftest (OPA) для helm-чартов.

---

# Реализация Blue/Green и Canary

* У каждого сервиса (backend, frontend, nginx) используется **один Rollout** (вместо двух отдельных Deployment).  
* В Helmfile деплоится один релиз на сервис, который управляется Argo Rollouts.  
* При Blue/Green Rollout сам создаёт `activeService` и `previewService`.  
  - Продакшн-трафик идёт в `activeService` (например, blue).  
  - Новый релиз поднимается в `previewService` (например, green) и проверяется QA.  
  - После проверки Argo Rollouts переводит трафик на новый слот, старый остаётся как резерв для rollback.  
* При Canary используется стратегия `canary.steps`:  
  - Rollout создаёт несколько ReplicaSet и по шагам переводит часть трафика (10% → 30% → 60% → 100%).  
  - Это позволяет протестировать релиз на боевой нагрузке до полного переключения.  

## Стратегии деплоя

**Blue/Green**  
* Управляется через **Argo Rollouts** (`kind: Rollout`).  
* В кластере поддерживаются два слота: `blue` и `green`.  
* Продовый сервис (`*-active`) указывает только на один из слотов.  
* Новый релиз разворачивается во втором слоте и проходит проверку.  
* После валидации трафик переводится на новый слот, старый остаётся в резерве для rollback и затем обновляется.  

**Canary**  
* Реализован через **Argo Rollouts** (`strategy.canary.steps`).  
* Rollout создаёт несколько ReplicaSet и по шагам переводит часть трафика (например, 10% → 30% → 60% → 100%).  
* Это позволяет проверить стабильность релиза на части боевой нагрузки до полного переключения.  

## Инструкция по деплою

## 1. Blue/Green деплой

Запуск новой версии в отдельном слоте:

```bash
make deploy-blue VERSION=1.0.0
make deploy-green VERSION=1.0.1
```

Argo Rollouts поднимает вторую версию приложения (`blue` или `green`) параллельно с текущей.
Основной сервис (`*-active`) указывает только на один слот.

## 2. Проверка нового релиза

* QA или разработчик проверяет pod’ы нового слота (`*-green` или `*-blue`) в namespace `health-api`.
* Пользовательский трафик по-прежнему идёт в активный слот.

## 3. Переключение трафика

Когда новая версия прошла проверку:

```bash
make apply ENV=green VERSION=1.0.1
```

Argo Rollouts переключает основной сервис (`*-active`) на новый слот.
Старый слот остаётся как резерв для быстрого rollback.

## 4. Canary rollout

Для постепенного перевода трафика используется Argo Rollouts:

```bash
make deploy-canary VERSION=1.0.2
```

Rollout создаёт несколько ReplicaSet и по шагам направляет долю трафика (например, 10% → 30% → 60% → 100%) на новый релиз.
Это позволяет проверить стабильность под боевой нагрузкой до полного переключения.

## 5. Rollback сценарии

Если новый релиз нестабилен:

* **Blue/Green:** переключить трафик обратно на стабильный слот (`make apply ENV=blue VERSION=...` или `make apply ENV=green VERSION=...`).
* **Canary:** остановить rollout на текущем шаге или откатить версию через Argo Rollouts.

Если текущий активный слот обновлён неудачной версией:

1. **Откатить rollout через Argo Rollouts:**

```bash
kubectl argo rollouts undo backend -n health-api
kubectl argo rollouts undo frontend -n health-api
kubectl argo rollouts undo nginx -n health-api
```

2. **Или задать стабильный тег образа и применить заново:**

```bash
export VERSION=v1.0.XX_stable
ENV=blue helmfile -f helmfile.prod.gotmpl apply
# или
ENV=green helmfile -f helmfile.prod.gotmpl apply
```

3. **Если второй слот содержит стабильную версию — переключиться на него:**

```bash
ENV=green VERSION=v1.0.XX_stable helmfile -f helmfile.prod.gotmpl apply
```

4. **Если второй слот удалён — раскатить его заново и переключиться:**

```bash
export VERSION=v1.0.XX_stable
ENV=green helmfile -f helmfile.prod.gotmpl apply
```

5. **После отката:** обновить неактивный слот на стабильный образ, чтобы снова поддерживать два окружения для Blue/Green.

---

# Kubernetes Best Practices в Helm-чартах

В проекте реализованы ключевые best practices из продовой практики топ-компаний:

1. **Probes**  
   readinessProbe, livenessProbe, startupProbe — контроль готовности, зависаний и инициализации.

2. **Resources**  
   `resources.requests` и `resources.limits` заданы — гарантия стабильности.

3. **HPA**  
   Автоматическое масштабирование по CPU и RAM; все параметры вынесены в values и поддерживаются Rollouts.

4. **SecurityContext**  
   `runAsNonRoot`, `runAsUser`, `readOnlyRootFilesystem` — запуск в непривилегированном режиме.

5. **ServiceAccount + RBAC**  
   Сервисы запускаются под отдельными serviceAccount с ограниченными правами (RBAC).

6. **PriorityClass**  
   Назначен `priorityClassName` для управления важностью подов.

7. **Affinity & Spread**  
   Реализованы affinity, nodeSelector и topologySpreadConstraints для балансировки нагрузки.

8. **Lifecycle Hooks**  
   `preStop`/`postStart` — корректное завершение/инициализация.

9. **Graceful Shutdown**  
   Установлен `terminationGracePeriodSeconds` для корректного завершения работы.

10. **ImagePullPolicy**  
   `IfNotPresent` в проде для стабильности, `Always` — только для dev/CI.

11. **InitContainers**  
   В dev используются для ожидания сервисов; миграции БД временно вынесены в отдельный чарт `init-db`.

12. **Volumes / PVC**  
   Подключены тома, при необходимости — персистентные (PVC).

13. **RollingUpdate Strategy**  
   Гарантия безотказного деплоя: `maxSurge: 1`, `maxUnavailable: 0`.

14. **Annotations для rollout**  
   Используются `checksum/config`, `checksum/secret` — перезапуск при изменении.

15. **Tolerations**  
   Поддержка taints, где необходимо.

16. **Helm Helpers**  
   Используются шаблоны в `_helpers.tpl` для DRY, стандартизации имён и лейблов.

17. **Secrets (точечный доступ)**  
   `POSTGRES_PASSWORD` подключён безопасно из Kubernetes Secret через `valueFrom.secretKeyRef`.

18. **Multienv Helmfile**  
   Используются `helmfile.dev.gotmpl` и `helmfile.prod.gotmpl` с разными наборами values-файлов (`values-dev/`, `blue/`, `green/`, `canary/`). Все чарты общие, окружения различаются только конфигурацией.

---

# Внедренные DevSecOps практики

Подход к организации проекта изначально выстроен вокруг безопасного паттерна Blue/Green + Canary. DevSecOps-практики встроены как обязательный слой контроля и автоматических проверок на уровне Helm/Helmfile.

**Для работы проверок требуются:** `helm`, `helmfile`, `helm-diff`, `trivy`, `checkov`, `conftest` (OPA), `gitleaks`, `make`, `pre-commit`

## Архитектура безопасности

* **.gitleaks.toml** — правила поиска секретов, исключения для Helm-шаблонов.
* **.trivyignore** — список ложноположительных срабатываний для сканера misconfigurations.
* **policy/helm/security.rego** — OPA/Conftest-политики (запрет privileged, обязательные ресурсы и др.).
* **policy/helm/security_test.rego** — unit-тесты для политик.
* **.checkov.yaml** — конфиг Checkov для статического анализа Kubernetes-манифестов.
* **Makefile** — цели `lint`, `scan`, `opa` для запуска проверок одной командой.
* **.gitignore** — исключает временные и чувствительные артефакты: tar-образы чартов (`*.tgz`), локальные dev-values, отчёты сканеров, IDE-файлы и зашифрованные values (`*.enc.yaml`, `*.sops.yaml`).  

## Покрытие

### Базовые проверки

* **helm lint** — синтаксис и структура чартов.
* **kubeconform** — валидация against Kubernetes API.
  → Secure SDLC: раннее выявление ошибок.

### Линтеры и SAST

* **checkov**, **trivy config** — анализ Helm/Manifests на небезопасные паттерны.
* **kubesec** — проверка securityContext, capabilities.
  → Соответствие OWASP IaC Security и CIS Benchmarks.

### Policy-as-Code

* **OPA/Conftest** — строгие правила: запрет privileged, runAsNonRoot, ресурсы обязательны.
  → OWASP Top-10: A4 Insecure Design, A5 Security Misconfiguration.

### Конфигурации и безопасность секретов

* **helm-secrets / sops** — шифрование конфиденциальных values.
* **gitleaks** — поиск секретов в коде и коммитах.
  → OWASP: A2 Cryptographic Failures, A3 Injection, A5 Security Misconfiguration.

### Pre-commit

- **.pre-commit-config.yaml** — описывает хуки, которые запускают проверки (`yamllint`, `gitleaks`, `helm lint`, `trivy`, `checkov`, `conftest`) на каждом коммите.  
- Гарантирует, что ошибки и секреты не попадут в Git ещё до запуска CI/CD.  

### CI/CD и инфраструктура

* **Makefile** — единая точка запуска DevSecOps-проверок (`make lint`, `make scan`, `make opa`).
* **Helmfile diff** — dry-run перед раскаткой.
  → OWASP A1 Broken Access Control: минимум ручных действий и ошибок.

## Результат

Внедрены ключевые DevSecOps-практики: линтеры, SAST, Policy-as-Code, поиск секретов, секрет-менеджмент. Обеспечена защита от основных категорий OWASP Top-10 (Security Misconfiguration, Insecure Design, Cryptographic Failures, Broken Access Control, Secrets Management). Конфигурация воспроизводима и безопасна: никакие секреты или артефакты не попадают в Git.

## Запуск проверок

Все проверки объединены в команды:

```bash
make lint-all     # helm lint для всех чартов
make lint-svc     # helm lint для backend/frontend/nginx
make scan         # Trivy + Checkov
make opa          # Conftest (OPA-политики)
```
---

### Соответствие OWASP Top-10

Краткий маппинг практик проекта на OWASP Top-10:

- **A1 Broken Access Control** → управление rollout-стратегиями через Argo Rollouts; единый `activeService` исключает ручные переключения и снижает риск ошибок доступа.  
- **A2 Cryptographic Failures** → секреты не хранятся в values; поиск утечек через gitleaks; (опционально) helm-secrets/sops для шифрования.  
- **A3 Injection** → отсутствие hardcoded credentials; линтеры и статический анализ (helm lint, trivy config, checkov).  
- **A4 Insecure Design** → OPA/Conftest-политики: запрет privileged, обязательные ресурсы, runAsNonRoot.  
- **A5 Security Misconfiguration** → helm lint, kubeconform, checkov; deny by default для ingress и сервисов.  
- **A6 Vulnerable and Outdated Components** → фиксированные версии чартов и образов; сканирование через trivy.  
- **A7 Identification and Authentication Failures** → секреты реестра GHCR хранятся безопасно; доступ к Helm/Helmfile управляется через kubeconfig с RBAC кластера.  
- **A8 Software and Data Integrity Failures** → helmfile diff и CI/CD пайплайн; подписи образов (cosign при использовании GHCR).  
- **A9 Security Logging and Monitoring Failures** → observability сервисы (jaeger, prometheus) присутствуют; централизованное логирование (например, Loki) в планах.  
- **A10 SSRF** → неприменимо к Helm/Helmfile; контролируется на уровне приложения и WAF.  
