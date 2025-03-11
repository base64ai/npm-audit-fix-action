FROM node:22-alpine

LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker version of npm-audit-fix-action that supports Node.js 22 and npm 11"

# Install git and other dependencies
RUN apk add --no-cache git openssh

# Install npm 11 specifically
RUN npm install -g npm@11

# Verify versions
RUN node -v && npm -v

# Set working directory
WORKDIR /action

# Copy all source files first
COPY . .

# Install dependencies
RUN npm ci

# Set entrypoint
RUN chmod +x /action/docker-entrypoint.sh

ENTRYPOINT ["/action/docker-entrypoint.sh"] 