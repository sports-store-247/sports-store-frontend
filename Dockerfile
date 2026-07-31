# ---------------------------------------------------------------------
# Stage 1: build the static assets
# ---------------------------------------------------------------------
FROM node:22-alpine AS build

WORKDIR /app

# Copy only the manifest files first so this layer is cached and reused
# on rebuilds unless a dependency actually changed. `npm ci` (not
# `npm install`) installs exactly what's in the lockfile, which is what
# you want for a reproducible, automated build.
COPY package.json package-lock.json ./
RUN npm ci

# Now bring in the rest of the source and produce the production build.
# Vite writes fingerprinted static files to /app/dist.
COPY . .
RUN npm run build

# ---------------------------------------------------------------------
# Stage 2: serve the build output with NGINX
# ---------------------------------------------------------------------
FROM nginx:stable-alpine AS runtime

# SPA fallback so client-side routes (e.g. /products/slug) resolve to
# index.html instead of 404ing on a hard refresh — see nginx.conf.
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

# The base image's worker processes already run as the unprivileged
# `nginx` user; only the master process needs root, to bind port 80.
# (CMD is inherited from the base image: `nginx -g "daemon off;"`.)
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1
