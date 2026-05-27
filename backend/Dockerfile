## Parko API (NestJS) — multi-stage build
##
## Notes:
## - Runtime image does not run `npm install` from scratch.
## - Unique image tags should be applied by CI (e.g. git SHA); never use `latest`.
##

FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

# Keep image small: only prod deps + dist + package.json
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]

