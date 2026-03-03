#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="/Volumes/Data/_ai/_mcp/mcp_stuff/proxmox-mcp-server"
ENV_FILE="$SERVER_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: Missing Proxmox env file: $ENV_FILE"
    echo "Create it from template:"
    echo "  cp $SERVER_DIR/.env.example $ENV_FILE"
    echo "Then set PROXMOX_HOST, PROXMOX_USER, and PROXMOX_TOKEN."
    exit 1
fi

# Check if Proxmox MCP server is available
if [ -d "$SERVER_DIR" ]; then
    cd "$SERVER_DIR"

    PYTHON_BIN="python3"
    if [ -x "./venv/bin/python" ]; then
        PYTHON_BIN="./venv/bin/python"
    fi

    if ! PYTHONPATH=./src "$PYTHON_BIN" -c "import mcp" >/dev/null 2>&1; then
        echo "ERROR: Python package 'mcp' is missing in $PYTHON_BIN environment."
        echo "Rebuild the local venv and install dependencies, then rerun this wrapper."
        echo "Example:"
        echo "  cd $SERVER_DIR"
        echo "  ./bootstrap.sh --recreate"
        exit 1
    fi

    exec env PYTHONPATH=./src "$PYTHON_BIN" -m proxmox_mcp.cli run proxmox_mcp_config.json
else
    echo "Proxmox MCP server not found at $SERVER_DIR."
    exit 1
fi
