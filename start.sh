#!/bin/sh

# Iniciando o backend
cd /backend
npm run start:dev &

# Iniciando o frontend
cd /frontend
npm run dev &

# Esperando ambos os processos terminarem
wait -n

# Capturando o código de saída
exit $?
