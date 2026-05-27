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

FROM node:20-alpine AS prod-deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev \
    && npm dedupe --omit=dev \
    && node -e "\
      const check=(n,fn)=>{const v=require(n+'/package.json').version; console.log(n,v); if(!fn(v)) throw new Error(n+' '+v);};\
      check('tar',v=>!v.startsWith('6.'));\
      check('glob',v=>!v.startsWith('10.4.'));\
      check('minimatch',v=>v!=='9.0.5');\
      check('cross-spawn',v=>v!=='7.0.3');\
    " \
    && npm cache clean --force

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

RUN apk upgrade --no-cache

# package-lock.json is not needed at runtime; omitting it avoids Trivy reading stale lock metadata.
COPY package.json ./
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]
