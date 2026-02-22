#!/bin/bash

# OmniAntigravity Remote Chat - Mac/Linux Launcher
echo "==================================================="
echo "  OmniAntigravity Remote Chat Launcher"
echo "==================================================="

# Check for .env file
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "[INFO] .env file not found. Creating from .env.example..."
        cp .env.example .env
        echo "[SUCCESS] .env created from template!"
        echo "[ACTION] Please update .env if you wish to change defaults."
        echo ""
    fi
fi

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "[ERROR] Node.js is not installed. Please install Node.js 16+ to continue."
    exit 1
fi

# Launch using Node.js launcher (no Python needed)
echo "[INFO] Starting OmniAntigravity Remote Chat..."
node launcher.js --mode local

# Keep terminal open if server crashes
echo ""
echo "[INFO] Server stopped."
read -p "Press Enter to exit..."
