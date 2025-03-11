FROM node:22-alpine

LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker version of npm-audit-fix-action that supports Node.js 22 and npm 10"

# Install git and other dependencies
RUN apk add --no-cache git openssh

# Install npm 10 specifically
RUN npm install -g npm@10

# Verify versions
RUN node -v && npm -v

# Set working directory
WORKDIR /action

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy action code
COPY lib/ ./lib/
COPY dist/ ./dist/

# Set entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"] 