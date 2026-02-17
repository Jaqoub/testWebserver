# Brug --platform=$BUILDPLATFORM for at gøre filen agnostisk
FROM --platform=$BUILDPLATFORM node:alpine AS development-dependencies-env
COPY . /app
WORKDIR /app
RUN npm ci

FROM --platform=$BUILDPLATFORM node:alpine AS production-dependencies-env
COPY ./package.json package-lock.json /app/
WORKDIR /app
RUN npm ci --omit=dev

FROM --platform=$BUILDPLATFORM node:alpine AS build-env
COPY . /app/
COPY --from=development-dependencies-env /app/node_modules /app/node_modules
WORKDIR /app
RUN npm run build

# Slut-image (Runtime)
FROM --platform=$TARGETPLATFORM node:alpine
# Tilføj labels eller miljøvariabler hvis nødvendigt
ENV NODE_ENV=production

WORKDIR /app
COPY ./package.json package-lock.json /app/
COPY --from=production-dependencies-env /app/node_modules /app/node_modules
COPY --from=build-env /app/build /app/build

# Det er god skik at køre som en non-root bruger i produktion
USER node

CMD ["npm", "run", "start"]
