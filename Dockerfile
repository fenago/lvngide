# CodeSphere IDE - Production Dockerfile
# Multi-stage build for optimized deployment

# Stage 1: Build stage
FROM node:20-bullseye as builder

# Install system dependencies required for native modules
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    pkg-config \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# Copy workspace package.json files
COPY applications/browser/package.json ./applications/browser/
COPY applications/electron/package.json ./applications/electron/
COPY theia-extensions/product/package.json ./theia-extensions/product/

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy source code
COPY . .

# Build the extensions
RUN yarn build:extensions

# Build the browser application
RUN cd applications/browser && yarn build

# Download plugins
RUN yarn download:plugins || true

# Stage 2: Production stage
FROM node:20-bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    vim \
    nano \
    libxkbfile1 \
    libsecret-1-0 \
    && rm -rf /var/lib/apt/lists/*

# Create app user for security
RUN useradd -m -u 1001 -s /bin/bash theia

# Set working directory
WORKDIR /app

# Copy built application from builder
COPY --from=builder --chown=theia:theia /app /app

# Create plugins directory
RUN mkdir -p /app/plugins && chown -R theia:theia /app/plugins

# Switch to non-root user
USER theia

# Expose port
EXPOSE 3000

# Environment variables
ENV NODE_ENV=production \
    PORT=3000 \
    SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/app/plugins

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start the application
CMD ["node", "applications/browser/src-gen/backend/main.js", "/app", "--hostname=0.0.0.0", "--port=3000"]