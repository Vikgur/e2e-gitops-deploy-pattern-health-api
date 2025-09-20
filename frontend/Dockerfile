FROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html/ui

# Метки для Argo Image Updater
LABEL org.opencontainers.image.source="https://github.com/vik-devops-lab/health-api-monorepo"
LABEL org.opencontainers.image.revision=$GIT_COMMIT
LABEL org.opencontainers.image.created=$BUILD_DATE