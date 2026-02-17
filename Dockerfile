# Brug det neutrale 'node:alpine'. Docker finder selv ud af arkitekturen.
FROM node:alpine AS development-dependencies-env
COPY . /app
WORKDIR /app
RUN npm ci

FROM node:alpine AS production-dependencies-env
COPY ./package.json package-lock.json /app/
WORKDIR /app
# --omit=dev sørger for at imaget bliver mindre
RUN npm ci --omit=dev

FROM node:alpine AS build-env
COPY . /app/
COPY --from=development-dependencies-env /app/node_modules /app/node_modules
WORKDIR /app
RUN npm run build

# Det endelige image (Runtime)
FROM node:alpine
ENV NODE_ENV=production

WORKDIR /app
COPY ./package.json package-lock.json /app/
COPY --from=production-dependencies-env /app/node_modules /app/node_modules
COPY --from=build-env /app/build /app/build

# Kør som 'node' brugeren (sikkerhedsmæssigt bedst)
USER node

CMD ["npm", "run", "start"]
