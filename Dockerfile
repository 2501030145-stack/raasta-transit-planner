FROM node:22-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts --no-audit --no-fund

COPY server.js index.html app.js api-service.mjs route-service.mjs styles.css ui-effects.js ./
COPY data ./data
COPY public ./public

ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
