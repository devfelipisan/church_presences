FROM node:lts-alpine AS base

WORKDIR /app

# Install Node.js dependencies (common for both frontend and backend)
RUN npm install -g npm@10.8.1 --force
RUN apk add --no-cache https://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/apk-tools-stable-8.0.1-r0.apk https://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/docker-gen-0.14.0-r1.apk
RUN apk update && apk add --no-cache docker-gen

# Build and copy backend code
COPY Dockerfile.backend ./
RUN ["docker-gen", "yaml", "-o", "./backend/Dockerfile", "./backend/Dockerfile.template"]
RUN yarn install --cwd backend
COPY backend/ .

# Build and copy frontend code
COPY Dockerfile.frontend ./
RUN ["docker-gen", "yaml", "-o", "./frontend/Dockerfile", "./frontend/Dockerfile.template"]
RUN yarn install --cwd frontend
COPY frontend/ .

# Define environment variables
ENV NAME="My Application"
ENV NODE_ENV=development

EXPOSE 5000 3000

# Create separate services using multi-stage builds
FROM base AS backend
WORKDIR /app/backend

CMD ["yarn", "start:dev"]

FROM base AS frontend
WORKDIR /app/frontend

CMD ["yarn", "dev"]
