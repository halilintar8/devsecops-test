# ===========================
# ---- Build Stage ----
# ===========================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Install dependencies separately (for better layer caching)
COPY package*.json ./
RUN npm ci --ignore-scripts

# Copy app source
COPY . .

# Build the application (e.g., NestJS / TypeScript)
RUN npm run build

# Remove dev dependencies to reduce final image size
RUN npm prune --omit=dev

# ===========================
# ---- Runtime Stage ----
# ===========================
FROM node:20-alpine

# 1️⃣ Security: update base system packages
RUN apk upgrade --no-cache && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# 2️⃣ Create a non-root user for least privilege
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 3️⃣ Set working directory
WORKDIR /usr/src/app

# 4️⃣ Copy only necessary build artifacts and dependencies
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules

# 5️⃣ Force update npm and fix vulnerabilities if any
RUN npm install -g npm@latest && \
    npm audit fix --force || true && \
    npm cache clean --force && \
    rm -rf /root/.npm /root/.cache

# 6️⃣ Adjust file permissions
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

# 7️⃣ Expose API port
EXPOSE 8000

# 8️⃣ Start app safely using dumb-init (prevents zombie processes)
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"]
