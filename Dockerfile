# Etapa 1: build
FROM node:18-alpine AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia apenas os arquivos essenciais para instalar dependências
COPY package*.json ./

# Instala dependências (sem dev se preferir apenas prod build)
RUN npm ci

# Copia todo o restante do projeto
COPY . .

# Build do projeto
RUN npm run build

# Etapa 2: imagem final para produção
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV production

# Copia apenas os arquivos necessários do builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

# Instala apenas dependências de produção
RUN npm ci --omit=dev

# Porta padrão usada pelo Next.js
EXPOSE 3000

# Comando de inicialização
CMD ["npm", "start"]
