# n8n with Crytic Medusa Integration

This setup provides n8n workflow automation with integrated Crytic Medusa fuzzing capabilities.

## Prerequisites

1. **Medusa Source Code**: Place the medusa source code in a `medusa/` directory in this project root
2. **Docker and Docker Compose**: For local development

## Quick Start

### 1. Prepare Medusa Source
```bash
# Clone medusa source into the project
git clone https://github.com/crytic/medusa.git medusa/
```

### 2. Build and Run
```bash
# Build the custom image
docker build -f Dockerfile.n8n-medusa -t n8n-medusa .

# Run with docker-compose
cp docker-compose.medusa.yml docker-compose.yml
docker-compose up -d
```

### 3. Access n8n
- Local development: http://localhost:5678

## Available Tools in Container

The custom image includes:
- **n8n**: Workflow automation platform
- **medusa**: Smart contract fuzzing tool
- **slither**: Static analysis for Solidity
- **Python 3**: With solc-select and other dependencies
- **Node.js/npm/yarn**: JavaScript package management

## Using Medusa in n8n Workflows

You can create n8n workflows that utilize medusa for smart contract testing:

1. **Execute Command Node**: Run `medusa fuzz --config /path/to/config.json`
2. **File Operations**: Read/write medusa configuration and results
3. **HTTP Requests**: Integrate with external APIs for contract deployment

## Volume Mounts

- `n8n_data`: Persistent n8n workflow and configuration data
- `./contracts`: Smart contracts directory (mounted read-only)

## Security Considerations

The container includes `SYS_PTRACE` capability which medusa may require for certain operations. Remove this if not needed for your use case.

## Environment Variables

Create a `.env` file (optional):
```bash
GENERIC_TIMEZONE=Europe/Berlin
```