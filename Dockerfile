# Etapa 1: build
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

# Instala dependências ignorando conflitos de peer deps
RUN npm install --legacy-peer-deps

COPY . .

# Gera build de produção
RUN npm run build

# Etapa 2: imagem final
FROM node:18-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copia apenas o necessário
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

# Instala dependências de produção (também ignorando conflitos)
RUN npm install --omit=dev --legacy-peer-deps

EXPOSE 3000

CMD ["npm", "start"]
