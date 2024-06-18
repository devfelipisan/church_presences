FROM node:lts-alpine AS backend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM node:lts-alpine AS frontend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM node:lts-alpine AS final
WORKDIR /app

COPY --from=frontend-builder /app/node_modules ./node_modules
COPY ./frontend/dist .  # Supondo que a saída compilada do frontend esteja em frontend/dist

COPY ./backend .

EXPOSE 5000

RUN chown -R node:node /app

ENV ENVIRONMENT=backend  # Ambiente padrão (pode ser substituído em tempo de execução)

CMD [
    "sh", "-c",
    "if [[ $ENVIRONMENT == 'backend' ]]; then \
        yarn start:dev; \
    else \
        yarn serve; \
    fi"
]
