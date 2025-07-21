# Multi-stage build for n8n with Medusa

## Medusa build process
FROM golang:1.23 AS medusa-builder

# Note: You'll need to have medusa source code available
# This assumes medusa source is in ./medusa directory
WORKDIR /src
COPY medusa/ /src/medusa/
RUN cd medusa && \
    go build -trimpath -o=/usr/local/bin/medusa -ldflags="-s -w" && \
    chmod 755 /usr/local/bin/medusa

## Python dependencies for Medusa
FROM ubuntu:noble AS python-builder
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-suggests --no-install-recommends \
        gcc \
        python3 \
        python3-dev \
        python3-venv
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
RUN python3 -m venv /venv && /venv/bin/pip3 install --no-cache --upgrade setuptools pip
RUN /venv/bin/pip3 install --no-cache slither-analyzer solc-select

## Final image based on n8n
FROM docker.n8n.io/n8nio/n8n

USER root

# Install system dependencies for medusa requirements
RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    jq \
    python3 \
    bash \
    nodejs \
    yarn

# Include python tools from builder
COPY --from=python-builder /venv /venv
ENV PATH="$PATH:/venv/bin"

# Include medusa binary
COPY --chown=root:root --from=medusa-builder /usr/local/bin/medusa /usr/local/bin/medusa

# Switch back to n8n user
USER node

# Verify installations
RUN medusa --version && \
    python3 --version && \
    slither --version && \
    node --version && \
    yarn --version