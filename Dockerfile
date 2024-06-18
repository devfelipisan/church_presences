# Primeiro estágio: Construção do backend
FROM node:lts-alpine as backend-builder

WORKDIR /backend

COPY /backend/package*.json ./
RUN apk update && apk add graphicsmagick ghostscript
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm install

COPY /backend ./
RUN npm run build

# Segundo estágio: Construção do frontend
FROM node:lts-alpine as frontend-builder

WORKDIR /frontend

COPY /frontend/package*.json ./
RUN npm install

COPY /frontend ./
RUN npm run build

# Estágio final: Contêiner de produção
FROM node:lts-alpine

# Copiando o backend do estágio de construção
COPY --from=backend-builder /backend /backend

# Copiando o frontend do estágio de construção
COPY --from=frontend-builder /frontend /frontend

# Script de entrada para iniciar ambos os serviços
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expondo as portas
EXPOSE 3000
EXPOSE 5000

# Comando para iniciar o script de entrada
CMD ["/start.sh"]
