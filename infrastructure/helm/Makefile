# Переменные
ENV ?= dev
VERSION ?= latest

# Основные команды
lint-all:
	helm lint ./charts/*

lint-svc:
	helm lint ./backend ./frontend ./nginx

template:
	helmfile -f helmfile.$(ENV).gotmpl -e $(ENV) template

apply:
	ENV=$(ENV) VERSION=$(VERSION) helmfile -f helmfile.$(ENV).gotmpl -e $(ENV) apply

diff:
	ENV=$(ENV) VERSION=$(VERSION) helmfile -f helmfile.$(ENV).gotmpl -e $(ENV) diff

# Упрощённые команды для прод
deploy-blue:
	ENV=blue VERSION=$(VERSION) helmfile -f helmfile.prod.gotmpl apply

deploy-green:
	ENV=green VERSION=$(VERSION) helmfile -f helmfile.prod.gotmpl apply

deploy-canary:
	ENV=canary VERSION=$(VERSION) helmfile -f helmfile.prod.gotmpl apply

# Dev окружение
deploy-dev:
	ENV=dev VERSION=$(VERSION) helmfile -f helmfile.dev.gotmpl apply

# DevSecOps проверки
scan:
	trivy config ./helm
	checkov -d ./helm

opa:
	conftest test -p policy/helm ./helm --all-namespaces

.PHONY: lint-all lint-svc scan opa template apply diff deploy-blue deploy-green deploy-canary deploy-dev
