#!/bin/bash
# Gmail Infinity Factory 2026 - LOCAL NATIVE LAUNCHER

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}   GMAIL INFINITY FACTORY - NATIVE LAUNCHER    ${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed.${NC}"
    exit 1
fi

# Initialize Virtual Environment
if [ ! -d ".venv" ]; then
    echo -e "${BLUE}[1/3]${NC} Creating virtual environment..."
    python3 -m venv .venv
fi

source .venv/bin/activate

# Install dependencies
echo -e "${BLUE}[2/3]${NC} Syncing dependencies (this may take a minute)..."
pip install --upgrade pip
pip install -r requirements.txt

# Install Playwright
echo -e "${BLUE}[3/3]${NC} Ensuring browser drivers are ready..."
playwright install chromium

echo -e "${GREEN}SUCCESS: Environment is ready.${NC}"
echo -e "${YELLOW}-----------------------------------------------${NC}"
echo -e "Starting Gmail Infinity Factory..."

python3 main.py
