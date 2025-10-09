# ===========================
# ---- Build Stage ----
# ===========================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Install dependencies separately to leverage caching
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Build the application (e.g., NestJS, TypeScript)
RUN npm run build

# ===========================
# ---- Runtime Stage ----
# ===========================
FROM node:20-alpine

# Security: update system packages to latest patch
RUN apk upgrade --no-cache

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /usr/src/app

# Copy built app from builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev && \
    npm cache clean --force && \
    rm -rf /root/.npm /root/.cache

# Ensure latest npm security patches for transitive deps
RUN npm audit fix --force || true

# Set ownership to non-root user
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

# Expose API port
EXPOSE 8000

# Use non-root node process
CMD ["node", "dist/main.js"]
