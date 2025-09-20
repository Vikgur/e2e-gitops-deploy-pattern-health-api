# === STAGE 1: Build dependencies ===
FROM python:3.12-slim AS builder

WORKDIR /install
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install/deps -r requirements.txt

# === STAGE 2: Final image ===
FROM python:3.12-slim

# Добавляем curl только если нужно для healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Устанавливаем зависимости из builder'а
COPY --from=builder /install/deps /usr/local

# Копируем только нужный код (и app/ и migrations/ — если нужно)
COPY app/ ./app/

# (опционально) Папка миграций
# RUN mkdir -p /app/migrations

# Healthcheck
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=2 \
  CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080

# Команда запуска
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app.app:app"]

# Метки для Argo Image Updater
LABEL org.opencontainers.image.source="https://github.com/vik-devops-lab/health-api-monorepo"
LABEL org.opencontainers.image.revision=$GIT_COMMIT
LABEL org.opencontainers.image.created=$BUILD_DATE

