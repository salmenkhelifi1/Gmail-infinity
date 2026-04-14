#!/bin/bash
# Gmail Infinity Factory 2026 - Sandbox Launcher

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}   GMAIL INFINITY FACTORY - SECURE LAUNCHER    ${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH.${NC}"
    echo -e "${YELLOW}Tip: Ensure OrbStack or Docker Desktop is running.${NC}"
    exit 1
fi

# Initialize directories if they don't exist
echo -e "${BLUE}[1/3]${NC} Preparing persistent volumes..."
mkdir -p config logs credentials output
if [ ! -f config/proxies.txt ]; then
    echo "http://127.0.0.1:8080" > config/proxies.txt
    echo -e "${YELLOW}Created sample config/proxies.txt${NC}"
fi

# Build the sandbox
echo -e "${BLUE}[2/3]${NC} Building secure sandbox (this may take a minute)..."
docker compose build

# Run the sandbox
echo -e "${BLUE}[3/3]${NC} Starting factory in sandbox mode..."
echo -e "${GREEN}SUCCESS: Entering isolated TUI environment.${NC}"
echo -e "${YELLOW}-----------------------------------------------${NC}"

docker compose run --rm app
