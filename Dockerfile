FROM node:lts-alpine AS base

WORKDIR /app

# Install Node.js dependencies (common for both frontend and backend)
RUN npm install -g yarn

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
