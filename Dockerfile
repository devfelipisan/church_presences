# Etapa 1: Construção das Dependências do Backend (backend-builder)
FROM node:lts-alpine AS backend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# Etapa 2: Construção das Dependências do Frontend (frontend-builder)
FROM node:lts-alpine AS frontend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# Final Stage: Combine Frontend and Backend
FROM node:lts-alpine AS final
WORKDIR /app

# Copy Frontend Build Artifacts
COPY --from=frontend-builder /app/node_modules ./node_modules
COPY ./frontend/dist .

# Copy Backend Code
COPY ./backend .

# Exposição da Porta do Backend
EXPOSE 5000

# Definição do Usuário (opcional, depende dos requisitos do seu aplicativo)
RUN chown -R node:node /app

# Escolha do Comando Backend ou Frontend com Base na Variável de Ambiente
ENV ENVIRONMENT=backend

CMD ["sh", "-c", "if [[ $ENVIRONMENT == 'backend' ]]; then \
  yarn start:dev; \
else \
  yarn serve; \
fi"]
