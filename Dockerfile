# Etapa 1: build
FROM node:18-alpine AS builder

WORKDIR /app

# Copia apenas os arquivos necessários para instalar dependências
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia o restante do projeto
COPY . .

# Build do projeto
RUN npm run build

# Etapa 2: imagem final
FROM node:18-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copia apenas o necessário do builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

# Instala apenas dependências de produção
RUN npm install --omit=dev

EXPOSE 3000

CMD ["npm", "start"]
