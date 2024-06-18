# Utilizando uma imagem base comum
FROM node:lts-alpine

# Definindo o diretório de trabalho para o backend
WORKDIR /backend

# Copiando e instalando as dependências do backend
COPY /backend/package*.json ./
RUN apk update && apk add graphicsmagick ghostscript
RUN npm install

# Copiando o código-fonte do backend
COPY /backend ./

# Definindo o diretório de trabalho para o frontend
WORKDIR /frontend

# Copiando e instalando as dependências do frontend
COPY /frontend/package*.json ./
RUN npm install

# Copiando o código-fonte do frontend
COPY /frontend ./

# Script de entrada para iniciar ambos os serviços
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expondo as portas
EXPOSE 3000
EXPOSE 5000

# Comando para iniciar o script de entrada
CMD ["/start.sh"]
