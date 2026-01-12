# Etapa 1: build
FROM node:22-alpine AS builder

WORKDIR /app

# Copia manifests primeiro (melhor cache)
COPY package*.json ./

# Instala dependências (mantendo seu --legacy-peer-deps)
RUN npm install --legacy-peer-deps

# Copia o restante do projeto
COPY . .

# Gera build de produção
RUN npm run build


# Etapa 2: imagem final (runtime)
FROM node:22-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copia apenas o necessário para rodar
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next

# Instala só deps de produção
RUN npm install --omit=dev --legacy-peer-deps

EXPOSE 3000
CMD ["npm", "start"]
